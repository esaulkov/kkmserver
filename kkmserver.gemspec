# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('lib')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kkmserver/version'

Gem::Specification.new do |spec|
  spec.name    = 'kkmserver'
  spec.version = Kkmserver::VERSION
  spec.authors       = ['Evgeny Esaulkov']
  spec.email         = ['evg.esaulkov@gmail.com']
  spec.description   = %q{A ruby wrapper for the Kkmserver API}
  spec.summary       = ''
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']
  spec.add_dependency 'dotenv', '~> 2.2.1', '>= 2.2.1'
  spec.add_dependency 'rest-client', '>= 2.0.2'
  spec.add_development_dependency 'rake', '~> 10.4.2', '>= 10.4.2'
  spec.add_development_dependency 'rspec', '~> 3.7.0', '>= 3.7.0'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
