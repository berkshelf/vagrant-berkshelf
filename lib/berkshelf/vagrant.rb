begin
  require 'vagrant'
rescue LoadError
  raise 'The Vagrant Berkshelf plugin must be run within Vagrant.'
end

require 'berkshelf'
require 'fileutils'
require 'json'
require 'tmpdir'

require_relative 'errors'
require_relative 'version'

module Berkshelf
  # @author Jamie Winsor <reset@riotgames.com>
  module Vagrant
    require_relative 'action'
    require_relative 'config'
    require_relative 'env'
    require_relative 'env_helpers'

    class << self
      # The path to where shelfs are created on the host machine to be mounted in
      # Vagrant guests
      #
      # @return [String]
      def shelf_path
        File.join(Berkshelf.berkshelf_path, 'vagrant')
      end

      # Generate a new shelf to be mounted in a Vagrant guest
      #
      # @return [String]
      #   path to the generated shelf
      def mkshelf(machine_name = nil)

        unless File.exist?(shelf_path)
          FileUtils.mkdir_p(shelf_path)
        end

        if machine_name.nil?
          prefix_suffix = 'berkshelf-'
        else
          prefix_suffix = ['berkshelf-', "-#{machine_name}"]
        end

        Dir.mktmpdir(prefix_suffix, shelf_path)
      end
    end
  end
end

require_relative 'plugin'
