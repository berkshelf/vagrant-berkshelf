require 'pathname'
require 'vagrant/util/hash_with_indifferent_access'

module VagrantPlugins
  module Berkshelf
    class Config < Vagrant.plugin("2", :config)
      MAYBE = Object.new.freeze

      # The path to the Berksfile to use.
      # @return [String]
      attr_accessor :berksfile_path

      # Disable the use of Berkshelf in Vagrant.
      # @return [Boolean]
      attr_accessor :enabled

      # The array of cookbook groups to exclusively install during provisioning.
      # @return [Array<Symbol>]
      attr_accessor :only

      # The array of cookbook groups to exclude during provisioning.
      # @return [Array<Symbol>]
      attr_accessor :except

      # An array of additional arguments to pass to the Berkshelf command.
      # @return [Array<String>]
      attr_accessor :args

      def initialize
        super

        @berksfile_path = UNSET_VALUE
        @enabled        = UNSET_VALUE
        @except         = Array.new
        @only           = Array.new
        @args           = Array.new

        @__finalized = false
      end

      def finalize!
        @berksfile_path = nil if @berksfile_path == UNSET_VALUE
        @enabled = MAYBE if @enabled == UNSET_VALUE

        @__finalized = true
      end

      def validate(machine)
        errors = _detected_errors

        if @enabled || @enabled == MAYBE
          # If no Berksfile path was given, check if one is in the working
          # directory
          if !@berksfile_path
            path = File.expand_path("Berksfile", machine.env.root_path)

            if File.exist?(path)
              @enabled = true
              @berksfile_path = path
            end
          end

          # Berksfile_path validations
          if missing?(@berksfile_path)
            errors << "berksfile_path must be set"
          else
            # Expand the path unless it is absolute
            if !Pathname.new(@berksfile_path).absolute?
              @berksfile_path = File.expand_path(@berksfile_path, machine.env.root_path)
            end

            # Ensure the path exists
            if !File.exist?(@berksfile_path)
              errors << "Berksfile at '#{@berksfile_path}' does not exist"
            end
          end
        end

        { "Berkshelf" => errors }
      end

      def to_hash
        raise "Must finalize first." if !@__finalized

        {
          enabled:        @enabled,
          berksfile_path: @berksfile_path,
          except:         @except,
          only:           @only,
          args:           @args,
        }
      end

      def missing?(obj)
        obj.to_s.strip.empty?
      end
    end
  end
end
