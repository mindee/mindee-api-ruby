# frozen_string_literal: true

module Mindee
  module Parsing
    module V2
      # Encapsulates information returned by the API when an error occurs.
      class ErrorResponse
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

        # @param server_response [Hash] Raw JSON parsed into a Hash.
        def initialize(server_response)
          @status = server_response['status']
          @detail = server_response['detail']
          @title = server_response['title']
          @code = server_response['code']
          @errors = if server_response.key?('errors')
                      server_response['errors'].map do |error|
                        ErrorItem.new(error)
                      end
                    else
                      []
                    end
        end

        # String representation.
        # @return [String]
        def to_s
          "HTTP #{@status} - #{@title} :: #{@code} - #{@detail}"
        end

        # Hash representation
        # @return [Hash] Hash representation of the object.
        def as_hash
          {
            status: @status,
            detail: @detail,
          }
        end
      end
    end
  end
end
