# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'annot/version'

Gem::Specification.new do |gem|
  gem.name          = 'annot'
  gem.version       = Annot::VERSION
  gem.authors       = ['Michael Kuehl']
  gem.email         = ['hello@ratchet.cc']
  gem.description   = %q{Extract annotations}
  gem.summary       = gem.description
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.17'
  gem.add_development_dependency 'rake', '~> 13.0'

  gem.add_dependency 'commander', '~> 4.4.7'
  gem.add_dependency 'nokogiri', '~> 1.10'
end