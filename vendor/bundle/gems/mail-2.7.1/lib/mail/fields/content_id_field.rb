# frozen_string_literal: true

module Mail
  class ContentIdField < StructuredField
    FIELD_NAME = 'content-id'
    CAPITALIZED_FIELD = 'Content-ID'

    def initialize(value = nil, charset = 'utf-8')
      self.charset = charset
      @uniq = 1
      value = if Utilities.blank?(value)
                generate_content_id
              else
                value.to_s
              end
      super(CAPITALIZED_FIELD, value, charset)
      parse
      self
    end

    def parse(val = value)
      @element = Mail::MessageIdsElement.new(val) unless Utilities.blank?(val)
    end

    def element
      @element ||= Mail::MessageIdsElement.new(value)
    end

    def name
      'Content-ID'
    end

    def content_id
      element.message_id
    end

    def to_s
      "<#{content_id}>"
    end

    # TODO: Fix this up
    def encoded
      "#{CAPITALIZED_FIELD}: #{self}\r\n"
    end

    def decoded
      to_s
    end

    private

    def generate_content_id
      "<#{Mail.random_tag}@#{::Socket.gethostname}.mail>"
    end
  end
end
