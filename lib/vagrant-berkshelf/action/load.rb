require_relative 'base'

module VagrantPlugins
  module Berkshelf
    module Action
      class Load < Base
        def call(env)
          if !berkshelf_enabled?(env)
            @logger.info "Berkshelf disabled, skipping"
            return @app.call(env)
          end

          if File.exist?(datafile_path(env))
            env[:machine].ui.info "Loading Berkshelf datafile..."
            shelf = File.read(datafile_path(env)).chomp

            @logger.debug "Shelf: #{shelf.inspect}"

            env[:berkshelf].shelf = shelf
          end

          if !env[:berkshelf].shelf
            shelf = mkshelf(env)
            env[:machine].ui.detail "The Berkshelf shelf is at #{shelf.inspect}"

            @logger.debug "Persisting datafile share to memory"
            env[:berkshelf].shelf = shelf
          end

          @app.call(env)
        end

        # Create a new Berkshelf shelf for the current machine.
        # @return [String]
        #   the path to the temporary directory
        def mkshelf(env)
          shelves = Berkshelf.shelves_path

          if !File.exist?(shelves)
            FileUtils.mkdir_p(shelves)
          end

          Dir.mktmpdir(['berkshelf', "-#{env[:machine].name}"], shelves)
        end
      end
    end
  end
end
