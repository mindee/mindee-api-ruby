# frozen_string_literal: true

require_relative 'classification_classifier'

module Mindee
  module V2
    module Product
      module Classification
        # Result of the document classifier inference.
        class ClassificationResult
          # @return [ClassificationClassifier] The document type, as identified on given classification values.
          attr_reader :classification

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            @classification = ClassificationClassifier.new(server_response['classification'])
          end

          # @return [String] String representation.
          def to_s
            "Classification\n==============\n#{@classification}"
          end
        end
      end
    end
  end
end
