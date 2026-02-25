# frozen_string_literal: true

module Mindee
  module V2
    module Product
      module Classification
        # Classification of document type from the source file.
        class ClassificationClassifier
          # @return [String] The document type, as identified on given classification values.
          attr_reader :document_type

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            @document_type = server_response['document_type']
          end

          # @return [String] String representation.
          def to_s
            "Document Type: #{@document_type}"
          end
        end
      end
    end
  end
end
