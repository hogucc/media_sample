# frozen_string_literal: true

require 'time'
require 'base64'
require 'bigdecimal'
require 'bigdecimal/util'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/date_time/calculations'

module ActiveSupport
  # = XmlMini
  #
  # To use the much faster libxml parser:
  #   gem 'libxml-ruby', '=0.9.7'
  #   XmlMini.backend = 'LibXML'
  module XmlMini
    extend self

    # This module decorates files deserialized using Hash.from_xml with
    # the <tt>original_filename</tt> and <tt>content_type</tt> methods.
    module FileLike #:nodoc:
      attr_writer :original_filename, :content_type

      def original_filename
        @original_filename || 'untitled'
      end

      def content_type
        @content_type || 'application/octet-stream'
      end
    end

    unless defined?(DEFAULT_ENCODINGS)
      DEFAULT_ENCODINGS = {
        'binary' => 'base64'
      }.freeze
    end

    unless defined?(TYPE_NAMES)
      TYPE_NAMES = {
        'Symbol' => 'symbol',
        'Integer' => 'integer',
        'BigDecimal' => 'decimal',
        'Float' => 'float',
        'TrueClass' => 'boolean',
        'FalseClass' => 'boolean',
        'Date' => 'date',
        'DateTime' => 'dateTime',
        'Time' => 'dateTime',
        'Array' => 'array',
        'Hash' => 'hash'
      }.freeze
    end

    unless defined?(FORMATTING)
      FORMATTING = {
        'symbol' => proc { |symbol| symbol.to_s },
        'date' => proc { |date| date.to_s(:db) },
        'dateTime' => proc { |time| time.xmlschema },
        'binary' => proc { |binary| ::Base64.encode64(binary) },
        'yaml' => proc { |yaml| yaml.to_yaml }
      }.freeze
    end

    # TODO: use regexp instead of Date.parse
    unless defined?(PARSING)
      PARSING = {
        'symbol' => proc { |symbol| symbol.to_s.to_sym },
        'date' => proc { |date| ::Date.parse(date) },
        'datetime' => proc { |time|
                        begin
                                                 Time.xmlschema(time).utc
                        rescue StandardError
                          ::DateTime.parse(time).utc
                                               end
                      },
        'integer' => proc { |integer| integer.to_i },
        'float' => proc { |float| float.to_f },
        'decimal' => proc do |number|
          if String === number
            number.to_d
          else
            BigDecimal(number)
          end
        end,
        'boolean' => proc { |boolean| %w[1 true].include?(boolean.to_s.strip) },
        'string' => proc { |string| string.to_s },
        'yaml' => proc { |yaml|
                    begin
                                                 YAML.safe_load(yaml)
                    rescue StandardError
                      yaml
                                               end
                  },
        'base64Binary' => proc { |bin| ::Base64.decode64(bin) },
        'binary' => proc { |bin, entity| _parse_binary(bin, entity) },
        'file' => proc { |file, entity| _parse_file(file, entity) }
      }.freeze

      PARSING.update(
        'double' => PARSING['float'],
        'dateTime' => PARSING['datetime']
      )
    end

    attr_accessor :depth
    self.depth = 100

    delegate :parse, to: :backend

    def backend
      current_thread_backend || @backend
    end

    def backend=(name)
      backend = name && cast_backend_name_to_module(name)
      self.current_thread_backend = backend if current_thread_backend
      @backend = backend
    end

    def with_backend(name)
      old_backend = current_thread_backend
      self.current_thread_backend = name && cast_backend_name_to_module(name)
      yield
    ensure
      self.current_thread_backend = old_backend
    end

    def to_tag(key, value, options)
      type_name = options.delete(:type)
      merged_options = options.merge(root: key, skip_instruct: true)

      if value.is_a?(::Method) || value.is_a?(::Proc)
        if value.arity == 1
          value.call(merged_options)
        else
          value.call(merged_options, key.to_s.singularize)
        end
      elsif value.respond_to?(:to_xml)
        value.to_xml(merged_options)
      else
        type_name ||= TYPE_NAMES[value.class.name]
        type_name ||= value.class.name if value && !value.respond_to?(:to_str)
        type_name   = type_name.to_s   if type_name
        type_name   = 'dateTime' if type_name == 'datetime'

        key = rename_key(key.to_s, options)

        attributes = options[:skip_types] || type_name.nil? ? {} : { type: type_name }
        attributes[:nil] = true if value.nil?

        encoding = options[:encoding] || DEFAULT_ENCODINGS[type_name]
        attributes[:encoding] = encoding if encoding

        formatted_value = FORMATTING[type_name] && !value.nil? ?
          FORMATTING[type_name].call(value) : value

        options[:builder].tag!(key, formatted_value, attributes)
      end
    end

    def rename_key(key, options = {})
      camelize  = options[:camelize]
      dasherize = !options.key?(:dasherize) || options[:dasherize]
      if camelize
        key = camelize == true ? key.camelize : key.camelize(camelize)
      end
      key = _dasherize(key) if dasherize
      key
    end

    private

    def _dasherize(key)
      # $2 must be a non-greedy regex for this to work
      left, middle, right = /\A(_*)(.*?)(_*)\Z/.match(key.strip)[1, 3]
      "#{left}#{middle.tr('_ ', '--')}#{right}"
    end

    # TODO: Add support for other encodings
    def _parse_binary(bin, entity)
      case entity['encoding']
      when 'base64'
        ::Base64.decode64(bin)
      else
        bin
      end
    end

    def _parse_file(file, entity)
      f = StringIO.new(::Base64.decode64(file))
      f.extend(FileLike)
      f.original_filename = entity['name']
      f.content_type = entity['content_type']
      f
    end

    def current_thread_backend
      Thread.current[:xml_mini_backend]
    end

    def current_thread_backend=(name)
      Thread.current[:xml_mini_backend] = name && cast_backend_name_to_module(name)
    end

    def cast_backend_name_to_module(name)
      if name.is_a?(Module)
        name
      else
        require "active_support/xml_mini/#{name.downcase}"
        ActiveSupport.const_get("XmlMini_#{name}")
      end
    end
  end

  XmlMini.backend = 'REXML'
end
