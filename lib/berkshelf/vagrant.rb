require 'vagrant'
require 'berkshelf'
require 'berkshelf/vagrant/version'
require 'berkshelf/vagrant/errors'
require 'berkshelf/vagrant/plugin'

module Berkshelf
  # @author Jamie Winsor <reset@riotgames.com>
  module Vagrant
    module Action
      autoload :Install, 'berkshelf/vagrant/action/install'
      autoload :Upload, 'berkshelf/vagrant/action/upload'
      autoload :Clean, 'berkshelf/vagrant/action/clean'
      autoload :SetUI, 'berkshelf/vagrant/action/set_ui'
      autoload :Validate, 'berkshelf/vagrant/action/validate'
    end

    autoload :Config, 'berkshelf/vagrant/config'
    autoload :Middleware, 'berkshelf/vagrant/middleware'
    autoload :Provisioner, 'berkshelf/vagrant/provisioner'

    class << self
      # @param [Vagrant::Action::Environment] env
      #
      # @return [String, nil]
      def shelf_for(env)
        return nil if env[:vm].uuid.nil?

        File.join(Berkshelf.berkshelf_path, "vagrant", env[:vm].uuid)
      end

      # @param [Symbol] name
      # @param [Vagrant::Config::Top] config
      #
      # @return [Array]
      def provisioners(name, config)
        config.vm.provisioners.select { |prov| prov.name == name }
      end

      # Determine if the given instance of Vagrant::Config::Top contains a
      # chef_solo provisioner
      #
      # @param [Vagrant::Config::Top] config
      #
      # @return [Boolean]
      def chef_solo?(config)
        provisioners(:chef_solo, config).any?
      end

      # Determine if the given instance of Vagrant::Config::Top contains a
      # chef_client provisioner
      #
      # @param [Vagrant::Config::Top] config
      #
      # @return [Boolean]
      def chef_client?(config)
        provisioners(:chef_client, config).any?
      end
    end
  end
end
