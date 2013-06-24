# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'berkshelf/vagrant/version'

Gem::Specification.new do |spec|
  spec.name          = 'vagrant-berkshelf'
  spec.version       = Berkshelf::Vagrant::VERSION
  spec.authors       = [ 'Jamie Winsor', 'Michael Ivey' ]
  spec.email         = [ 'reset@riotgames.com', 'michael.ivey@riotgames.com' ]
  spec.description   = %q{A Vagrant plugin to add Berkshelf integration to the Chef provisioners}
  spec.summary       = spec.description
  spec.homepage      = 'http://berkshelf.com'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 1.9.1'

  spec.add_dependency 'berkshelf', '~> 2.0'

  spec.add_development_dependency 'spork', '~> 0.9'
  spec.add_development_dependency 'rspec', '~> 2.13'
  spec.add_development_dependency 'thor',  '~> 0.18'
end
