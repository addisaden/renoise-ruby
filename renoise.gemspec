# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'renoise/version'

Gem::Specification.new do |spec|
  spec.name          = "renoise"
  spec.version       = Renoise::VERSION
  spec.authors       = ["Adrian Enns"]
  spec.email         = ["addis.aden@gmail.com"]
  spec.summary       = %q{Renoise OSC Control for Ruby}
  spec.description   = %q{Play with your code to make music in Ruby}
  spec.homepage      = "https://github.com/addisaden/renoise-ruby/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_dependency "osc-ruby", "~> 1.1"
end
