# frozen_string_literal: true

require_relative 'mindee_error'
require_relative '../parsing/v2/error_item'

module Mindee
  module Errors
    # API V2 HttpError
    class MindeeHTTPErrorV2 < MindeeError
      # @return [Integer] The HTTP status code returned by the server.
      attr_reader :status
      # @return [String] A human-readable explanation specific to the occurrence of the problem.
      attr_reader :detail
      # @return [String] A short, human-readable summary of the problem.
      attr_reader :title
      # @return [String] A machine-readable code specific to the occurrence of the problem.
      attr_reader :code
      # @return [Array<ErrorItem>] A list of explicit error details.
      attr_reader :errors

      # @param http_error [Hash, Parsing::V2::ErrorResponse]
      def initialize(http_error)
        if http_error.is_a?(Parsing::V2::ErrorResponse)
          http_error = { 'detail' => http_error.detail,
                         'status' => http_error.status,
                         'title' => http_error.title,
                         'code' => http_error.code,
                         'errors' => http_error.errors }
        end
        @status = http_error['status']
        @detail = http_error['detail']
        @title = http_error['title']
        @code = http_error['code']
        @errors = if http_error.key?('errors')
                    http_error['errors'].map do |error|
                      Parsing::V2::ErrorItem.new(error)
                    end
                  else
                    []
                  end
        super("HTTP #{@status} - #{@title} :: #{@code} - #{@detail}")
      end
    end
  end
end
