# frozen_string_literal: true

module ActiveRecord
  module ConnectionAdapters
    module SQLite3
      class SchemaCreation < AbstractAdapter::SchemaCreation # :nodoc:
        private

        def add_column_options!(sql, options)
          sql << " COLLATE \"#{options[:collation]}\"" if options[:collation]
          super
        end
      end
    end
  end
end
