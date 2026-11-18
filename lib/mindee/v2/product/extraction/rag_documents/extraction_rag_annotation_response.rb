# frozen_string_literal: true

require 'time'
require 'mindee/v2/parsing/base_rag_annotation_response'
require_relative 'rag_annotation'

module Mindee
  module V2
    module Product
      module Extraction
        module RagDocuments
          # Response for a RAG document.
          class ExtractionRagAnnotationResponse < Mindee::V2::Parsing::BaseRagAnnotationResponse
            # Model identifier linked to the RAG document.
            # @return [String]
            attr_reader :model_id

            # Number of times this document was used in an inference.
            # @return [Integer]
            attr_reader :total_matches

            # Date and time of the latest matching inference, if any.
            # @return [Time, nil]
            attr_reader :last_match_at

            # Annotation metadata associated with the document.
            # @return [RagAnnotation, nil]
            attr_reader :annotation

            # Default constructor.
            # @param server_response [Hash[String | Symbol, untyped]]
            def initialize(server_response)
              super

              @model_id = server_response['model_id']
              @total_matches = server_response['total_matches']
              @last_match_at = server_response['last_match_at'] ? Time.parse(server_response['last_match_at']) : nil
              @annotation = server_response['annotation'] ? RagAnnotation.new(server_response['annotation']) : nil
            end
          end
        end
      end
    end
  end
end
