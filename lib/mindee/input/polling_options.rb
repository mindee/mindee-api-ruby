# frozen_string_literal: true

module Mindee
  module Input
    # Options for asynchronous polling.
    class PollingOptions
      # @return [Integer, Float] Initial delay before the first polling attempt (in seconds).
      attr_reader :initial_delay_sec

      # @return [Integer, Float] Delay between each polling attempt (in seconds).
      attr_reader :delay_sec

      # @return [Integer] Total number of polling attempts.
      attr_reader :max_retries

      # @param initial_delay_sec [Float] Initial delay before the first attempt (default:2.0).
      # @param delay_sec [Float] Delay between attempts (default: 1.5).
      # @param max_retries [Integer] Maximum number of retries (default:80).
      def initialize(initial_delay_sec: 2.0, delay_sec: 1.5, max_retries: 80)
        @initial_delay_sec = initial_delay_sec
        @delay_sec = delay_sec
        @max_retries = max_retries
      end
    end
  end
end
