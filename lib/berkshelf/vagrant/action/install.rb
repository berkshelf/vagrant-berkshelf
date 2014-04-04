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

          opts = env[:machine].config.berkshelf.to_hash.symbolize_keys
          opts.delete(:except) if opts[:except].empty?
          opts.delete(:only) if opts[:only].empty?
          env[:berkshelf].berksfile = Berkshelf::Berksfile.from_file(berksfile_path(env), opts)

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

            env[:berkshelf].berksfile.vendor(env[:berkshelf].shelf)
          end

          def warn_disabled_but_berksfile_exists(env)
            env[:berkshelf].ui.warn "Berkshelf plugin is disabled but a Berksfile was found at" +
              " your configured path: #{env[:global_config].berkshelf.berksfile_path}"
            env[:berkshelf].ui.warn "Enable the Berkshelf plugin by setting 'config.berkshelf.enabled = true'" +
              " in your vagrant config"
          end

          def check_vagrant_version(env)
            unless vagrant_version_satisfies?(">= 1.5")
              raise Berkshelf::VagrantWrapperError.new(RuntimeError.new("vagrant-berkshelf requires Vagrant 1.5 or later."))
            end
          end

          def vagrant_version_satisfies?(requirements)
            Gem::Requirement.new(requirements).satisfied_by? Gem::Version.new(::Vagrant::VERSION)
          end

          def berksfile_path(env)
            env[:machine].env.vagrantfile.config.berkshelf.berksfile_path
          end
      end
    end
  end
end
