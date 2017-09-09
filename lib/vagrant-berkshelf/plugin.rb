require 'vagrant/action'

require_relative 'action/check'
require_relative 'action/clean'
require_relative 'action/install'
require_relative 'action/load'
require_relative 'action/save'
require_relative 'action/share'
require_relative 'action/upload'
require_relative 'env'

module VagrantPlugins
  module Berkshelf
    class Plugin < Vagrant.plugin("2")
      # Require a particular version of Vagrant
      Vagrant.require_version(">= 1.5")

      name "berkshelf"
      description <<-DESC
      Automatically synchronize cookbooks in the Berksfile to virtual machines
      provisioned by Chef using Berkshelf.
      DESC

      [:machine_action_up, :machine_action_reload, :machine_action_provision].each do |action|
        action_hook(:berkshelf_provision, action) do |hook|
          hook.after(Vagrant::Action::Builtin::ConfigValidate, Action::Base.setup)
          hook.before(Vagrant::Action::Builtin::Provision, Action::Base.provision)
        end
      end

      action_hook(:berkshelf_cleanup, :machine_action_destroy) do |hook|
        hook.before(Vagrant::Action::Builtin::DestroyConfirm, Action::Base.clean)
      end

      config(:berkshelf) do
        require_relative "config"
        Config
      end
    end
  end
end
