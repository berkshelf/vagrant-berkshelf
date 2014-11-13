require 'json'
require 'tempfile'

require_relative 'base'

module VagrantPlugins
  module Berkshelf
    module Action
      class Upload < Base
        def call(env)
          if !berkshelf_enabled?(env)
            @logger.info "Berkshelf disabled, skipping"
            return @app.call(env)
          end

          if !provision_enabled?(env)
            @logger.info "Provisioning disabled, skipping"
            return @app.call(env)
          end

          if !chef_client?(env)
            @logger.info "Provisioner does need to upload"
            return @app.call(env)
          end

          upload(env)
          @app.call(env)
        end

        private

          # Generate a custom Berkshelf config from the existing Berkshelf
          # config on disk, with values in the Vagrantfile taking precedence,
          # based on the current provisioner. It is assumed the provisioner is
          # the "chef_client" provisioner.
          #
          # The path to the temporary configuration file is yielded to the
          # block. This method ensures the temporary file is cleaned up
          # automatically.
          #
          # @param [Vagrant::Provisioner] provisioner
          # @param [Proc] block
          def with_provision_berkshelf_config(provisioner, &block)
            config = current_berkshelf_config

            config[:chef] ||= {}
            config[:chef].merge(
              chef_server_url:        provisioner.config.chef_server_url,
              node_name:              provisioner.config.node_name,
              client_key:             provisioner.config.client_key_path,
              validation_key:         provisioner.config.validation_key_path,
              validation_client_name: provisioner.config.validation_client_name,
            )

            tmpfile = Tempfile.new('config.json')
            tmpfile.write(config.to_json)
            tmpfile.rewind
            yield tmpfile.path
          ensure
            if defined?(tmpfile)
              tmpfile.close
              tmpfile.unlink
            end
          end

          # The current JSON representation of the Berkshelf config on disk.
          #
          # @return [Hash<Symbol, Object>]
          def current_berkshelf_config
            path = File.expand_path(ENV['BERKSHELF_CONFIG'] || '~/.berkshelf/config.json')

            if File.exist?(path)
              JSON.parse(File.read(), symbolize_names: true)
            else
              {}
            end
          end

          # Upload the resolved Berkshelf cookbooks to the target Chef Server
          # specified in the Vagrantfile.
          #
          # @param [Vagrant::Environment] env
          def upload(env)
            provisioners(:chef_client, env).each do |provisioner|
              with_provision_berkshelf_config(provisioner) do |config|
                env[:machine].ui.info "Uploading cookbooks to #{provisioner.config.chef_server_url}"
                berks("upload",
                  config:    config,
                  berksfile: provisioner.config.berkshelf.berksfile_path,
                  force:     true,
                  freeze:    false,
                )
              end
            end
          end
      end
    end
  end
end
