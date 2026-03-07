# frozen_string_literal: true

require_relative 'classification_result'
require_relative '../../parsing/base_inference'

module Mindee
  module V2
    module Product
      module Classification
        # The inference result for a classification utility request.
        class ClassificationInference < Mindee::V2::Parsing::BaseInference
          # @return [ClassificationResult] Parsed inference payload.
          attr_reader :result

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            super

            @result = ClassificationResult.new(server_response['result'])
          end

          # String representation.
          # @return [String]
          def to_s
            [
              super,
              @result.to_s,
              '',
            ].join("\n")
          end
        end
      end
    end
  end
end
