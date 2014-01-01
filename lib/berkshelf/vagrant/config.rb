module Berkshelf
  module Vagrant
    # @author Jamie Winsor <jamie@vialstudios.com>
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
        @node_name      = UNSET_VALUE
        @client_key     = UNSET_VALUE
        @enabled        = UNSET_VALUE
      end

      # @param [String] value
      def berksfile_path=(value)
        @berksfile_path = value
      end

      # @param [String] value
      def client_key=(value)
        @client_key = value
      end

      alias_method :to_hash, :instance_variables_hash

      def finalize!
        # Auto-enable if berskfile_path set manually, and no berkshelf_enabled set
        @enabled = true if @berksfile_path != UNSET_VALUE and @enabled == UNSET_VALUE
        # If that didn't work, auto-enable if there's a local Berkshelf file (like we used to)
        @enabled = File.exist?(File.join(Dir.pwd, Berkshelf::DEFAULT_FILENAME)) if @enabled == UNSET_VALUE
        @berksfile_path = Berkshelf::DEFAULT_FILENAME if @berksfile_path == UNSET_VALUE
        @node_name = Berkshelf::Config.instance.chef.node_name if @node_name == UNSET_VALUE
        @client_key = Berkshelf::Config.instance.chef.client_key if @client_key == UNSET_VALUE
      end

      def validate(machine)
        @berksfile_path = File.expand_path(@berksfile_path, machine.env.root_path.to_s)
        @client_key = File.expand_path(@client_key, machine.env.root_path.to_s)
        errors = Array.new

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

          if machine.env.config_global.vm.provisioners.any? { |prov| prov.name == :chef_client }
            if machine.config.berkshelf.node_name.nil?
              errors << "A configuration must be set for chef.node_name when using the chef_client provisioner. Run 'berks configure' or edit your configuration."
            end

            if machine.config.berkshelf.client_key.nil?
              errors << "A configuration must be set for chef.client_key when using the chef_client provisioner. Run 'berks configure' or edit your configuration."
            end
          end
        end

        { "berkshelf configuration" => errors }
      end
    end
  end
end
