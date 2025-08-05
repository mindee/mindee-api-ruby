# frozen_string_literal: true

module Mindee
  module Parsing
    module V2
      # Encapsulates information returned by the API when an error occurs.
      class ErrorResponse
        # @return [Integer] HTTP status code.
        attr_reader :status
        # @return [String] Error detail.
        attr_reader :detail

        # @param server_response [Hash] Raw JSON parsed into a Hash.
        def initialize(server_response)
          @status = server_response['status']
          @detail = server_response['detail']
        end

        # String representation, useful when embedding in larger objects.
        # @return [String]
        def to_s
          "Error\n=====\n:Status: #{@status}\n:Detail: #{@detail}"
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
