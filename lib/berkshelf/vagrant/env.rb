module Berkshelf
  module Vagrant
    # @author Jamie Winsor <jamie@vialstudios.com>
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
        @ui = ::Vagrant::UI::Colored.new
        @ui.opts[:target] = 'Berkshelf'
        @config = Berkshelf::Config.instance
      end
    end
  end
end
