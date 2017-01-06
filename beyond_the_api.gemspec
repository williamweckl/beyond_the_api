lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'beyond_the_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'beyond_the_api'
  spec.version       = BeyondTheApi::VERSION
  spec.authors       = ['William Weckl']
  spec.email         = ['william.weckl@gmail.com']

  spec.summary       = 'API patterns over Rails API.'
  spec.description   = 'API patterns over Rails API.'
  spec.homepage      = 'http://rubygems.org/gems/beyond_the_api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'active_model_serializers', '~> 0.10.4'
  spec.add_dependency 'activesupport', '>= 4.2', '< 5.1'
  spec.add_dependency 'will_paginate', '~> 3.1.5'
  spec.add_dependency 'versionist', '~> 1.5.0'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
end
