# frozen_string_literal: true

class Hash
  # Merges the caller into +other_hash+. For example,
  #
  #   options = options.reverse_merge(size: 25, velocity: 10)
  #
  # is equivalent to
  #
  #   options = { size: 25, velocity: 10 }.merge(options)
  #
  # This is particularly useful for initializing an options hash
  # with default values.
  def reverse_merge(other_hash)
    other_hash.merge(self)
  end
  alias with_defaults reverse_merge

  # Destructive +reverse_merge+.
  def reverse_merge!(other_hash)
    replace(reverse_merge(other_hash))
  end
  alias reverse_update reverse_merge!
  alias with_defaults! reverse_merge!
end
