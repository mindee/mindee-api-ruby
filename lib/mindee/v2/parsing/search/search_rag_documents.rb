# frozen_string_literal: true

require_relative 'search_rag_document'

module Mindee
  module V2
    module Parsing
      module Search
        # List of RAG documents.
        class SearchRAGDocuments < Array
          # @param raw_response [Array<Hash>] The parsed JSON payload mapping to the RAG documents.
          def initialize(raw_response)
            super(raw_response.map { |entry| SearchRAGDocument.new(entry) })
          end

          # Default string representation.
          # @return [String]
          def to_s
            return "\n" if empty?

            lines = flat_map do |rag_document|
              [
                "* :ID: #{rag_document.id}",
                "  :Model ID: #{rag_document.model_id}",
                "  :Filename: #{rag_document.filename}",
                "  :Created At: #{rag_document.created_at}",
                "  :Total Matches: #{rag_document.total_matches}",
                "  :Last Match At: #{rag_document.last_match_at}",
                "  :Status: #{rag_document.status}",
              ]
            end

            "#{lines.join("\n")}\n"
          end
        end
      end
    end
  end
end
