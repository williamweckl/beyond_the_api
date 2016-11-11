lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'beyond_the_api_test_helpers/version'

Gem::Specification.new do |spec|
  spec.name          = 'beyond_the_api_test_helpers'
  spec.version       = BeyondTheApiTestHelpers::VERSION
  spec.authors       = ['William Weckl']
  spec.email         = ['william.weckl@gmail.com']

  spec.summary       = 'Test helpers for beyond the API.'
  spec.description   = 'Test helpers for beyond the API.'
  spec.homepage      = 'http://rubygems.org/gems/beyond_the_api_test_helpers'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'minitest'
  spec.add_dependency 'mocha'
  spec.add_dependency 'shoulda', '>= 3.5.0'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
end
