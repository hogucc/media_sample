module ChildProcess
  module JRuby
    class IO < AbstractIO
      private

      def check_type(output)
        raise ArgumentError, "expected #{output.inspect} to respond to :to_outputstream" unless output.respond_to?(:to_outputstream) && output.respond_to?(:write)
      end
    end # IO
  end # Unix
end # ChildProcess
