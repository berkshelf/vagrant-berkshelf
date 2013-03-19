module Berkshelf::Vagrant
  module Action
    # @author Jamie Winsor <reset@riotgames.com>
    class SetupShelf
      include Berkshelf::Vagrant::EnvHelpers

      def initialize(app, env)
        @app = app
      end

      def call(env)
        env[:berkshelf].shelf = shelf = shelf_for(env)

        if chef_solo?(env) && shelf
          FileUtils.mkdir_p(shelf)

          provisioners(:chef_solo, env).each do |provisioner|
            provisioner.config.cookbooks_path.unshift(provisioner.config.send(:prepare_folders_config, shelf))
          end
        end

        @app.call(env)
      end
    end
  end
end
