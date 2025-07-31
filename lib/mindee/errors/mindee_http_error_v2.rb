# frozen_string_literal: true

require_relative 'mindee_error'

module Mindee
  module Errors
    # API V2 HttpError
    class MindeeHTTPErrorV2 < MindeeError
      # @return [Integer]
      attr_reader :status
      # @return [String]
      attr_reader :detail

      # @param http_error [Hash]
      # @param code [Integer]
      def initialize(http_error)
        @status = http_error['status']
        @detail = http_error['detail']
        super("HTTP error: #{@status} - #{@detail}")
      end
    end
  end
end
