# frozen_string_literal: true

module Arel # :nodoc: all
  module Nodes
    class SelectCore < Arel::Nodes::Node
      attr_accessor :projections, :wheres, :groups, :windows, :comment
      attr_accessor :havings, :source, :set_quantifier, :optimizer_hints

      def initialize
        super()
        @source = JoinSource.new nil

        # https://ronsavage.github.io/SQL/sql-92.bnf.html#set%20quantifier
        @set_quantifier  = nil
        @optimizer_hints = nil
        @projections     = []
        @wheres          = []
        @groups          = []
        @havings         = []
        @windows         = []
        @comment         = nil
      end

      def from
        @source.left
      end

      def from=(value)
        @source.left = value
      end

      alias froms= from=
      alias froms from

      def initialize_copy(other)
        super
        @source      = @source.clone if @source
        @projections = @projections.clone
        @wheres      = @wheres.clone
        @groups      = @groups.clone
        @havings     = @havings.clone
        @windows     = @windows.clone
      end

      def hash
        [
          @source, @set_quantifier, @projections, @optimizer_hints,
          @wheres, @groups, @havings, @windows, @comment
        ].hash
      end

      def eql?(other)
        self.class == other.class &&
          source == other.source &&
          set_quantifier == other.set_quantifier &&
          optimizer_hints == other.optimizer_hints &&
          projections == other.projections &&
          wheres == other.wheres &&
          groups == other.groups &&
          havings == other.havings &&
          windows == other.windows &&
          comment == other.comment
      end
      alias == eql?
    end
  end
end
