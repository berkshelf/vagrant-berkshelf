module Berkshelf
  module Vagrant
    module Action
      # @author Jamie Winsor <reset@riotgames.com>
      class LoadShelf
        include Berkshelf::Vagrant::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def call(env)
          shelf = load_shelf

          if shelf.nil?
            shelf = cache_shelf(Berkshelf::Vagrant.mkshelf)
          end

          env[:berkshelf].shelf = shelf

          @app.call(env)
        end

        # @param [String] path
        #
        # @return [String]
        def cache_shelf(path)
          FileUtils.mkdir_p(File.dirname(path))

          File.open(cache_file, 'w+') do |f|
            f.write(path)
          end

          path
        end

        # @return [String, nil]
        def load_shelf
          return nil unless File.exist?(cache_file)

          File.read(cache_file).chomp
        end
      end
    end
  end
end
