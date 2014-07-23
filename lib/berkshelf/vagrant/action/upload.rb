require 'tempfile'

module Berkshelf
  module Vagrant
    module Action
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
        end

        private

          def upload(env)
            provisioners(:chef_client, env).each do |provisioner|
              begin
                # Temporarily generate a berkshelf configuration to pass to the CLI since not all versions
                # of the CLI allow overriding all options needed for upload.
                tmp_config = Tempfile.new("berks-config")
                config     = BerksConfig.instance.dup
                config[:chef][:chef_server_url] = provisioner.config.chef_server_url
                tmp_config.write(config.to_json)
                tmp_config.flush

                env[:berkshelf].ui.info "Uploading cookbooks to '#{provisioner.config.chef_server_url}'"
                berks("upload", config: tmp_config.path, berksfile: berksfile_path(env), force: true,
                  freeze: false)
              ensure
                tmp_config.close! unless tmp_config.nil?
              end
            end
          end
      end
    end
  end
end
