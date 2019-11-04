# frozen_string_literal: true

module Arel # :nodoc: all
  module Nodes
    class UpdateStatement < Arel::Nodes::Node
      attr_accessor :relation, :wheres, :values, :orders, :limit, :offset, :key

      def initialize
        @relation = nil
        @wheres   = []
        @values   = []
        @orders   = []
        @limit    = nil
        @offset   = nil
        @key      = nil
      end

      def initialize_copy(other)
        super
        @wheres = @wheres.clone
        @values = @values.clone
      end

      def hash
        [@relation, @wheres, @values, @orders, @limit, @offset, @key].hash
      end

      def eql?(other)
        self.class == other.class &&
          relation == other.relation &&
          wheres == other.wheres &&
          values == other.values &&
          orders == other.orders &&
          limit == other.limit &&
          offset == other.offset &&
          key == other.key
      end
      alias == eql?
    end
  end
end
