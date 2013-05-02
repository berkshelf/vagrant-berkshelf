require 'spec_helper'

describe Berkshelf::Vagrant do
  describe "ClassMethods" do
    describe "::shelf_path" do
      it "returns a String" do
        subject.shelf_path.should be_a(String)
      end

      it "is a pathname including the berkshelf_path" do
        subject.shelf_path.should include(Berkshelf.berkshelf_path)
      end
    end

    describe "::mkshelf" do

      it "returns a String" do
        subject.mkshelf().should be_a(String)
      end

      it "is a pathname including the shelf_path" do
        subject.mkshelf().should include(subject.shelf_path)
      end

      it "is a pathname including machine name" do

        machine_name = 'fantastic_machine'
        subject.mkshelf(machine_name).should include(machine_name)
      end

    end
  end
end
