class RubyProjectionTemplateHandler
	if respond_to?(:cattr_accessor)
		cattr_accessor :default_format
		self.default_format = 'application/json'
	end

	def self.call(template)
		format = template.formats.first
		"class_eval { include RubyProjection }; (#{template.source}).to_#{format}"
	end
end

if defined?(::ActionView)
	ActionView::Template.register_template_handler :prb, RubyProjectionTemplateHandler
end
