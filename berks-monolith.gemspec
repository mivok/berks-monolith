# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'monolith/version'

Gem::Specification.new do |spec|
  spec.name          = "berks-monolith"
  spec.version       = Monolith::VERSION
  spec.authors       = ["Mark Harrison"]
  spec.email         = ["mark@mivok.net"]
  spec.summary       = %q{Berkshelf monolithic repository tools}
  spec.description   = %q{Tools for working with cookbooks as if they were inside a monolithic repository}
  spec.homepage      = "http://github.com/mivok/berks-monolith"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.2'

  spec.add_dependency 'berkshelf', '~> 3.0', '>= 3.0.0'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry', '~> 0.10'
end
