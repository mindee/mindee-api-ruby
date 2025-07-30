# frozen_string_literal: true

require_relative 'common_response'
require_relative 'inference'

module Mindee
  module Parsing
    module V2
      # HTTP response wrapper that embeds a V2 Inference.
      class InferenceResponse < CommonResponse
        # @return [Inference] Parsed inference payload.
        attr_reader :inference

        # @param server_response [Hash] Hash parsed from the API JSON response.
        def initialize(server_response)
          # CommonResponse takes care of the generic metadata (status, etc.)
          super

          @inference = Inference.new(server_response['inference'])
        end

        # Delegates to CommonResponse's string representation and appends the inference details.
        #
        # @return [String]
        def to_s
          @inference.to_s
        end
      end
    end
  end
end
