require 'vagrant/util/hash_with_indifferent_access'

module Berkshelf
  module Vagrant
    class Config < ::Vagrant.plugin("2", :config)
      # @return [String]
      #   path to the Berksfile to use with Vagrant
      attr_reader :berksfile_path

      # @return [Boolean]
      #   disable of use Berks in Vagrant
      attr_accessor :enabled

      # @return [Array<Symbol>]
      #   only cookbooks in these groups will be installed and copied to
      #   Vagrant's shelf
      attr_accessor :only

      # @return [Array<Symbol>]
      #   cookbooks in all other groups except for these will be installed
      #   and copied to Vagrant's shelf
      attr_accessor :except

      # @return [String]
      #   the Chef node name (client name) to use to authenticate with the remote
      #   chef server to upload cookbooks when using the chef client provisioner
      attr_accessor :node_name

      # @return [String]
      #   a filepath to a chef client key to use to authenticate with the remote
      #   chef server to upload cookbooks when using the chef client provisioner
      attr_accessor :client_key

      def initialize
        super

        @berksfile_path = UNSET_VALUE
        @except         = Array.new
        @only           = Array.new
        @node_name      = BerksConfig.instance.chef[:node_name]
        @client_key     = BerksConfig.instance.chef[:client_key]
        @enabled        = UNSET_VALUE
      end

      def finalize!
        @berksfile_path = File.join(Dir.pwd, "Berksfile") if @berksfile_path == UNSET_VALUE
        @enabled        = File.exist?(@berksfile_path) if @enabled == UNSET_VALUE
      end

      # @param [String] value
      def berksfile_path=(value)
        @berksfile_path = value
      end

      # @param [String] value
      def client_key=(value)
        @client_key = value
      end

      def to_hash
        ::Vagrant::Util::HashWithIndifferentAccess.new(instance_variables_hash)
      end

      def validate(machine)
        @berksfile_path = File.expand_path(@berksfile_path, machine.env.root_path.to_s)
        @client_key     = File.expand_path(@client_key, machine.env.root_path.to_s)
        errors          = Array.new

        unless [TrueClass, FalseClass].include?(enabled.class)
          errors << "A value for berkshelf.enabled can be true or false."
        end

        if enabled
          if machine.config.berkshelf.berksfile_path.nil?
            errors << "berkshelf.berksfile_path cannot be nil."
          end

          unless File.exist?(machine.config.berkshelf.berksfile_path)
            errors << "No Berksfile was found at #{machine.config.berkshelf.berksfile_path}."
          end

          if !except.empty? && !only.empty?
            errors << "A value for berkshelf.empty and berkshelf.only cannot both be defined."
          end

          if global_provisioners(machine).any? { |prov| prov.name == :chef_client }
            if machine.config.berkshelf.node_name.nil?
              errors << "A configuration must be set node_name when using the chef_client provisioner." +
                        " Edit your berkshelf configuration and add a value for chef.node_name."
            end

            if machine.config.berkshelf.client_key.nil?
              errors << "A configuration must be set for client_key when using the chef_client provisioner." +
                        " Edit your berkshelf configuration and add a value for chef.client_key."
            end
          end
        end

        {"berkshelf configuration" => errors}
      end

      private

        def global_provisioners(machine)
          machine.env.vagrantfile.config.vm.provisioners
        end
    end
  end
end
