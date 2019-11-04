# frozen_string_literal: true

require 'mail/fields/common/address_container'

module Mail
  module CommonAddress # :nodoc:
    def parse(val = value)
      @address_list = AddressList.new(encode_if_needed(val)) unless Utilities.blank?(val)
    end

    def charset
      @charset
    end

    def encode_if_needed(val) #:nodoc:
      # Need to join arrays of addresses into a single value
      if val.is_a?(Array)
        val.compact.map { |a| encode_if_needed a }.join(', ')

      # Pass through UTF-8; encode non-UTF-8.
      else
        utf8_if_needed(val) || Encodings.encode_non_usascii(val, charset)
      end
    end

    # Allows you to iterate through each address object in the address_list
    def each
      address_list.addresses.each do |address|
        yield(address)
      end
    end

    # Returns the address string of all the addresses in the address list
    def addresses
      list = address_list.addresses.map(&:address)
      Mail::AddressContainer.new(self, list)
    end

    # Returns the formatted string of all the addresses in the address list
    def formatted
      list = address_list.addresses.map(&:format)
      Mail::AddressContainer.new(self, list)
    end

    # Returns the display name of all the addresses in the address list
    def display_names
      list = address_list.addresses.map(&:display_name)
      Mail::AddressContainer.new(self, list)
    end

    # Returns the actual address objects in the address list
    def addrs
      list = address_list.addresses
      Mail::AddressContainer.new(self, list)
    end

    # Returns a hash of group name => address strings for the address list
    def groups
      address_list.addresses_grouped_by_group
    end

    # Returns the addresses that are part of groups
    def group_addresses
      decoded_group_addresses
    end

    # Returns a list of decoded group addresses
    def decoded_group_addresses
      groups.map { |_k, v| v.map(&:decoded) }.flatten
    end

    # Returns a list of encoded group addresses
    def encoded_group_addresses
      groups.map { |_k, v| v.map(&:encoded) }.flatten
    end

    # Returns the name of all the groups in a string
    def group_names # :nodoc:
      address_list.group_names
    end

    def default
      addresses
    end

    def <<(val)
      if val.nil?
        raise ArgumentError, 'Need to pass an address to <<'
      elsif Utilities.blank?(val)
        parse(encoded)
      else
        self.value = [value, val].reject { |a| Utilities.blank?(a) }.join(', ')
      end
    end

    def value=(val)
      super
      parse(value)
    end

    private

    if 'string'.respond_to?(:encoding)
      # Pass through UTF-8 addresses
      def utf8_if_needed(val)
        if charset =~ /\AUTF-?8\z/i
          val
        elsif val.encoding == Encoding::UTF_8
          val
        elsif (utf8 = val.dup.force_encoding(Encoding::UTF_8)).valid_encoding?
          utf8
        end
      end
    else
      def utf8_if_needed(val)
        val if charset =~ /\AUTF-?8\z/i
      end
    end

    def do_encode(field_name)
      return '' if Utilities.blank?(value)

      address_array = address_list.addresses.reject { |a| encoded_group_addresses.include?(a.encoded) }.compact.map(&:encoded)
      address_text  = address_array.join(", \r\n\s")
      group_array = groups.map { |k, v| "#{k}: #{v.map(&:encoded).join(", \r\n\s")};" }
      group_text  = group_array.join(" \r\n\s")
      return_array = [address_text, group_text].reject { |a| Utilities.blank?(a) }
      "#{field_name}: #{return_array.join(", \r\n\s")}\r\n"
    end

    def do_decode
      return nil if Utilities.blank?(value)

      address_array = address_list.addresses.reject { |a| decoded_group_addresses.include?(a.decoded) }.map(&:decoded)
      address_text  = address_array.join(', ')
      group_array = groups.map { |k, v| "#{k}: #{v.map(&:decoded).join(', ')};" }
      group_text  = group_array.join(' ')
      return_array = [address_text, group_text].reject { |a| Utilities.blank?(a) }
      return_array.join(', ')
    end

    def address_list # :nodoc:
      @address_list ||= AddressList.new(value)
    end

    def get_group_addresses(group_list)
      if group_list.respond_to?(:addresses)
        group_list.addresses.map do |address|
          Mail::Address.new(address)
        end
      else
        []
      end
    end
  end
end
