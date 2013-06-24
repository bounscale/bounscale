# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bounscale/version'

Gem::Specification.new do |gem|
  gem.name          = "bounscale"
  gem.version       = Bounscale::VERSION
  gem.authors       = ["DTS Corporation"]
  gem.email         = ["info@bounscale.com"]
  gem.description   = %q{Rack agent of auto scaling for Heroku by Bounscale.}
  gem.summary       = %q{Rack agent for Bounscale}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'json' 
  gem.add_development_dependency "rspec"
end
