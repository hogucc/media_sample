# heavily based on Masao Mutoh's gettext String interpolation extension
# http://github.com/mutoh/gettext/blob/f6566738b981fe0952548c421042ad1e0cdfb31e/lib/gettext/core_ext/string.rb

module I18n
  DEFAULT_INTERPOLATION_PATTERNS = [
    /%%/,
    /%\{([\w|]+)\}/,                            # matches placeholders like "%{foo} or %{foo|word}"
    /%<(\w+)>(.*?\d*\.?\d*[bBdiouxXeEfgGcps])/  # matches placeholders like "%<foo>.d"
  ].freeze
  INTERPOLATION_PATTERN = Regexp.union(DEFAULT_INTERPOLATION_PATTERNS)
  deprecate_constant :INTERPOLATION_PATTERN if method_defined? :INTERPOLATION_PATTERN

  class << self
    # Return String or raises MissingInterpolationArgument exception.
    # Missing argument's logic is handled by I18n.config.missing_interpolation_argument_handler.
    def interpolate(string, values)
      raise ReservedInterpolationKey.new(Regexp.last_match(1).to_sym, string) if string =~ RESERVED_KEYS_PATTERN
      raise ArgumentError, 'Interpolation values must be a Hash.' unless values.is_a?(Hash)

      interpolate_hash(string, values)
    end

    def interpolate_hash(string, values)
      string.gsub(Regexp.union(config.interpolation_patterns)) do |match|
        if match == '%%'
          '%'
        else
          key = (Regexp.last_match(1) || Regexp.last_match(2) || match.tr('%{}', '')).to_sym
          value = if values.key?(key)
                    values[key]
                  else
                    config.missing_interpolation_argument_handler.call(key, values, string)
                  end
          value = value.call(values) if value.respond_to?(:call)
          Regexp.last_match(3) ? format("%#{Regexp.last_match(3)}", value) : value
        end
      end
    end
  end
end
