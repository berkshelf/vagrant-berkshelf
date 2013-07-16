module Berkshelf
  module Vagrant
    class Plugin < ::Vagrant.plugin("2")
      class << self
        def provision(hook)
          hook.after(::Vagrant::Action::Builtin::Provision, Berkshelf::Vagrant::Action.upload)
          hook.after(::Vagrant::Action::Builtin::Provision, Berkshelf::Vagrant::Action.install)

          if ::VagrantPlugins.const_defined?(:AWS)
            hook.after(::VagrantPlugins::AWS::Action::TimedProvision, Berkshelf::Vagrant::Action.upload)
            hook.after(::VagrantPlugins::AWS::Action::TimedProvision, Berkshelf::Vagrant::Action.install)
          end

          hook.before(::Vagrant::Action::Builtin::ConfigValidate, Berkshelf::Vagrant::Action.setup)
        end
      end

      name "berkshelf"
      description <<-DESC
      Automatically make available cookbooks to virtual machines provisioned by Chef Solo
      or Chef Client using Berkshelf.
      DESC

      action_hook(:berkshelf_provision, :machine_action_up, &method(:provision))
      action_hook(:berkshelf_provision, :machine_action_reload, &method(:provision))
      action_hook(:berkshelf_provision, :machine_action_provision, &method(:provision))

      action_hook(:berkshelf_cleanup, :machine_action_destroy) do |hook|
        # @todo this should be appended to the middleware stack instead of hooked in after the
        #   Virtualbox specific destroy step but there is a bug in Vagrant (1.1.0) which
        #   causes appended middleware to run multiple times.
        hook.after(VagrantPlugins::ProviderVirtualBox::Action::DestroyUnusedNetworkInterfaces, Berkshelf::Vagrant::Action.clean)
      end

      config(:berkshelf) do
        Berkshelf::Vagrant::Config
      end
    end
  end
end
