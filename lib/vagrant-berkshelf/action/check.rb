require_relative 'base'

module VagrantPlugins
  module Berkshelf
    module Action
      class Check < Base
        BERKS_REQUIREMENT = ">= 4.0"

        def call(env)
          if !berkshelf_enabled?(env)
            @logger.info "Berkshelf disabled, skipping"
            return @app.call(env)
          end

          check_berks_bin!(env)
          berkshelf_version_check!(env)

          @app.call(env)
        end

        # Check that the Berkshelf `berks` bin is in the PATH.
        # @raise [BerkshelfNotFound]
        def check_berks_bin!(env)
          if berks_bin.nil?
            raise BerkshelfNotFound
          end
        end

        # Check that the installed version of Berkshelf is valid for this
        # version of Vagrant Berkshelf.
        # @raise [InvalidBerkshelfVersionError]
        def berkshelf_version_check!(env)
          result = berks("--version", "--format", "json")

          begin
            json = JSON.parse(result.stdout, symbolize_names: true)
            version = Gem::Version.new(json[:version])

            unless Gem::Requirement.new(BERKS_REQUIREMENT).satisfied_by?(version)
              raise InvalidBerkshelfVersionError.new(berks_bin, BERKS_REQUIREMENT, version)
            end
          rescue JSON::ParserError
            raise InvalidBerkshelfVersionError.new(berks_bin, BERKS_REQUIREMENT, version)
          end
        end
      end
    end
  end
end
