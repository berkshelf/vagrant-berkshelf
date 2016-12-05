require 'json'
require 'vagrant/util'

require_relative 'errors'

module VagrantPlugins
  module Berkshelf
    # A module of common helper functions that can be mixed into Berkshelf::Vagrant actions
    module Helpers
      include Vagrant::Util

      # Execute a berkshelf command with the given arguments and flags.
      #
      # @overload berks(command, args)
      #   @param [String] berks CLI command to run
      #   @param [Object] any number of arguments to pass to CLI
      # @overload berks(command, args, options)
      #   @param [String] berks CLI command to run
      #   @param [Object] any number of arguments to pass to CLI
      #   @param [Hash] options to convert to flags for the CLI
      #
      # @return [String]
      #   output of the command
      #
      # @raise [InvalidBerkshelfVersionError]
      #   version of Berks installed does not satisfy the application's constraint
      # @raise [BerksNotFoundError]
      #   berks command is not found in the user's path
      def berks(command, *args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        args = args.dup

        if options[:berksfile_path]
          args << "--berksfile"
          args << options[:berksfile_path]
        end

        if !options.fetch(:except, []).empty?
          args << "--except"
          args += options[:except]
        end

        if !options.fetch(:only, []).empty?
          args << "--only"
          args += options[:only]
        end

        if options[:freeze] == false
          args << "--no-freeze"
        end

        if options[:force]
          args << "--force"
        end

        if !options.fetch(:args, []).empty?
          args += options[:args]
        end

        final_command = [berks_bin, command, *args]

          r = Subprocess.execute(*final_command)
          if r.exit_code != 0
            raise BerksCommandFailed.new(final_command.join(' '), r.stdout, r.stderr)
          end
          r
      end

      # The path to the Berkshelf binary on disk.
      # @return [String, nil]
      def berks_bin
        Which.which("berks")
      end

      # Filter all of the provisioners of the given vagrant environment with the given name
      #
      # @param [Symbol] name
      #   name of provisioner to filter
      # @param [Vagrant::Environment, Hash] env
      #   environment to inspect
      #
      # @return [Array]
      def provisioners(type, env)
        env[:machine].config.vm.provisioners.select do |provisioner|
          # Vagrant 1.7 changes provisioner.name to provisioner.type
          if provisioner.respond_to? :type
            provisioner.type.to_sym == type
          else
            provisioner.name.to_sym == type
          end
        end
      end

      # Determine if the given vagrant environment contains a chef_solo provisioner
      #
      # @param [Vagrant::Environment] env
      #
      # @return [Boolean]
      def chef_solo?(env)
        provisioners(:chef_solo, env).any?
      end

      # Determine if the given vagrant environment contains a chef_zero provisioner
      #
      # @param [Vagrant::Environment] env
      #
      # @return [Boolean]
      def chef_zero?(env)
        provisioners(:chef_zero, env).any?
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
        env[:machine].config.berkshelf.enabled == true
      end

      # Determine if --no-provision was specified
      #
      # @param [Vagrant::Environment] env
      #
      # @return [Boolean]
      def provision_enabled?(env)
        env.fetch(:provision_enabled, true)
      end

      # The path to the Vagrant Berkshelf data file inside the machine's data
      # directory.
      #
      # @return [String]
      def datafile_path(env)
        env[:machine].data_dir.join("berkshelf")
      end

      #
      # Execute the given command, removing any Ruby-specific environment
      # variables. This is an "enhanced" version of +Bundler.with_clean_env+,
      # which only removes Bundler-specific values. We need to remove all
      # values, specifically:
      #
      # - _ORIGINAL_GEM_PATH
      # - GEM_PATH
      # - GEM_HOME
      # - GEM_ROOT
      # - BUNDLE_BIN_PATH
      # - BUNDLE_GEMFILE
      # - RUBYLIB
      # - RUBYOPT
      # - RUBY_ENGINE
      # - RUBY_ROOT
      # - RUBY_VERSION
      #
      # This will escape Vagrant's environment entirely, which is required if
      # calling an executable that lives in another Ruby environment. The
      # original environment restored at the end of this call.
      #
      # @param [Proc] block
      #   the block to execute with the cleaned environment
      #
      def with_clean_env(&block)
        original = ENV.to_hash

        ENV.delete("_ORIGINAL_GEM_PATH")
        ENV.delete_if { |k,_| k.start_with?("BUNDLE_") }
        ENV.delete_if { |k,_| k.start_with?("GEM_") }
        ENV.delete_if { |k,_| k.start_with?("RUBY") }

        yield
      ensure
        ENV.replace(original.to_hash)
      end
    end
  end
end
