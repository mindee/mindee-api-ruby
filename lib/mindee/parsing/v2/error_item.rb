# frozen_string_literal: true

module Mindee
  module Parsing
    module V2
      # Individual error item.
      class ErrorItem
        # @return [String, nil] A JSON Pointer to the location of the body property.
        attr_reader :pointer
        # @return [String, nil] Explicit information on the issue.
        attr_reader :detail

        # @param server_response [Hash] Raw JSON parsed into a Hash.
        def initialize(server_response)
          @pointer = server_response['pointer']
          @detail = server_response['detail']
        end
      end
    end
  end
end
