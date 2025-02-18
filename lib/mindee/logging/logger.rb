# frozen_string_literal: true

require 'logger'

module Mindee
  # Mindee logging module.
  module Logging
    @logger = Logger.new($stdout)
    log_level = ENV.fetch('MINDEE_LOG_LEVEL', 'WARN')
    @logger.level = Logger.const_get(log_level)

    class << self
      attr_accessor :logger
    end
  end
end
