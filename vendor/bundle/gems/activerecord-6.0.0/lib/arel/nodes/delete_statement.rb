# frozen_string_literal: true

module Arel # :nodoc: all
  module Nodes
    class DeleteStatement < Arel::Nodes::Node
      attr_accessor :left, :right, :orders, :limit, :offset, :key

      alias relation left
      alias relation= left=
      alias wheres right
      alias wheres= right=

      def initialize(relation = nil, wheres = [])
        super()
        @left = relation
        @right = wheres
        @orders = []
        @limit = nil
        @offset = nil
        @key = nil
      end

      def initialize_copy(other)
        super
        @left  = @left.clone if @left
        @right = @right.clone if @right
      end

      def hash
        [self.class, @left, @right, @orders, @limit, @offset, @key].hash
      end

      def eql?(other)
        self.class == other.class &&
          left == other.left &&
          right == other.right &&
          orders == other.orders &&
          limit == other.limit &&
          offset == other.offset &&
          key == other.key
      end
      alias == eql?
    end
  end
end
