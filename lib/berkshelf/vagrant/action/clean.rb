module Berkshelf::Vagrant
  module Action
    # @author Jamie Winsor <reset@riotgames.com>
    class Clean
      include Berkshelf::Vagrant::EnvHelpers

      def initialize(app, env)
        @app = app
      end

      def call(env)
        if chef_solo?(env) && env[:berkshelf].shelf && File.exist?(env[:berkshelf].shelf)
          env[:berkshelf].ui.info "Cleaning Vagrant's berkshelf"

          FileUtils.remove_dir(env[:berkshelf].shelf, force: true)
        end

        @app.call(env)
      rescue BerkshelfError => e
        raise VagrantWrapperError.new(e)
      end
    end
  end
end
