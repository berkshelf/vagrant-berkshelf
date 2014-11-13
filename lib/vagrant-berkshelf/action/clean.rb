require_relative 'base'

module VagrantPlugins
  module Berkshelf
    module Action
      class Clean < Base
        def call(env)
          if !berkshelf_enabled?(env)
            @logger.info "Berkshelf disabled, skipping"
            return @app.call(env)
          end

          env[:machine].ui.info "Running cleanup tasks for 'berkshelf'..."

          if env[:berkshelf].shelf
            if File.exist?(env[:berkshelf].shelf)
              FileUtils.rm_rf(env[:berkshelf].shelf)
              env[:berkshelf].shelf = nil
            else
              @logger.warn "The Berkshelf shelf did not exist for cleanup!"
            end
          end

          @app.call(env)
        end
      end
    end
  end
end
