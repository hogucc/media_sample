# frozen_string_literal: true

require 'mail/fields/common/parameter_hash'

module Mail
  class ContentDispositionField < StructuredField
    FIELD_NAME = 'content-disposition'
    CAPITALIZED_FIELD = 'Content-Disposition'

    def initialize(value = nil, charset = 'utf-8')
      self.charset = charset
      value = ensure_filename_quoted(value)
      super(CAPITALIZED_FIELD, value, charset)
      parse
      self
    end

    def parse(val = value)
      @element = Mail::ContentDispositionElement.new(val) unless Utilities.blank?(val)
    end

    def element
      @element ||= Mail::ContentDispositionElement.new(value)
    end

    def disposition_type
      element.disposition_type
    end

    def parameters
      @parameters = ParameterHash.new
      element.parameters&.each { |p| @parameters.merge!(p) }
      @parameters
    end

    def filename
      @filename = if parameters['filename']
                    parameters['filename']
                  elsif parameters['name']
                    parameters['name']
                  end
      @filename
    end

    # TODO: Fix this up
    def encoded
      p = if !parameters.empty?
            ";\r\n\s#{parameters.encoded}\r\n"
          else
            "\r\n"
          end
      "#{CAPITALIZED_FIELD}: #{disposition_type}" + p
    end

    def decoded
      p = if !parameters.empty?
            "; #{parameters.decoded}"
          else
            ''
          end
      disposition_type.to_s + p
    end
  end
end
