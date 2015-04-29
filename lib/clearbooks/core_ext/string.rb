#!/usr/bin/env ruby


# @class        class String
# @brief
class String
  TRUE_VALUES = %W{1 t true on y yes}.freeze

  # @fn         def to_b {{{
  # @brief      Converts String to Boolean value
  # @credit     https://github.com/prodis/wannabe_bool/blob/master/lib/wannabe_bool/object.rb
  def to_b
    TRUE_VALUES.include?(self.to_s.strip.downcase)
  end
end


# vim:ts=2:tw=100:wm=100
