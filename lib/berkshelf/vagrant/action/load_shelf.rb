module Berkshelf
  module Vagrant
    module Action
      # @author Jamie Winsor <jamie@vialstudios.com>
      class LoadShelf
        include Berkshelf::Vagrant::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def call(env)
          unless berkshelf_enabled?(env)
            return @app.call(env)
          end

          # Make sure that Berkshelf itself uses distinct directories for each vagrant run.
          ENV['BERKSHELF_PATH'] ||= File.join(Berkshelf.berkshelf_path, env[:machine].name.to_s)

          shelf = load_shelf(env)

          if shelf.nil?
            shelf = cache_shelf(Berkshelf::Vagrant.mkshelf(env[:machine].name), env)
          end

          env[:berkshelf].shelf = shelf

          @app.call(env)
        end

        # @param [String] path
        #
        # @return [String]
        def cache_shelf(path, env)
          FileUtils.mkdir_p(File.dirname(path))

          File.open((cache_file(env)), 'w+') do |f|
            f.write(path)
          end

          path
        end

        # @return [String, nil]
        def load_shelf(env)
          return nil unless File.exist?(cache_file(env))

          File.read(cache_file(env)).chomp
        end
      end
    end
  end
end
