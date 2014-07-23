module Berkshelf
  module Vagrant
    # Environment data to build up and persist through the middleware chain
    class Env
      # @return [Vagrant::UI::Colored]
      attr_accessor :ui
      # @return [String]
      attr_accessor :shelf

      def initialize
        @ui               = ::Vagrant::UI::Colored.new
        @ui.opts[:target] = 'Berkshelf'
      end
    end
  end
end
