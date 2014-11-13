require "spec_helper"

describe VagrantPlugins::Berkshelf::Config do
  subject { described_class.new }

  let(:machine) { double("machine") }

  describe "#berksfile_path" do
    it "defaults to nil" do
      subject.finalize!
      expect(subject.berksfile_path).to be(nil)
    end

    it "sets the value if it exists" do
      allow(File).to receive(:exist?)
        .with("Berksfile")
        .and_return(true)
      subject.finalize!
      expect(subject.berksfile_path).to eq("Berksfile")
    end
  end

  describe "#enabled" do
    it "is true when there is a Berksfile present" do
      allow(File).to receive(:exist?)
        .with("Berksfile")
        .and_return(true)
      subject.finalize!
      expect(subject.enabled).to be(true)
    end

    it "is false when there is a Berksfile present but it is disabled" do
      allow(File).to receive(:exist?)
        .with("Berksfile")
        .and_return(true)
        subject.enabled = false
      subject.finalize!
      expect(subject.enabled).to be(false)
    end

    it "is true when a berksfile_path is given" do
      subject.berksfile_path = "Berksfile"
      subject.finalize!
      expect(subject.enabled).to be(true)
    end

    it "is false when the berksfile_path is given but it is disabled" do
      subject.berksfile_path = "Berksfile"
      subject.enabled = false
      subject.finalize!
      expect(subject.enabled).to be(false)
    end

    it "defaults to false" do
      allow(File).to receive(:exist?)
        .with("Berksfile")
        .and_return(false)
      subject.finalize!
      expect(subject.enabled).to be(false)
    end
  end

  describe "#only" do
    it "defaults to an empty array" do
      subject.finalize!
      expect(subject.only).to be_a(Array)
      expect(subject.only).to be_empty
    end
  end

  describe "#except" do
    it "defaults to an empty array" do
      subject.finalize!
      expect(subject.except).to be_a(Array)
      expect(subject.except).to be_empty
    end
  end

  describe "#args" do
    it "defaults to an empty array" do
      subject.finalize!
      expect(subject.args).to be_a(Array)
      expect(subject.args).to be_empty
    end
  end

  describe "#validate" do
    before do
      allow(machine).to receive(:env)
        .and_return(double("env",
          root_path: "",
        ))

      subject.berksfile_path = "Berksfile"
      subject.enabled = true
      subject.only = []
      subject.except = []
      subject.args = []
    end

    let(:result) { subject.validate(machine) }
    let(:errors) { result["Berkshelf"] }

    context "when the berksfile_path is nil" do
      it "returns an error if enabled" do
        subject.berksfile_path = ""
        subject.finalize!
        expect(errors).to include("berksfile_path must be set")
      end

      it "does not returns an error if disabled" do
        subject.berksfile_path = ""
        subject.enabled = false
        subject.finalize!
        expect(errors).to eq([])
      end
    end
  end
end
