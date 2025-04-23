# frozen_string_literal: true

module Mindee
  module Parsing
    module Common
      module Extras
        # Retrieval-Augmented Generation extra.
        class RAGExtra
          # ID of the matching document
          # @return [String, nil]
          attr_reader :matching_document_id

          def initialize(raw_prediction)
            @matching_document_id = raw_prediction['matching_document_id'] if raw_prediction['matching_document_id']
          end

          def to_s
            @matching_document_id || ''
          end
        end
      end
    end
  end
end
