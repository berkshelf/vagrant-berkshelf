require 'vagrant/errors'

module VagrantPlugins
  module Berkshelf
    class BerkshelfNotFound < Vagrant::Errors::VagrantError
      def error_message
        "Vagrant Berkshelf could not find the 'berks' executable in your PATH."
      end
    end

    class BerksCommandFailed < Vagrant::Errors::VagrantError
      def initialize(command, stdout, stderr)
        @command, @stdout, @stderr = command, stdout, stderr
        super
      end

      def error_message
        base = <<-EOH
The following berks command failed to execute:

    #{@command}

The stdout and stderr are shown below:

    stdout: #{@stdout}
    stderr: #{@stderr}
EOH

        base
      end
    end

    class InvalidBerkshelfVersionError < Vagrant::Errors::VagrantError
      def initialize(bin, constraint, version)
        @bin        = bin
        @constraint = constraint
        @version    = version
        super
      end

      def error_message
        <<-EOH
The Berkshelf version at #{@bin.inspect} is invalid.
Vagrant Berkshelf requires #{@constraint}, but the current version is #{@version}.
EOH
      end
    end
  end
end
