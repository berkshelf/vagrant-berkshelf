require_relative 'base'

module VagrantPlugins
  module Berkshelf
    module Action
      class Save < Base
        def call(env)
          if !berkshelf_enabled?(env)
            @logger.info "Berkshelf disabled, skipping"
            return @app.call(env)
          end

          if env[:berkshelf].shelf
            @logger.debug "Saving datafile to disk"
            FileUtils.mkdir_p(datafile_path(env).dirname)
            datafile_path(env).open("w+") do |f|
              f.write(env[:berkshelf].shelf)
            end
          end

          @app.call(env)
        end
      end
    end
  end
end

