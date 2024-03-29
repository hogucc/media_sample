require 'foreman'
require 'foreman/helpers'
require 'pathname'

module Foreman::Export
  extend Foreman::Helpers

  class Exception < RuntimeError; end

  def self.formatter(format)
    require "foreman/export/#{format.tr('-', '_')}"
    classy_format = classify(format)
    formatter     = constantize("Foreman::Export::#{classy_format}")
  rescue NameError => e
    error "Unknown export format: #{format} (no class Foreman::Export::#{classy_format})."
  rescue LoadError => e
    error "Unknown export format: #{format} (unable to load file 'foreman/export/#{format.tr('-', '_')}')."
  end

  def self.error(message)
    raise Foreman::Export::Exception, message
  end
end

require 'foreman/export/base'
require 'foreman/export/inittab'
require 'foreman/export/upstart'
require 'foreman/export/daemon'
require 'foreman/export/bluepill'
require 'foreman/export/runit'
require 'foreman/export/supervisord'
require 'foreman/export/launchd'
require 'foreman/export/systemd'
