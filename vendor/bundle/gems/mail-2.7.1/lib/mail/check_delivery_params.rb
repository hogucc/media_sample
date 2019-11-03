# frozen_string_literal: true

module Mail
  module CheckDeliveryParams #:nodoc:
    class << self
      def check(mail)
        [check_from(mail.smtp_envelope_from),
         check_to(mail.smtp_envelope_to),
         check_message(mail)]
      end

      def check_from(addr)
        raise ArgumentError, "SMTP From address may not be blank: #{addr.inspect}" if Utilities.blank?(addr)

        check_addr 'From', addr
      end

      def check_to(addrs)
        raise ArgumentError, "SMTP To address may not be blank: #{addrs.inspect}" if Utilities.blank?(addrs)

        Array(addrs).map do |addr|
          check_addr 'To', addr
        end
      end

      def check_addr(addr_name, addr)
        validate_smtp_addr addr do |error_message|
          raise ArgumentError, "SMTP #{addr_name} address #{error_message}: #{addr.inspect}"
        end
      end

      def validate_smtp_addr(addr)
        if addr
          yield 'may not exceed 2kB' if addr.bytesize > 2048

          if /[\r\n]/ =~ addr
            yield 'may not contain CR or LF line breaks'
          end
        end

        addr
      end

      def check_message(message)
        message = message.encoded if message.respond_to?(:encoded)

        raise ArgumentError, 'An encoded message is required to send an email' if Utilities.blank?(message)

        message
      end
    end
  end
end
