# frozen_string_literal: true

module ActiveRecord
  module Railties # :nodoc:
    module CollectionCacheAssociationLoading #:nodoc:
      def setup(context, options, as, block)
        @relation = relation_from_options(options)

        super
      end

      def relation_from_options(cached: nil, partial: nil, collection: nil, **_)
        return unless cached

        relation = partial if partial.is_a?(ActiveRecord::Relation)
        relation ||= collection if collection.is_a?(ActiveRecord::Relation)

        relation.skip_preloading! if relation && !relation.loaded?
      end

      def collection_without_template(*)
        @relation&.preload_associations(@collection)
        super
      end

      def collection_with_template(*)
        @relation&.preload_associations(@collection)
        super
      end
    end
  end
end
