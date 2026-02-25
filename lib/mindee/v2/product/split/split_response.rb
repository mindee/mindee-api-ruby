# frozen_string_literal: true

require_relative '../../parsing/base_response'
require_relative 'params/split_parameters'
require_relative 'split_inference'

module Mindee
  module V2
    module Product
      module Split
        # HTTP response wrapper that embeds a V2 Inference.
        class SplitResponse < Mindee::V2::Parsing::BaseResponse
          # @return [SplitInference] Parsed inference payload.
          attr_reader :inference

          @_slug = 'split'
          @_params_type = Split::Params::SplitParameters

          # @param server_response [Hash] Hash parsed from the API JSON response.
          def initialize(server_response)
            super

            @inference = SplitInference.new(server_response['inference'])
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
end
