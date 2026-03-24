# frozen_string_literal: true

require 'logger'

module Mindee
  # Mindee logging module.
  module Logging
    log_level = ENV.fetch('MINDEE_LOG_LEVEL', 'WARN')
    log_output = ENV.fetch('MINDEE_LOG_OUTPUT', 'stderr')
    @logger = if log_output == 'stderr'
                Logger.new($stderr)
              elsif log_output == 'stdout'
                Logger.new($stdout)
              else
                warn "Invalid MINDEE_LOG_OUTPUT='#{log_output}', defaulting to 'stderr'"
                Logger.new($stderr)
              end
    @logger.level = Logger.const_get(log_level)

    class << self
      attr_accessor :logger
    end
  end
end
