# frozen_string_literal: true

module Arel # :nodoc: all
  module Nodes
    class SelectStatement < Arel::Nodes::NodeExpression
      attr_reader :cores
      attr_accessor :limit, :orders, :lock, :offset, :with

      def initialize(cores = [SelectCore.new])
        super()
        @cores          = cores
        @orders         = []
        @limit          = nil
        @lock           = nil
        @offset         = nil
        @with           = nil
      end

      def initialize_copy(other)
        super
        @cores  = @cores.map(&:clone)
        @orders = @orders.map(&:clone)
      end

      def hash
        [@cores, @orders, @limit, @lock, @offset, @with].hash
      end

      def eql?(other)
        self.class == other.class &&
          cores == other.cores &&
          orders == other.orders &&
          limit == other.limit &&
          lock == other.lock &&
          offset == other.offset &&
          with == other.with
      end
      alias == eql?
    end
  end
end
