module RubyProjection
	def self.find_partial(ctx, pth)
		lookup_context = if defined?(Rails) && ctx.respond_to?(:controller)
			ctx.controller.lookup_context
		elsif defined?(Rails) && ctx.respond_to?(:lookup_context)
			ctx.lookup_context
		end

		if lookup_context
			tmpl = lookup_context.find_template(pth, lookup_context.prefixes, true)
			[tmpl.source, tmpl.identifier]
		else
			[File.read(pth), pth]
		end
	end
end
