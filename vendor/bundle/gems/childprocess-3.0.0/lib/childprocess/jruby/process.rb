require 'java'

module ChildProcess
  module JRuby
    class Process < AbstractProcess
      def initialize(args)
        super(args)

        @pumps = []
      end

      def io
        @io ||= JRuby::IO.new
      end

      def exited?
        return true if @exit_code

        assert_started
        @exit_code = @process.exitValue
        stop_pumps

        true
      rescue java.lang.IllegalThreadStateException => e
        log(e.class => e.message)
        false
      ensure
        log(exit_code: @exit_code)
      end

      def stop(_timeout = nil)
        assert_started

        @process.destroy
        wait # no way to actually use the timeout here..
      end

      def wait
        if exited?
          exit_code
        else
          @process.waitFor

          stop_pumps
          @exit_code = @process.exitValue
        end
      end

      # Implementation of ChildProcess::JRuby::Process#pid depends heavily on
      # what Java SDK is being used; here, we look it up once at load, then
      # define the method once to avoid runtime overhead.
      normalised_java_version_major = java.lang.System.get_property('java.version')
                                          .slice(/^(1\.)?([0-9]+)/, 2)
                                          .to_i
      if normalised_java_version_major >= 9

        # On modern Javas, we can simply delegate through to `Process#pid`,
        # which was introduced in Java 9.
        #
        # @return [Integer] the pid of the process after it has started
        # @raise [NotImplementedError] when trying to access pid on platform for
        #                              which it is unsupported in Java
        def pid
          @process.pid
        rescue java.lang.UnsupportedOperationException => e
          raise NotImplementedError, "pid is not supported on this platform: #{e.message}"
        end

      else

        # On Legacy Javas, fall back to reflection.
        #
        # Only supported in JRuby on a Unix operating system, thanks to limitations
        # in Java's classes
        #
        # @return [Integer] the pid of the process after it has started
        # @raise [NotImplementedError] when trying to access pid on non-Unix platform
        #
        def pid
          raise NotImplementedError, 'pid is only supported by JRuby child processes on Unix' if @process.getClass.getName != 'java.lang.UNIXProcess'

          # About the best way we can do this is with a nasty reflection-based impl
          # Thanks to Martijn Courteaux
          # http://stackoverflow.com/questions/2950338/how-can-i-kill-a-linux-process-in-java-with-sigkill-process-destroy-does-sigter/2951193#2951193
          field = @process.getClass.getDeclaredField('pid')
          field.accessible = true
          field.get(@process)
        end

      end

      private

      def launch_process
        pb = java.lang.ProcessBuilder.new(@args)

        pb.directory java.io.File.new(@cwd || Dir.pwd)
        set_env pb.environment

        begin
          @process = pb.start
        rescue java.io.IOException => e
          raise LaunchError, e.message
        end

        setup_io
      end

      def setup_io
        if @io
          redirect(@process.getErrorStream, @io.stderr)
          redirect(@process.getInputStream, @io.stdout)
        else
          @process.getErrorStream.close
          @process.getInputStream.close
        end

        if duplex?
          io._stdin = create_stdin
        else
          @process.getOutputStream.close
        end
      end

      def redirect(input, output)
        if output.nil?
          input.close
          return
        end

        @pumps << Pump.new(input, output.to_outputstream).run
      end

      def stop_pumps
        @pumps.each(&:stop)
      end

      def set_env(env)
        merged = ENV.to_hash

        @environment.each { |k, v| merged[k.to_s] = v }

        merged.each do |k, v|
          if v
            env.put(k, v.to_s)
          elsif env.key? k
            env.remove(k)
          end
        end

        removed_keys = env.key_set.to_a - merged.keys
        removed_keys.each { |k| env.remove(k) }
      end

      def create_stdin
        output_stream = @process.getOutputStream

        stdin = output_stream.to_io
        stdin.sync = true
        stdin.instance_variable_set(:@childprocess_java_stream, output_stream)

        class << stdin
          # The stream provided is a BufferedeOutputStream, so we
          # have to flush it to make the bytes flow to the process
          def __childprocess_flush__
            @childprocess_java_stream.flush
          end

          [:flush, :print, :printf, :putc, :puts, :write, :write_nonblock].each do |m|
            define_method(m) do |*args|
              super(*args)
              __childprocess_flush__
            end
          end
        end

        stdin
      end
    end # Process
  end # JRuby
end # ChildProcess
