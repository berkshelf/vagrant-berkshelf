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
        vagrant_version = Gem::Version.new(::Vagrant::VERSION)
        if vagrant_version >= Gem::Version.new('1.5')
          @ui = ::Vagrant::UI::Colored.new
          @ui.opts[:target] = 'Berkshelf'
        elsif vagrant_version >= Gem::Version.new('1.2')
          @ui = ::Vagrant::UI::Colored.new.scope('Berkshelf')
        else
          @ui = ::Vagrant::UI::Colored.new('Berkshelf')
        end
        @config = Berkshelf::Config.instance
      end
    end
  end
end
