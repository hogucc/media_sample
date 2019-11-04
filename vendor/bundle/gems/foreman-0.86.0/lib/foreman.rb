require 'foreman/version'

module Foreman
  def self.runner
    File.expand_path('../bin/foreman-runner', __dir__)
  end

  def self.ruby_18?
    defined?(RUBY_VERSION) && RUBY_VERSION =~ /^1\.8\.\d+/
  end

  def self.windows?
    defined?(RUBY_PLATFORM) && RUBY_PLATFORM =~ /(win|w)32$/
  end
end
