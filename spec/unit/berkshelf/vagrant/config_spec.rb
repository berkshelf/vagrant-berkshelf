require 'spec_helper'

describe Berkshelf::Vagrant::Config do
  let(:unset_value) { described_class::UNSET_VALUE }

  subject { described_class.new }

  it "sets a path to a Berksfile in the current working directory for berksfile_path" do
    subject.berksfile_path.should eql(File.join(Dir.pwd, "Berksfile"))
  end

  it "sets the value of only to an empty array" do
    subject.only.should be_a(Array)
    subject.only.should be_empty
  end

  it "sets the value of except to an empty array" do
    subject.except.should be_a(Array)
    subject.except.should be_empty
  end

  it "sets the value of node_name to the value in the Berkshelf::Config.instance" do
    subject.node_name.should eql(Berkshelf::Config.instance.chef.node_name)
  end

  it "sets the value of client_key to the value in Berkshelf::Config.instance" do
    subject.client_key.should eql(Berkshelf::Config.instance.chef.client_key)
  end

  describe "#validate" do
    let(:env) { double('env') }
    let(:config) { double('config', berkshelf: subject) }
    let(:machine) { double('machine', config: config, env: env) }

    before(:each) do
      subject.finalize!
      subject.should_receive(:chef_client?).with(env).and_return(true)
    end

    let(:result) { subject.validate(machine) }

    it "returns a Hash with a 'berkshelf configuration' key" do
      result.should be_a(Hash)
      result.should have_key("berkshelf configuration")
    end

    context "when all validations pass" do
      before(:each) do
        File.should_receive(:exist?).with(subject.berksfile_path).and_return(true)
      end

      it "contains an empty Array for the 'berkshelf configuration' key" do
        result["berkshelf configuration"].should be_a(Array)
        result["berkshelf configuration"].should be_empty
      end
    end
  end
end
