# -*- encoding: utf-8 -*-
require File.expand_path('../lib/keyring/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["James Reid-Smith"]
  gem.email         = ["sunblaze@gmail.com"]
  gem.description   = "A simple ruby library to help generate and manage redis keys"
  gem.summary       = "A simple ruby library to help generate and manage redis keys"
  gem.homepage      = "https://github.com/sunblaze/redis-keyring"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "redis-keyring"
  gem.require_paths = ["lib"]
  gem.version       = Keyring::VERSION
  
  gem.add_development_dependency "rake", '~> 10.3.0'
  gem.add_development_dependency "rspec", '~> 3.1.0'
end
