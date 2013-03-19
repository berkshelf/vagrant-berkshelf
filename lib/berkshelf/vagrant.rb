require 'vagrant'
require 'berkshelf'
require 'berkshelf/vagrant/version'
require 'berkshelf/vagrant/errors'

module Berkshelf
  # @author Jamie Winsor <reset@riotgames.com>
  module Vagrant
    autoload :Action, 'berkshelf/vagrant/action'
    autoload :Config, 'berkshelf/vagrant/config'
    autoload :Env, 'berkshelf/vagrant/env'
    autoload :EnvHelpers, 'berkshelf/vagrant/env_helpers'
  end
end

require 'berkshelf/vagrant/plugin'
