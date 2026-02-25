# frozen_string_literal: true

require_relative 'common_response'
require_relative 'inference'
require_relative '../../v2/parsing/base_response'

module Mindee
  module Parsing
    module V2
      # HTTP response wrapper that embeds a V2 Inference.
      class InferenceResponse < Mindee::V2::Parsing::BaseResponse
        # @return [Inference] Parsed inference payload.
        attr_reader :inference

        @_slug = 'extraction/results'
        @_params_type = Input::InferenceParameters

        # @param server_response [Hash] Hash parsed from the API JSON response.
        def initialize(server_response)
          super

          @inference = Inference.new(server_response['inference'])
        end

        # String representation.
        # @return [String]
        def to_s
          @inference.to_s
        end
      end
    end
  end
end
