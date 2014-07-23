module Berkshelf
  module Vagrant
    module Action
      class Install
        include Berkshelf::Vagrant::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def call(env)
          if provision_disabled?(env)
            env[:berkshelf].ui.info "Skipping Berkshelf with --no-provision"

            return @app.call(env)
          end

          unless berkshelf_enabled?(env)
            if File.exist?(berksfile_path(env))
              warn_disabled_but_berksfile_exists(env)
            end

            return @app.call(env)
          end

          if chef_solo?(env)
            vendor(env)
          end

          @app.call(env)
        rescue => ex
          raise Berkshelf::VagrantWrapperError.new(ex)
        end

        private

          def vendor(env)
            check_vagrant_version(env)
            env[:berkshelf].ui.info "Updating Vagrant's berkshelf: '#{env[:berkshelf].shelf}'"
            FileUtils.rm_rf(env[:berkshelf].shelf)

            opts                = env[:machine].config.berkshelf.to_hash
            berks_opts          = { berksfile: opts[:berksfile_path] }
            berks_opts[:except] = opts[:except] if opts.has_key?(:except) && !opts[:except].empty?
            berks_opts[:only]   = opts[:only] if opts.has_key?(:only) && !opts[:only].empty?

            env[:berkshelf].ui.info berks("vendor", env[:berkshelf].shelf, berks_opts)
          end

          def warn_disabled_but_berksfile_exists(env)
            env[:berkshelf].ui.warn "Berkshelf plugin is disabled but a Berksfile was found at" +
              " your configured path: #{berksfile_path(env)}"
            env[:berkshelf].ui.warn "Enable the Berkshelf plugin by setting 'config.berkshelf.enabled = true'" +
              " in your vagrant config"
          end

          def check_vagrant_version(env)
            unless vagrant_version_satisfies?(">= 1.5")
              raise UnsupportedVagrantVersion.new(">= 1.5")
            end
          end

          def vagrant_version_satisfies?(requirements)
            Gem::Requirement.new(requirements).satisfied_by? Gem::Version.new(::Vagrant::VERSION)
          end
      end
    end
  end
end
