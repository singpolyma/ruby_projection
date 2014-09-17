# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "ruby_projection"
  spec.version       = "0.1.0"
  spec.authors       = ["Stephen Paul Weber"]
  spec.email         = ["singpolyma@singpolyma.net"]
  spec.summary       = "Project particular fields out of ruby objects"
  spec.description   = "Useful as a view helper for generating JSON with Rails, etc"
  spec.homepage      = "https://github.com/singpolyma/ruby_projection"
  spec.license       = "ISC"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
end
