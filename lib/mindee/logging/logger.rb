# frozen_string_literal: true

require 'logger'

module Mindee
  # Mindee logging module.
  module Logging
    @logger = Logger.new($stdout)

    class << self
      attr_accessor :logger
    end
  end
end
