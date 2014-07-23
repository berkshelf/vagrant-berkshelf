require 'vagrant/util/hash_with_indifferent_access'
require 'pathname'

module Berkshelf::Vagrant
  class ChefConfig < ::Vagrant::Util::HashWithIndifferentAccess
    class << self
      # Return the most sensible path to the Chef configuration file. This can
      # be configured by setting a value for the 'CHEF_CONFIG' environment
      # variable.
      #
      # @return [String, nil]
      def location
        possibles = []

        possibles << ENV['CHEF_CONFIG'] if ENV['CHEF_CONFIG']
        possibles << File.join(ENV['KNIFE_HOME'], 'knife.rb') if ENV['KNIFE_HOME']
        possibles << File.join(Dir.pwd, 'knife.rb')

        # Ascending search for .chef directory siblings
        Pathname.new(Dir.pwd).ascend do |file|
          sibling_chef = File.join(file, '.chef')
          possibles << File.join(sibling_chef, 'knife.rb')
        end

        possibles << File.join(ENV['HOME'], '.chef', 'knife.rb') if ENV['HOME']
        possibles.compact!

        location = possibles.find { |loc| File.exists?(File.expand_path(loc)) }

        File.expand_path(location) unless location.nil?
      end

      def instance
        @instance ||= from_file(location)
      end

      def from_file(file = nil)
        file = file.nil? ? location : file
        if !file.nil? && File.exist?(file) && File.readable?(file)
          contents = File.read(file)
          return parse(contents, file)
        end

        new
      end

      def parse(contents, path = nil)
        new(contents, path)
      end
    end

    def initialize(contents = "", path = "")
      instance_eval(contents, path)
    end

    def chef_server_url(value = nil)
      set_or_return(:chef_server_url, value)
    end

    def client_key(value = nil)
      set_or_return(:client_key, value)
    end

    def node_name(value = nil)
      set_or_return(:node_name, value)
    end

    def method_missing(m, *args, &block)
      Proxy.new
    end

    private

      def set_or_return(key, value)
        if value.nil?
          return self[key]
        else
          self[key] = value
        end
      end

      class Proxy
        def method_missing(m, *args, &block)
          self
        end
      end
  end
end
