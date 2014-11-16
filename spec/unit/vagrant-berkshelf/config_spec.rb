require "spec_helper"

describe VagrantPlugins::Berkshelf::Config do
  subject { described_class.new }

  let(:machine) { double("machine") }

  describe "#berksfile_path" do
    it "defaults to nil" do
      subject.finalize!
      expect(subject.berksfile_path).to be(nil)
    end
  end

  describe "#enabled" do
    it "defaults to MAYBE" do
      subject.finalize!
      expect(subject.enabled).to be(VagrantPlugins::Berkshelf::Config::MAYBE)
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
          root_path: File.expand_path("..", __FILE__),
        ))

      subject.berksfile_path = "Berksfile"
      subject.enabled = true
      subject.only = []
      subject.except = []
      subject.args = []
    end

    let(:result) do
      subject.finalize!
      subject.validate(machine)
    end

    let(:errors) { result["Berkshelf"] }

    context "when enabled is false" do
      before { subject.enabled = false }

      it "returns no errors" do
        expect(errors).to be_empty
      end

      it "remains disabled even if a Berksfile is present" do
        allow(File).to receive(:exist?).and_return(true)
        expect(errors).to be_empty
        expect(subject.enabled).to be(false)
      end

      it "remains disabled even if a berksfile_path is given" do
        subject.berksfile_path = "Custom.Berksfile"
        expect(errors).to be_empty
        expect(subject.enabled).to be(false)
      end
    end

    context "when no berksfile_path is given" do
      before { subject.berksfile_path = nil }

      context "when a Berksfile is present" do
        before { allow(File).to receive(:exist?).and_return(true) }

        it "sets the berksfile_path" do
          expect(errors).to be_empty
          expect(subject.berksfile_path).to eq(File.expand_path("../Berksfile", __FILE__))
        end
      end

      context "when a Berksfile is not present" do
        before { allow(File).to receive(:exist?).and_return(false) }

        context "when the plugin is enabled" do
          it "returns an error" do
            subject.enabled = true
            expect(errors).to include("berksfile_path must be set")
          end
        end

        context "when the plugin is in MAYBE state" do
          it "disables the plugin" do
            subject.enabled = VagrantPlugins::Berkshelf::Config::MAYBE
            expect(errors).to be_empty
            expect(subject.enabled).to be(false)
          end
        end
      end
    end

    context "when a berksfile_path is given" do
      before { subject.berksfile_path = "Custom.Berksfile" }

      let(:expanded_path) { File.expand_path("../Custom.Berksfile", __FILE__) }

      context "when another Berksfile is present" do
        before { allow(File).to receive(:exist?).and_return(true) }

        it "does not change the berksfile_path" do
          expect(errors).to be_empty
          expect(subject.berksfile_path).to eq(expanded_path)
        end

        it "expands the path relative to the machine root" do
          subject.finalize!
          subject.validate(machine)
          expect(subject.berksfile_path).to eq(expanded_path)
        end
      end

      context "when the given berksfile_path does not exist" do
        before { allow(File).to receive(:exist?).and_return(false) }

        it "returns an error" do
          expect(errors).to include("Berksfile at '#{expanded_path}' does not exist")
        end
      end
    end

    context "when the berksfile_path is nil and no Berksfile exists" do
      before { allow(File).to receive(:exist?).and_return(false) }

      it "returns an error if enabled" do
        subject.berksfile_path = ""
        subject.finalize!
        expect(errors).to include("berksfile_path must be set")
      end
    end
  end
end
