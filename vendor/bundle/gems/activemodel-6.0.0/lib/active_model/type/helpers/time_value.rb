# frozen_string_literal: true

require 'active_support/core_ext/string/zones'
require 'active_support/core_ext/time/zones'

module ActiveModel
  module Type
    module Helpers # :nodoc: all
      module TimeValue
        def serialize(value)
          value = apply_seconds_precision(value)

          if value.acts_like?(:time)
            zone_conversion_method = is_utc? ? :getutc : :getlocal

            value = value.send(zone_conversion_method) if value.respond_to?(zone_conversion_method)
          end

          value
        end

        def apply_seconds_precision(value)
          return value unless precision && value.respond_to?(:nsec)

          number_of_insignificant_digits = 9 - precision
          round_power = 10**number_of_insignificant_digits
          rounded_off_nsec = value.nsec % round_power

          if rounded_off_nsec > 0
            value.change(nsec: value.nsec - rounded_off_nsec)
          else
            value
          end
        end

        def type_cast_for_schema(value)
          value.to_s(:db).inspect
        end

        def user_input_in_time_zone(value)
          value.in_time_zone
        end

        private

        def new_time(year, mon, mday, hour, min, sec, microsec, offset = nil)
          # Treat 0000-00-00 00:00:00 as nil.
          return if year.nil? || (year == 0 && mon == 0 && mday == 0)

          if offset
            time = begin
                       ::Time.utc(year, mon, mday, hour, min, sec, microsec)
                   rescue StandardError
                     nil
                     end
            return unless time

            time -= offset
            is_utc? ? time : time.getlocal
          else
            begin
                ::Time.public_send(default_timezone, year, mon, mday, hour, min, sec, microsec)
            rescue StandardError
              nil
              end
          end
        end

        ISO_DATETIME = /\A(\d{4})-(\d\d)-(\d\d) (\d\d):(\d\d):(\d\d)(\.\d+)?\z/.freeze

        # Doesn't handle time zones.
        def fast_string_to_time(string)
          if string =~ ISO_DATETIME
            microsec_part = Regexp.last_match(7)
            if microsec_part&.start_with?('.') && microsec_part.length == 7
              microsec_part[0] = ''
              microsec = microsec_part.to_i
            else
              microsec = (microsec_part.to_r * 1_000_000).to_i
            end
            new_time Regexp.last_match(1).to_i, Regexp.last_match(2).to_i, Regexp.last_match(3).to_i, Regexp.last_match(4).to_i, Regexp.last_match(5).to_i, Regexp.last_match(6).to_i, microsec
          end
        end
      end
    end
  end
end
