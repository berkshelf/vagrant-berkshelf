module Berkshelf
  module Vagrant
    module Action
      # @author Jamie Winsor <reset@riotgames.com>
      class Clean
        include Berkshelf::Vagrant::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def call(env)
          if env[:berkshelf].shelf && File.exist?(env[:berkshelf].shelf)
            env[:berkshelf].ui.info "Cleaning Vagrant's berkshelf"

            FileUtils.remove_dir(env[:berkshelf].shelf, force: true)
            FileUtils.rm_f(cache_file env)
            env[:berkshelf].shelf = nil
          end

          @app.call(env)
        rescue Berkshelf::BerkshelfError => e
          raise Berkshelf::VagrantWrapperError.new(e)
        end
      end
    end
  end
end
