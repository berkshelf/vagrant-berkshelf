require 'vagrant/action'

require_relative '../helpers'

module VagrantPlugins
  module Berkshelf
    module Action
      class Base
        # Cleanup any shared folders before destroying the VM.
        def self.clean
          Vagrant::Action::Builder.new.tap do |b|
            b.use setup
            b.use Action::Clean
          end
        end

        # Provision the VM, calling setup, install, and upload.
        def self.provision
          Vagrant::Action::Builder.new.tap do |b|
            b.use Action::Install
            b.use Action::Upload
          end
        end

        # Setup all the required middlemare, including checking for the presence
        # of Berkshelf, checking for the proper version of Berkshelf, and
        # loading the datafile from disk.
        def self.setup
          Vagrant::Action::Builder.new.tap do |b|
            b.use Action::Check
            b.use Vagrant::Action::Builtin::EnvSet, berkshelf: Env.new
            b.use Action::Load
            b.use Action::Share
          end
        end

        include VagrantPlugins::Berkshelf::Helpers

        def initialize(app, env)
          @app = app

          klass = self.class.name.downcase.split('::').last
          @logger = Log4r::Logger.new("vagrant::berkshelf::#{klass}")
        end
      end
    end
  end
end
