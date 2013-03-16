module Berkshelf::Vagrant
  # @author Jamie Winsor <reset@riotgames.com>
  class Plugin < ::Vagrant.plugin("2")
    name "berkshelf"
    description <<-DESC
    Automatically make available cookbooks to virtual machines provisioned by Chef Solo
    or Chef Client using Berkshelf.
    DESC

    action_hook("berkshelf_provision", "machine_action_up") do |hook|
      hook.insert(Vagrant::Action::Builtin::ConfigValidate, Berkshelf::Vagrant::Action::Validate)
      hook.insert(Vagrant::Action::Builtin::Provision, Berkshelf::Vagrant::Middleware.install)
      hook.insert(Vagrant::Action::Builtin::Provision, Berkshelf::Vagrant::Middleware.upload)
    end

    action_hook("berkshelf_cleanup", "machine_action_destroy") do |hook|
      hook.append(Berkshelf::Vagrant::Middleware::Clean)
    end

    config(:berkshelf) do
      Berkshelf::Vagrant::Config
    end
  end
end
