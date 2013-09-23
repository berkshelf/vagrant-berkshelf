require 'spec_helper'

describe Berkshelf::Vagrant::Config do
  let(:unset_value) { described_class::UNSET_VALUE }
  let(:config) { described_class.new }

  it "sets a path to a Berksfile in the current working directory for berksfile_path" do
    subject.berksfile_path.should eql(File.join(Dir.pwd, "Berksfile"))
  end

  context "when the Berksfile exists" do
    before do
      File.should_receive(:exist?).with(File.join(Dir.pwd, "Berksfile")).and_return(true)
    end

    it "it sets the value of enabled to true" do
      config.enabled.should be true
    end
  end

  context "when the Berksfile doesn't exist" do
    before do
      File.should_receive(:exist?).with(File.join(Dir.pwd, "Berksfile")).and_return(false)
    end

    it "set the value of enabled to false" do
      config.enabled.should be false
    end
  end

  it "sets the value of only to an empty array" do
    subject.only.should be_a(Array)
    subject.only.should be_empty
  end

  it "sets the value of except to an empty array" do
    subject.except.should be_a(Array)
    subject.except.should be_empty
  end

  context "when the config file path is not specified" do
    it "sets the value of node_name to the value in the Berkshelf::Config.instance" do
      subject.node_name.should eql(Berkshelf::Config.instance.chef.node_name)
    end

    it "sets the value of client_key to the value in Berkshelf::Config.instance" do
      subject.client_key.should eql(Berkshelf::Config.instance.chef.client_key)
    end
  end

  describe "#config_path=" do
    before(:each) do
      @cfg = described_class.new
      File.stub(:expand_path) do |arg|
        arg == 'my_berkshelf_config.json' ? 'new_config_path' : arg
      end
      Berkshelf::Config.stub(:new).and_return(Berkshelf::Config.instance)
      Berkshelf::Config.instance.chef.stub(:client_key).and_return('new_client_key')
      Berkshelf::Config.instance.chef.stub(:node_name).and_return('new_node_name')
      @cfg.config_path = 'my_berkshelf_config.json'
    end

    it "reloads the berkshelf config" do
      Berkshelf::Config.should_receive(:set_path).with('new_config_path')
      @cfg.config_path = 'my_berkshelf_config.json'
    end

    context "with the client_key and node_name not set already" do
      it "sets the client_key from the specified config file" do
        @cfg.client_key.should eql('new_client_key')
      end

      it "sets the node_name from the specified config file" do
        @cfg.node_name.should eql('new_node_name')
      end
    end

    context "with the client_key already set" do
      before(:each) do
        @cfg.client_key = 'other_client_key'
        @cfg.config_path = 'my_berkshelf_config.json'
      end

      it "does not alter the client key" do
        @cfg.client_key.should eql('other_client_key')
      end
    end

    context "with the node_name already set" do
      before(:each) do
        @cfg.node_name = 'other_node_name'
        @cfg.config_path = 'my_berkshelf_config.json'
      end

      it "does not alter the node name" do
        @cfg.node_name.should eql('other_node_name')
      end
    end
  end

  describe "#validate" do
    let(:env) { double('env') }
    let(:config) { double('config', berkshelf: subject) }
    let(:machine) { double('machine', config: config, env: env) }

    before do
      subject.finalize!
    end

    context "when the plugin is enabled" do
      before(:each) do
        subject.stub(enabled: true)
        env.stub_chain(:config_global, :vm, :provisioners, :any?)
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

      context "when config_path is specified" do
        context "and the file does not exist" do
          before(:each) do
            subject.config_path = 'my_config_file'
            File.should_receive(:exist?).with(subject.berksfile_path).and_return(true)
            File.should_receive(:exist?).with(subject.config_path).and_return(false)
          end

          let(:result) { subject.validate(machine) }

          it "returns an error in the array" do
            result["berkshelf configuration"].should_not be_empty
          end
        end
      end
    end

    context "when the plugin is disabled" do
      let(:machine) { double('machine') }

      before do
        subject.stub(enabled: false)
      end

      it "does not perform any validations" do
        machine.should_not_receive(:config)

        subject.validate(machine)
      end
    end
  end
end
