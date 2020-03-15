# frozen_string_literal: true

module Mail
  class MimeVersionField < StructuredField
    FIELD_NAME = 'mime-version'
    CAPITALIZED_FIELD = 'Mime-Version'

    def initialize(value = nil, charset = 'utf-8')
      self.charset = charset
      value = '1.0' if Utilities.blank?(value)
      super(CAPITALIZED_FIELD, value, charset)
      parse
      self
    end

    def parse(val = value)
      @element = Mail::MimeVersionElement.new(val) unless Utilities.blank?(val)
    end

    def element
      @element ||= Mail::MimeVersionElement.new(value)
    end

    def version
      "#{element.major}.#{element.minor}"
    end

    def major
      element.major.to_i
    end

    def minor
      element.minor.to_i
    end

    def encoded
      "#{CAPITALIZED_FIELD}: #{version}\r\n"
    end

    def decoded
      version
    end
  end
end
