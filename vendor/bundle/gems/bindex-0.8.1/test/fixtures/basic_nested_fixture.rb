module Skiptrace
  module BasicNestedFixture
    extend self

    def call
      raise_an_error
    rescue StandardError => e
      exc
    end

    private

    def raise_an_error
      raise
    end
  end
end
