# frozen_string_literal: true

module Mindee
  module V2
    module Search
      module RAGDocuments
        # RAG Documents search response.
        class RAGDocumentSearchResponse < Mindee::V2::Parsing::Search::BaseSearchResponse
          # @return [Mindee::V2::Parsing::Search::SearchRAGDocuments] Paginated list of matching RAG documents.
          attr_reader :rag_documents

          # @param raw_response [Hash] The parsed JSON payload from the API.
          def initialize(raw_response)
            super

            @rag_documents = Mindee::V2::Parsing::Search::SearchRAGDocuments.new(raw_response['rag_documents'])
          end

          # List of strings representing the search response.
          # @return [Array<String>]
          def body_lines
            ['RAG Documents', '#############', @rag_documents.to_s]
          end
        end
      end
    end
  end
end
