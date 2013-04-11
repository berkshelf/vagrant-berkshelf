module Berkshelf
  module Vagrant
    module Action
      # @author Jamie Winsor <reset@riotgames.com>
      class Install
        include Berkshelf::Vagrant::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def call(env)
          unless berkshelf_enabled?(env)
            if File.exist?(env[:global_config].berkshelf.berksfile_path)
              warn_disabled_but_berksfile_exists(env)
            end

            return @app.call(env)
          end

          env[:berkshelf].berksfile = Berkshelf::Berksfile.from_file(env[:global_config].berkshelf.berksfile_path)

          if chef_solo?(env)
            install(env)
          end

          @app.call(env)
        rescue Berkshelf::BerkshelfError => e
          raise Berkshelf::VagrantWrapperError.new(e)
        end

        private

          def install(env)
            env[:berkshelf].ui.info "Updating Vagrant's berkshelf: '#{env[:berkshelf].shelf}'"
            opts = {
              path: env[:berkshelf].shelf
            }.merge(env[:global_config].berkshelf.to_hash).symbolize_keys!
            env[:berkshelf].berksfile.install(opts)
          end

          def warn_disabled_but_berksfile_exists(env)
            env[:berkshelf].ui.warn "Berkshelf plugin is disabled but a Berksfile was found at" +
              " your configured path: #{env[:global_config].berkshelf.berksfile_path}"
            env[:berkshelf].ui.warn "Enable the Berkshelf plugin by setting 'config.berkshelf.enabled = true'" +
              " in your vagrant config"
          end
      end
    end
  end
end
