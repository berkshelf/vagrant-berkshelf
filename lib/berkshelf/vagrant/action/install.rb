module Berkshelf::Vagrant
  module Action
    # @author Jamie Winsor <reset@riotgames.com>
    class Install
      include Berkshelf::Vagrant::EnvHelpers

      def initialize(app, env)
        @app = app
      end

      def call(env)
        env[:berkshelf].berksfile = Berkshelf::Berksfile.from_file(env[:global_config].berkshelf.berksfile_path)

        if chef_solo?(env)
          install(env)
        end

        @app.call(env)
      rescue Berkshelf::BerkshelfError => e
        raise VagrantWrapperError.new(e)
      end

      private

        def install(env)
          env[:berkshelf].ui.info "Updating Vagrant's berkshelf: '#{env[:berkshelf].shelf}'"
          opts = {
            path: env[:berkshelf].shelf
          }.merge(env[:global_config].berkshelf.to_hash).symbolize_keys!
          env[:berkshelf].berksfile.install(opts)
        end
    end
  end
end
