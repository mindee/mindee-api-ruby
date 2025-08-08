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

      # @param http_error [Hash, Parsing::V2::ErrorResponse]
      def initialize(http_error)
        if http_error.is_a?(Parsing::V2::ErrorResponse)
          http_error = { 'detail' => http_error.detail,
                         'status' => http_error.status }
        end
        @status = http_error['status']
        @detail = http_error['detail']
        super("HTTP error: #{@status} - #{@detail}")
      end
    end
  end
end
