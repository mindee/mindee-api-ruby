# frozen_string_literal: true

require_relative 'mindee_error'

module Mindee
  module Errors
    # API HttpError
    class MindeeHTTPError < MindeeError
      # @return [String]
      attr_reader :status_code
      # @return [Integer]
      attr_reader :api_code
      # @return [String]
      attr_reader :api_details
      # @return [String]
      attr_reader :api_message

      # @param http_error [Hash]
      # @param url [String]
      # @param code [Integer]
      def initialize(http_error, url, code)
        @status_code = code
        @api_code = http_error['code']
        @api_details = http_error['details']
        @api_message = http_error['message']
        super("#{url} #{@status_code} HTTP error: #{@api_details} - #{@api_message}")
      end
    end

    # Base class for all client-side errors.
    class MindeeHTTPClientError < MindeeHTTPError; end

    # Base class for all server-side errors.
    class MindeeHTTPServerError < MindeeHTTPError; end
  end
end
