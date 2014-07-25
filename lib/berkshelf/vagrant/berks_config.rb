require 'vagrant/util/hash_with_indifferent_access'

module Berkshelf::Vagrant
  class BerksConfig < ::Vagrant::Util::HashWithIndifferentAccess
    class << self
      # @return [String]
      def store_location
        File.join(Berkshelf.berkshelf_path, 'config.json')
      end

      # @return [String]
      def local_location
        ENV['BERKSHELF_CONFIG'] || File.join('.', '.berkshelf', 'config.json')
      end

      # @return [String]
      def path
        path = File.exists?(local_location) ? local_location : store_location
        File.expand_path(path)
      end

      # Instantiate and return or just return the currently instantiated Berkshelf
      # configuration
      #
      # @return [Config]
      def instance
        @instance ||= if File.exists?(path) && File.readable?(path)
          JSON.parse(File.read(path))
        else
          new
        end
      end
    end

    def initialize
      super(chef: ChefConfig.instance, ssl: ::Vagrant::Util::HashWithIndifferentAccess.new(verify: false))
    end

    def chef
      self[:chef]
    end

    def ssl
      self[:ssl]
    end
  end
end
