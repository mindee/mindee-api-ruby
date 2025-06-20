# frozen_string_literal: true

# Mindee
module Mindee
  # Current version.
  VERSION = '4.6.0'

  # Finds and return the current platform.
  # @return [Symbol, Hash[Symbol | String, Regexp], Nil?]
  def self.find_platform
    host = RbConfig::CONFIG['host_os']
    platforms = {
      linux: %r{linux|cygwin},
      windows: %r{mswin|mingw|bccwin|wince|emx|win32},
      macos: %r{mac|darwin},
      bsd: %r{bsd},
      solaris: %r{solaris|sunos},
    }
    platforms.each do |os, regexp|
      return os unless (regexp =~ host).nil?
    end
  end

  # Current platform.
  PLATFORM = find_platform.freeze
end
