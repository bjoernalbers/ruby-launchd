# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'launchd/version'

Gem::Specification.new do |spec|
  spec.name          = 'launchd'
  spec.version       = Launchd::VERSION
  spec.authors       = ['Björn Albers']
  spec.email         = ['bjoernalbers@gmail.com']

  spec.summary       = 'Control Mac OS X services with Ruby'
  spec.description   = 'Ruby-Launchd is like launchctl (or the famous lunchy). It lets you easily create, start and stop services on Mac OS X, but with Ruby.'
  spec.homepage      = 'https://github.com/bjoernalbers/ruby-launchd'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
