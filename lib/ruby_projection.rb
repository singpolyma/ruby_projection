require 'ostruct'
require 'ruby_projection/partial'
require 'ruby_projection/context'
require 'ruby_projection/template'

module RubyProjection

	def proj(*args)
		object = args.shift
		object = OpenStruct.new(object) if object.is_a?(Hash)

		return nil if object.nil?

		if object.respond_to?(:map)
			object.map { |x| proj(x, *args) }
		else
			extra = args.last.is_a?(Hash) ? args.pop : {}
			h = args.each_with_object({}) do |k, h|
				h[k] = RubyProjection.get_or_map(k, k, object)
			end
			extra.each_with_object(h) do |(k, v), h|
				h[k] = RubyProjection.get_or_map(k, v, object)
			end
		end
	end

	module_function :proj

	def nested(*args)
		if args.first.is_a?(String)
			source, real_pth = RubyProjection.find_partial(self, args.first)

			lambda do |object|
				locals = RubyProjection.extract_locals(object, *args)
				RubyProjection::Context.new(locals).eval(source, real_pth)
			end
		else
			lambda { |object| proj(object, *args) }
		end
	end

	module_function :nested

	def self.extract_locals(object, *args)
		object_name = args[1].is_a?(Symbol) ? args.delete(1) : args[0].to_sym
		locals = args[1].is_a?(Hash) ? args[1] : {}
		locals = locals[:locals] if locals[:locals]
		locals.merge(object_name => object)
	end

	def self.get_or_map(k, v, object)
		if v.is_a?(Hash) || (v.is_a?(Array) && v.first.is_a?(Hash))
			return self.get_or_map(k, [lambda {|x| x}, [v].flatten.first], object)
		end

		if v.respond_to?(:call)
			v.call(object.public_send(k))
		elsif v.is_a?(Array)
			hsh = v.last
			x = object.public_send(hsh[:from] || k, *hsh[:with])
			v.first.to_proc.call(x)
		else
			object.public_send(v)
		end
	end
end
