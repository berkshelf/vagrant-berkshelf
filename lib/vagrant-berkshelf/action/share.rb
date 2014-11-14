require_relative 'base'

module VagrantPlugins
  module Berkshelf
    module Action
      class Share < Base
        def call(env)
          if !berkshelf_enabled?(env)
            @logger.info "Berkshelf disabled, skipping"
            return @app.call(env)
          end

          if !chef_solo?(env) && !chef_zero?(env)
            @logger.info "Provisioner does not need a share"
            return @app.call(env)
          end

          env[:machine].ui.info "Sharing cookbooks with VM"

          list = provisioners(:chef_solo, env) + provisioners(:chef_zero, env)
          list.each do |chef|
            value = chef.config.send(:prepare_folders_config, env[:berkshelf].shelf)

            @logger.debug "Setting cookbooks_path = #{value.inspect}"
            chef.config.cookbooks_path = value
          end

          @app.call(env)
        end
      end
    end
  end
end
