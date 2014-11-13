require_relative 'base'

module VagrantPlugins
  module Berkshelf
    module Action
      class Install < Base
        def call(env)
          if !berkshelf_enabled?(env)
            @logger.info "Berkshelf disabled, skipping"
            return @app.call(env)
          end

          if !provision_enabled?(env)
            @logger.info "Provisioning disabled, skipping"
            return @app.call(env)
          end

          vendor(env)
          @app.call(env)
        end

        # Vendor the cookbooks in the Berkshelf shelf.
        def vendor(env)
          shelf = env[:berkshelf].shelf
          env[:machine].ui.info "Updating Vagrant's Berkshelf..."

          options = env[:machine].config.berkshelf.to_hash

          result = berks('vendor', shelf, options)
          env[:machine].ui.output(result.stdout)
        end
      end
    end
  end
end
