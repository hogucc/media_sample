module ChildProcess
  module Unix
    class IO < AbstractIO
      private

      def check_type(io)
        raise ArgumentError, "expected #{io.inspect} to respond to :to_io" unless io.respond_to? :to_io

        result = io.to_io
        raise TypeError, "expected IO, got #{result.inspect}:#{result.class}" unless result&.is_a?(::IO)
      end
    end # IO
  end # Unix
end # ChildProcess
