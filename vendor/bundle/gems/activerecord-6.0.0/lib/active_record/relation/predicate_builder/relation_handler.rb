# frozen_string_literal: true

module ActiveRecord
  class PredicateBuilder
    class RelationHandler # :nodoc:
      def call(attribute, value)
        value = value.send(:apply_join_dependency) if value.eager_loading?

        value = value.select(value.arel_attribute(value.klass.primary_key)) if value.select_values.empty?

        attribute.in(value.arel)
      end
    end
  end
end
