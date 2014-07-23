require 'buff/shell_out'
require 'json'
require 'vagrant/util/which'

module Berkshelf
  module Vagrant
    # A module of common helper functions that can be mixed into Berkshelf::Vagrant actions
    module EnvHelpers
      BERKS_CONSTRAINT = ">= 3.0.0"

      include Buff::ShellOut
      include ::Vagrant::Util

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
      # @raise [UnsupportedBerksVersion]
      #   version of Berks installed does not satisfy the application's constraint
      # @raise [BerksNotFound]
      #   berks command is not found in the user's path
      # @raise [BerksError]
      #   CLI command failed
      def berks(command, *args)
        if defined?(Bundler)
          Bundler.with_clean_env { run_berks(command, *args) }
        else
          run_berks(command, *args)
        end
      end

      def berksfile_path(env)
        env[:machine].env.vagrantfile.config.berkshelf.berksfile_path
      end

      # A file to persist vagrant-berkshelf specific information in between
      # Vagrant runs.
      #
      # @return [String]
      def cache_file(env)
        File.expand_path(File.join('.vagrant', 'machines', env[:machine].name.to_s, 'berkshelf'), env[:root_path].to_s)
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
        env[:machine].config.vm.provisioners.select { |prov| prov.name == name }
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

      # Determine if the Berkshelf plugin should be run for the given environment
      #
      # @param [Vagrant::Environment] env
      #
      # @return [Boolean]
      def berkshelf_enabled?(env)
        env[:machine].config.berkshelf.enabled
      end

      # Determine if --no-provision was specified
      #
      # @param [Vagrant::Environment] env
      #
      # @return [Boolean]
      def provision_disabled?(env)
        env.has_key?(:provision_enabled) && !env[:provision_enabled]
      end

      private

        def berks_version_check!
          if (exec = Which.which("berks")).nil?
            raise BerksNotFound
          end

          unless (response = shell_out("#{exec} version -F json")).success?
            raise "Couldn't determine Berks version: #{response.inspect}"
          end

          begin
            version = Gem::Version.new(JSON.parse(response.stdout)["version"])
            Gem::Requirement.new(BERKS_CONSTRAINT).satisfied_by?(version)
            exec
          rescue => ex
            raise UnsupportedBerksVersion.new(exec, BERKS_CONSTRAINT, version)
          end
        end

        def options_to_flags(opts)
          opts.map do |key, value|
            if value.is_a?(TrueClass)
              "--#{key_to_flag(key)}"
              next
            end

            if value.is_a?(FalseClass)
              "--no-#{key_to_flag(key)}"
              next
            end

            if value.is_a?(Array)
              "--#{key_to_flag(key)}=#{value.join(" ")}"
              next
            end

            "--#{key_to_flag(key)}=#{value}"
          end.join(" ")
        end

        def run_berks(command, *args)
          exec      = berks_version_check!
          options   = args.last.is_a?(Hash) ? args.pop : Hash.new
          arguments = args.join(" ")
          flags     = options_to_flags(options)

          command = "#{exec} #{command} #{arguments} #{flags}"
          unless (response = shell_out(command)).success?
            raise BerksError.new("Berks command Failed: #{command}, reason: #{response.stderr}")
          end
          response.stdout
        end

        def key_to_flag(key)
          "#{key.to_s.gsub("_", "-")}"
        end
    end
  end
end
