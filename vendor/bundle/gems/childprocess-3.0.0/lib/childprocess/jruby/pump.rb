module ChildProcess
  module JRuby
    class Pump
      BUFFER_SIZE = 2048

      def initialize(input, output)
        @input  = input
        @output = output
        @stop   = false
      end

      def stop
        @stop = true
        @thread&.join
      end

      def run
        @thread = Thread.new { pump }

        self
      end

      private

      def pump
        buffer = Java.byte[BUFFER_SIZE].new

        until @stop && (@input.available == 0)
          read = 0
          avail = 0

          while read != -1
            avail = [@input.available, 1].max
            avail = BUFFER_SIZE if avail > BUFFER_SIZE
            read = @input.read(buffer, 0, avail)

            if read > 0
              @output.write(buffer, 0, read)
              @output.flush
            end
          end

          sleep 0.1
        end

        @output.flush
      rescue java.io.IOException => e
        ChildProcess.logger.debug e.message
        ChildProcess.logger.debug e.backtrace
      end
    end # Pump
  end # JRuby
end # ChildProcess
