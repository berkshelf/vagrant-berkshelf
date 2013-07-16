module Berkshelf
  module Vagrant
    module Action
      # @author Jamie Winsor <jamie@vialstudios.com>
      class Upload
        include Berkshelf::Vagrant::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def call(env)
          if provision_disabled?(env)
            return @app.call(env)
          end

          unless berkshelf_enabled?(env)
            return @app.call(env)
          end

          if chef_client?(env)
            upload(env)
          end

          @app.call(env)
        rescue Berkshelf::BerkshelfError => e
          raise Berkshelf::VagrantWrapperError.new(e)
        end

        private

          def upload(env)
            provisioners(:chef_client, env).each do |provisioner|
              env[:berkshelf].ui.info "Uploading cookbooks to '#{provisioner.config.chef_server_url}'"
              env[:berkshelf].berksfile.upload(
                server_url: provisioner.config.chef_server_url,
                client_name: env[:berkshelf].config.chef.node_name,
                client_key: env[:berkshelf].config.chef.client_key,
                ssl: {
                  verify: env[:berkshelf].config.ssl.verify
                },
                force: true,
                freeze: false
              )
            end
          end
      end
    end
  end
end
