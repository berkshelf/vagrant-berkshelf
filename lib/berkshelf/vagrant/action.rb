module Berkshelf
  module Vagrant
    module Action
      require_relative 'env'
      require_relative 'env_helpers'

      require_relative 'action/clean'
      require_relative 'action/configure_chef'
      require_relative 'action/install'
      require_relative 'action/load_shelf'
      require_relative 'action/set_ui'
      require_relative 'action/upload'

      class << self
        # Return the Berkshelf install middleware stack. When placed in the action chain
        # this stack will find retrieve and resolve the cookbook dependencies describe
        # in your configured Berksfile.
        #
        # Cookbooks will install into a temporary directory, called a Shelf, and be mounted
        # into the VM. This mounted path will be appended to the chef_solo.cookbooks_path value.
        #
        # @return [::Vagrant::Action::Builder]
        def install
          @install ||= ::Vagrant::Action::Builder.new.tap do |b|
            b.use Berkshelf::Vagrant::Action::Install
          end
        end

        # Return the Berkshelf upload middleware stack. When placed in the action chain
        # this stack will upload cookbooks to a Chef Server if the Chef-Client provisioner
        # is used. The Chef Server where the cookbooks will be uploaded to is the same Chef
        # Server used in the Chef-Client provisioner.
        #
        # Nothing will be done if the Chef-Solo provisioner is used.
        #
        # @return [::Vagrant::Action::Builder]
        def upload
          @upload ||= ::Vagrant::Action::Builder.new.tap do |b|
            b.use Berkshelf::Vagrant::Action::Upload
          end
        end

        # Return the Berkshelf clean middleware stack. When placed in the action chain
        # this stack will clean up any temporary directories or files created by the other
        # middleware stacks.
        #
        # @return [::Vagrant::Action::Builder]
        def clean
          @clean ||= ::Vagrant::Action::Builder.new.tap do |b|
            b.use setup
            b.use Berkshelf::Vagrant::Action::Clean
          end
        end

        def setup
          @setup ||= ::Vagrant::Action::Builder.new.tap do |b|
            b.use ::Vagrant::Action::Builtin::EnvSet, berkshelf: Berkshelf::Vagrant::Env.new
            b.use Berkshelf::Vagrant::Action::SetUI
            b.use Berkshelf::Vagrant::Action::LoadShelf
            b.use Berkshelf::Vagrant::Action::ConfigureChef
          end
        end
      end
    end
  end
end
