module Berkshelf::Vagrant
  class Env
    attr_accessor :ui
    attr_accessor :berksfile
    attr_accessor :shelf
    attr_accessor :config

    def initialize
      @ui     = ::Vagrant::UI::Colored.new('Berkshelf')
      @config = Berkshelf::Config.instance
    end
  end
end
