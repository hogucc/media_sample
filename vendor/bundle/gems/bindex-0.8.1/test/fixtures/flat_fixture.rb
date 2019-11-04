module Skiptrace
  module FlatFixture
    def self.call
      raise
    rescue StandardError => e
      exc
    end
  end
end
