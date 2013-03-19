module Berkshelf::Vagrant
  # @author Jamie Winsor <reset@riotgames.com>
  class Plugin < ::Vagrant.plugin("2")
    class << self
      def provision(hook)
        hook.after(Vagrant::Action::Builtin::Provision, Berkshelf::Vagrant::Action.upload)
        hook.after(Vagrant::Action::Builtin::Provision, Berkshelf::Vagrant::Action.install)
      end
    end

    name "berkshelf"
    description <<-DESC
    Automatically make available cookbooks to virtual machines provisioned by Chef Solo
    or Chef Client using Berkshelf.
    DESC

    action_hook(:berkshelf_provision, :machine_action_up, &method(:provision))
    action_hook(:berkshelf_provision, :machine_action_provision, &method(:provision))

    action_hook(:berkshelf_cleanup, :machine_action_destroy) do |hook|
      hook.append(Berkshelf::Vagrant::Action.clean)
    end

    config(:berkshelf) do
      Berkshelf::Vagrant::Config
    end
  end
end
