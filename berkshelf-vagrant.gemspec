# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "berkshelf-vagrant"
  spec.version       = "1.1.3"
  spec.authors       = [ "Jamie Winsor" ]
  spec.email         = [ "reset@riotgames.com" ]
  spec.description   = %q{Renamed to vagrant-berkshelf}
  spec.summary       = spec.description
  spec.homepage      = "http://berkshelf.com"
  spec.license       = "Apache 2.0"

  spec.files         = []
  spec.required_ruby_version = ">= 1.9.1"

  spec.add_dependency 'vagrant-berkshelf', '>= 1.2.0'
end
