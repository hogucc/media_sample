# frozen_string_literal: true

module ActionView #:nodoc:
  # = Action View Text Template
  class Template #:nodoc:
    class Text #:nodoc:
      attr_accessor :type

      def initialize(string)
        @string = string.to_s
      end

      def identifier
        'text template'
      end

      alias inspect identifier

      def to_str
        @string
      end

      def render(*_args)
        to_str
      end

      def format
        :text
      end

      def formats
        Array(format)
      end
      deprecate :formats
    end
  end
end
