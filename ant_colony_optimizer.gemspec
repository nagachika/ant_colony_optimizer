# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ant_colony_optimizer/version'

Gem::Specification.new do |spec|
  spec.name          = "ant_colony_optimizer"
  spec.version       = AntColonyOptimizer::VERSION
  spec.authors       = ["nagachika"]
  spec.email         = ["nagachika@ruby-lang.org"]

  spec.summary       = %q{Ant Colony Optimizer Library}
  spec.description   = %q{Ant Colony Optimizer Library}
  spec.homepage      = "https://github.com/nagachika/ant_colony_optimizer"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
