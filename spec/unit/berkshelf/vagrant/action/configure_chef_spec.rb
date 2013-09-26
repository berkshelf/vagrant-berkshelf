require 'spec_helper'

describe Berkshelf::Vagrant::Action::ConfigureChef do
  let(:app) { proc {} }
  let(:chef_solo_provisioner) { double("Vagrant::Provisioners::Chef::ChefSolo", :name => :chef_solo) }
  let(:env) do
    {
      :machine => double("Machine"),
      :berkshelf => double("Berkshelf", :shelf => double("shelf"))
    }
  end

  it "appends shelf path to vagrant's cookbooks_path" do
    env[:machine].stub_chain(:config, :vm, :provisioners).and_return([chef_solo_provisioner])
    env[:machine].stub_chain(:config, :berkshelf, :enabled).and_return(true)

    cookbooks_path = ["/path/to/my-cookbooks"]
    chef_solo_provisioner.stub_chain(:config, :cookbooks_path).and_return(cookbooks_path)
    chef_solo_provisioner.stub_chain(:config, :prepare_folders_config).and_return("/path/to/berkshelf-cookbooks")

    described_class.new(app, env).call(env)

    expect(cookbooks_path).to include("/path/to/my-cookbooks", "/path/to/berkshelf-cookbooks")
  end
end

