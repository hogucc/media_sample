# frozen_string_literal: true

require 'active_model/attribute'

module ActiveModel
  class AttributeSet # :nodoc:
    class Builder # :nodoc:
      attr_reader :types, :default_attributes

      def initialize(types, default_attributes = {})
        @types = types
        @default_attributes = default_attributes
      end

      def build_from_database(values = {}, additional_types = {})
        attributes = LazyAttributeHash.new(types, values, additional_types, default_attributes)
        AttributeSet.new(attributes)
      end
    end
  end

  class LazyAttributeHash # :nodoc:
    delegate :transform_values, :each_key, :each_value, :fetch, :except, to: :materialize

    def initialize(types, values, additional_types, default_attributes, delegate_hash = {})
      @types = types
      @values = values
      @additional_types = additional_types
      @materialized = false
      @delegate_hash = delegate_hash
      @default_attributes = default_attributes
    end

    def key?(key)
      delegate_hash.key?(key) || values.key?(key) || types.key?(key)
    end

    def [](key)
      delegate_hash[key] || assign_default_value(key)
    end

    def []=(key, value)
      raise "Can't modify frozen hash" if frozen?

      delegate_hash[key] = value
    end

    def deep_dup
      dup.tap do |copy|
        copy.instance_variable_set(:@delegate_hash, delegate_hash.transform_values(&:dup))
      end
    end

    def initialize_dup(_)
      @delegate_hash = Hash[delegate_hash]
      super
    end

    def select
      keys = types.keys | values.keys | delegate_hash.keys
      keys.each_with_object({}) do |key, hash|
        attribute = self[key]
        hash[key] = attribute if yield(key, attribute)
      end
    end

    def ==(other)
      materialize == if other.is_a?(LazyAttributeHash)
                       other.materialize
                     else
                       other
                     end
    end

    def marshal_dump
      [@types, @values, @additional_types, @default_attributes, @delegate_hash]
    end

    def marshal_load(values)
      if values.is_a?(Hash)
        empty_hash = {}.freeze
        initialize(empty_hash, empty_hash, empty_hash, empty_hash, values)
        @materialized = true
      else
        initialize(*values)
      end
    end

    protected

    def materialize
      unless @materialized
        values.each_key { |key| self[key] }
        types.each_key { |key| self[key] }
        @materialized = true unless frozen?
      end
      delegate_hash
    end

    private

    attr_reader :types, :values, :additional_types, :delegate_hash, :default_attributes

    def assign_default_value(name)
      type = additional_types.fetch(name, types[name])
      value_present = true
      value = values.fetch(name) { value_present = false }

      if value_present
        delegate_hash[name] = Attribute.from_database(name, value, type)
      elsif types.key?(name)
        attr = default_attributes[name]
        delegate_hash[name] = if attr
                                attr.dup
                              else
                                Attribute.uninitialized(name, type)
                              end
      end
    end
  end
end
