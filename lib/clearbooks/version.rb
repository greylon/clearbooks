#!/usr/bin/env ruby


# @module   Clearbooks Module
# @brief    Implements the Clearbooks module wrapper around the Clearbooks API
module Clearbooks

  VERSION = `git describe --tags`.split("-").first || "0.1.0-wrong-version"

end

# vim:ts=2:tw=100:wm=100:syntax=ruby
