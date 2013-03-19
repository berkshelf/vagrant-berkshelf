module Berkshelf::Vagrant
  # @author Jamie Winsor <reset@riotgames.com>
  #
  # Environment data to build up and persist through the middleware chain
  class Env
    # @return [Vagrant::UI::Colored]
    attr_accessor :ui
    # @return [Berkshelf::Berksfile]
    attr_accessor :berksfile
    # @return [String]
    attr_accessor :shelf
    # @return [Berkshelf::Config]
    attr_accessor :config

    def initialize
      @ui     = ::Vagrant::UI::Colored.new('Berkshelf')
      @config = Berkshelf::Config.instance
    end
  end
end
