module Berkshelf::Vagrant
  module EnvHelpers
    # @param [Vagrant::Environment] env
    #
    # @return [String, nil]
    def shelf_for(env)
      return nil if env[:machine].id.nil?

      File.join(Berkshelf.berkshelf_path, "vagrant", env[:machine].id)
    end

    # @param [Symbol] name
    # @param [Vagrant::Environment, Hash] env
    #
    # @return [Array]
    def provisioners(name, env)
      config_global = env.respond_to?(:config_global) ? env.config_global : env[:global_config]
      
      config_global.vm.provisioners.select { |prov| prov.name == name }
    end

    # Determine if the given instance of Vagrant::Config::Top contains a
    # chef_solo provisioner
    #
    # @param [Vagrant::Environment] env
    #
    # @return [Boolean]
    def chef_solo?(env)
      provisioners(:chef_solo, env).any?
    end

    # Determine if the given instance of Vagrant::Config::Top contains a
    # chef_client provisioner
    #
    # @param [Vagrant::Environment] env
    #
    # @return [Boolean]
    def chef_client?(env)
      provisioners(:chef_client, env).any?
    end
  end
end
