# frozen_string_literal: true

module ActiveRecord
  module ConnectionAdapters
    module PostgreSQL
      module OID # :nodoc:
        class Uuid < Type::Value # :nodoc:
          ACCEPTABLE_UUID = /\A(\{)?([a-fA-F0-9]{4}-?){8}(?(1)\}|)\z/.freeze

          alias serialize deserialize

          def type
            :uuid
          end

          private

          def cast_value(value)
            casted = value.to_s
            casted if casted.match?(ACCEPTABLE_UUID)
          end
        end
      end
    end
  end
end
