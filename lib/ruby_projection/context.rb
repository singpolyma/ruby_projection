class RubyProjection::Context < OpenStruct
	include RubyProjection

	def eval(source, pth=nil)
		instance_eval(source, *pth)
	end
end
