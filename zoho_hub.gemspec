# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'zoho_hub/version'

Gem::Specification.new do |spec|
  spec.name          = 'zoho_hub'
  spec.version       = ZohoHub::VERSION
  spec.authors       = ['Ricardo Otero']
  spec.email         = ['oterosantos@gmail.com']

  spec.summary       = 'Simple gem to connect to Zoho CRM API V2'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/rikas/zoho_hub'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_dependency 'activesupport', '>= 3'
  spec.add_dependency 'addressable', '~> 2.5'
  spec.add_dependency 'faraday', '~> 0.15'
  spec.add_dependency 'faraday_middleware', '~> 0.12'
  spec.add_dependency 'multi_json', '~> 1.13'
  spec.add_dependency 'rainbow', '~> 3.0'
  spec.add_dependency 'backports' if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.3.0')

  spec.add_development_dependency 'bundler', '>= 1.0.0'
  spec.add_development_dependency 'dotenv', '~> 1.0'
  spec.add_development_dependency 'pry-byebug', '~> 1.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '>= 0.0'
  spec.add_development_dependency 'rubocop-rspec', '>= 0.0'
  spec.add_development_dependency 'simplecov', '>= 0.0'
end
