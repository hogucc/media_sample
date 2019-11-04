# frozen_string_literal: true

require 'mail/parsers/content_location_parser'

module Mail
  class ContentLocationElement # :nodoc:
    attr_reader :location

    def initialize(string)
      @location = Mail::Parsers::ContentLocationParser.parse(string).location
    end

    def to_s(*_args)
      location.to_s
    end
  end
end
