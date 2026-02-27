# frozen_string_literal: true

require_relative 'crop_result'

module Mindee
  module V2
    module Product
      module Crop
        # The inference result for a crop utility request.
        class CropInference < Mindee::V2::Parsing::BaseInference
          # @return [CropResult] Parsed inference payload.
          attr_reader :result

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            super

            @result = CropResult.new(server_response['result'])
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
