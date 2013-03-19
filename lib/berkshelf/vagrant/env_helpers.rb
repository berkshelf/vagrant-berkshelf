module Berkshelf::Vagrant
  # @author Jamie Winsor <reset@riotgames.com>
  #
  # A module of common helper functions that can be mixed into Berkshelf::Vagrant actions
  module EnvHelpers
    # A file to persist berkshelf-vagrant specific information in between
    # Vagrant runs.
    #
    # @return [String]
    def cache_file
      File.join('.vagrant', 'berkshelf')
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
      config_global = env.respond_to?(:config_global) ? env.config_global : env[:global_config]
      
      config_global.vm.provisioners.select { |prov| prov.name == name }
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
  end
end
