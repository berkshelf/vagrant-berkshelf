module Berkshelf
  module Vagrant
    module Action
      # @author Jamie Winsor <jamie@vialstudios.com>
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
            if File.exist?(env[:machine].config.berkshelf.berksfile_path)
              warn_disabled_but_berksfile_exists(env)
            end

            return @app.call(env)
          end

          env[:berkshelf].berksfile = Berkshelf::Berksfile.from_file(env[:machine].config.berkshelf.berksfile_path)

          if chef_solo?(env)
            install(env)
          end

          @app.call(env)
        rescue Berkshelf::BerkshelfError => e
          raise Berkshelf::VagrantWrapperError.new(e)
        end

        private

          def install(env)
            check_vagrant_version(env)
            env[:berkshelf].ui.info "Updating Vagrant's berkshelf: '#{env[:berkshelf].shelf}'"
            FileUtils.rm_rf(env[:berkshelf].shelf)

            opts = env[:machine].config.berkshelf.to_hash.symbolize_keys
            env[:berkshelf].berksfile.vendor(env[:berkshelf].shelf, opts)
          end

          def warn_disabled_but_berksfile_exists(env)
            env[:berkshelf].ui.warn "Berkshelf plugin is disabled but a Berksfile was found at" +
              " your configured path: #{env[:machine].config.berkshelf.berksfile_path}"
            env[:berkshelf].ui.warn "Enable the Berkshelf plugin by setting 'config.berkshelf.enabled = true'" +
              " in your vagrant config"
          end

          def check_vagrant_version(env)
            unless vagrant_version_satisfies?(">= 1.1")
              raise Berkshelf::VagrantWrapperError.new(RuntimeError.new("vagrant-berkshelf requires Vagrant 1.1 or later."))
            end

            unless vagrant_version_satisfies?(::Berkshelf::Vagrant::TESTED_CONSTRAINT)
              env[:berkshelf].ui.warn "This version of the Berkshelf plugin has not been fully tested on this version of Vagrant."
              env[:berkshelf].ui.warn "You should check for a newer version of vagrant-berkshelf."
              env[:berkshelf].ui.warn "If you encounter any errors with this version, please report them at https://github.com/berkshelf/vagrant-berkshelf/issues"
              env[:berkshelf].ui.warn "You can also join the discussion in #berkshelf on Freenode."
            end
          end

          def vagrant_version_satisfies?(requirement)
            Gem::Requirement.new(requirement).satisfied_by? Gem::Version.new(::Vagrant::VERSION)
          end
      end
    end
  end
end
