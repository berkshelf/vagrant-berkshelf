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

            @logger.debug "adding #{value.inspect} to cookbook_paths"
            chef.config.cookbooks_path = merge_paths(chef.config.cookbooks_path, value)
          end

          @app.call(env)
        end

        protected

        def merge_paths(a, b)
          normalized_path(a) + normalized_path(b)
        end

        def normalized_path(path_config_ish)
          if path_config_ish == Vagrant::Plugin::V2::Config::UNSET_VALUE
            []

          elsif path_config_ish.respond_to?(:first) and
                path_config_ish.first.is_a?(Symbol)
            [path_config_ish]

          else
            Array(path_config_ish)
          end
        end

      end
    end
  end
end
