module Berkshelf
  module Vagrant
    # @author Jamie Winsor <jamie@vialstudios.com>
    #
    # A module of common helper functions that can be mixed into Berkshelf::Vagrant actions
    module EnvHelpers
      # A file to persist vagrant-berkshelf specific information in between
      # Vagrant runs.
      #
      # @return [String]
      def cache_file(env)
        File.expand_path(File.join('.vagrant', 'machines', env[:machine].name.to_s, 'berkshelf'), env[:root_path].to_s)
      end

      # Filter all of the provisioners of the given vagrant environment with the given name
      #
      # @param [Symbol] name
      #   name of provisioner to filter
      # @param [Vagrant::Environment, Hash] env
      #   environment to inspect
      #
      # @return [Array]
      def provisioners(name, env)
        env[:machine].config.vm.provisioners.select { |prov| prov.name == name }
      end

      # Determine if the given vagrant environment contains a chef_solo provisioner
      #
      # @param [Vagrant::Environment] env
      #
      # @return [Boolean]
      def chef_solo?(env)
        provisioners(:chef_solo, env).any?
      end

      # Determine if the given vagrant environment contains a chef_client provisioner
      #
      # @param [Vagrant::Environment] env
      #
      # @return [Boolean]
      def chef_client?(env)
        provisioners(:chef_client, env).any?
      end

      # Determine if the Berkshelf plugin should be run for the given environment
      #
      # @param [Vagrant::Environment] env
      #
      # @return [Boolean]
      def berkshelf_enabled?(env)
        env[:machine].env.vagrantfile.config.berkshelf.enabled
      end

      # Determine if --no-provision was specified
      #
      # @param [Vagrant::Environment] env
      #
      # @return [Boolean]
      def provision_disabled?(env)
        env.has_key?(:provision_enabled) && !env[:provision_enabled]
      end
    end
  end
end
