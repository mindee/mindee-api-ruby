# frozen_string_literal: true

require_relative 'split_result'

module Mindee
  module V2
    module Product
      module Split
        # Split inference result.
        class SplitInference < Mindee::V2::Parsing::BaseInference
          # @return [SplitResult] Result of a split inference.
          attr_reader :result

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            super

            @result = SplitResult.new(server_response['result'])
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
