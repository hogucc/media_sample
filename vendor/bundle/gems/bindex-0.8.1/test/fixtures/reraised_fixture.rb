module Skiptrace
  module ReraisedFixture
    extend self

    def call
      reraise_an_error
    rescue StandardError => e
      exc
    end

    private

    def raise_an_error_in_eval
      method_that_raises
    rescue StandardError => e
      raise e
    end

    def method_that_raises
      raise
    end
  end
end
