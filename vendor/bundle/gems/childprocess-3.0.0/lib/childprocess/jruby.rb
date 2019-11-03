require 'java'
require 'jruby'

class Java::SunNioCh::FileChannelImpl
  field_reader :fd
end

class Java::JavaIo::FileDescriptor
  field_reader :handle if ChildProcess.os == :windows

  field_reader :fd
end

module ChildProcess
  module JRuby
    def self.posix_fileno_for(obj)
      channel = ::JRuby.reference(obj).channel
      begin
        channel.getFDVal
      rescue NoMethodError
        fileno = channel.fd
        fileno = fileno.fd if fileno.is_a?(Java::JavaIo::FileDescriptor)

        fileno == -1 ? obj.fileno : fileno
      end
    rescue StandardError
      # fall back
      obj.fileno
    end

    def self.windows_handle_for(obj)
      channel = ::JRuby.reference(obj).channel
      fileno = obj.fileno

      begin
        fileno = channel.getFDVal
      rescue NoMethodError
        fileno = channel.fd if channel.respond_to?(:fd)
      end

      if fileno.is_a? Java::JavaIo::FileDescriptor
        fileno.handle
      else
        Windows::Lib.handle_for fileno
      end
    end
  end
end

require 'childprocess/jruby/pump'
require 'childprocess/jruby/io'
require 'childprocess/jruby/process'
