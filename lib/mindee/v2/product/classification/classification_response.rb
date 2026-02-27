# frozen_string_literal: true

require_relative '../../parsing/base_response'
require_relative 'classification_inference'
require_relative 'params/classification_parameters'

module Mindee
  module V2
    module Product
      module Classification
        # HTTP response wrapper that embeds a V2 Inference.
        class ClassificationResponse < Mindee::V2::Parsing::BaseResponse
          # @return [ClassificationInference] Parsed inference payload.
          attr_reader :inference

          # @param server_response [Hash] Hash parsed from the API JSON response.
          def initialize(server_response)
            super

            @inference = ClassificationInference.new(server_response['inference'])
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
