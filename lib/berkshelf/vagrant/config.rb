module Berkshelf
  module Vagrant
    # @author Jamie Winsor <reset@riotgames.com>
    class Config < ::Vagrant.plugin("2", :config)
      # @return [String]
      #   path to the Berksfile to use with Vagrant
      attr_reader :berksfile_path

      # @return [Array<Symbol>]
      #   only cookbooks in these groups will be installed and copied to
      #   Vagrant's shelf
      attr_accessor :only

      # @return [Array<Symbol>]
      #   cookbooks in all other groups except for these will be installed
      #   and copied to Vagrant's shelf
      attr_accessor :except

      def initialize
        @berksfile_path = UNSET_VALUE
        @except         = UNSET_VALUE
        @only           = UNSET_VALUE
      end

      def finalize!
        @berksfile_path = File.join(Dir.pwd, Berkshelf::DEFAULT_FILENAME) if @berksfile_path == UNSET_VALUE
        @except         = Array.new if @except == UNSET_VALUE
        @only           = Array.new if @only == UNSET_VALUE
      end

      # @param [String] value
      def berksfile_path=(value)
        @berksfile_path = File.expand_path(value)
      end

      # @param [String] value
      def client_key=(value)
        @client_key = File.expand_path(value)
      end

      def validate(machine)
        errors = Array.new

        if !except.empty? && !only.empty?
          errors.add("A value for berkshelf.empty and berkshelf.only cannot both be defined.")
        end

        if Berkshelf::Vagrant.chef_client?(machine.env.config_global)
          if Berkshelf::Config.instance.chef.node_name.nil?
            errors.add("A configuration must be set for chef.node_name when using the chef_client provisioner. Run 'berks configure' or edit your configuration.")
          end

          if Berkshelf::Config.instance.chef.client_key.nil?
            errors.add("A configuration must be set for chef.client_key when using the chef_client provisioner. Run 'berks configure' or edit your configuration.")
          end
        end

        { "berkshelf configuration" => errors }
      end
    end
  end
end
