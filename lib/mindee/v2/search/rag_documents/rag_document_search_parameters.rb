# frozen_string_literal: true

module Mindee
  module V2
    module Search
      module RAGDocuments
        # Search parameters for RAG Documents.
        class RAGDocumentSearchParameters < Mindee::V2::ClientOptions::BaseSearchParameters
          # @return [String] Model identifier to search in.
          attr_reader :model_id

          # @return [String, nil] Case-insensitive substring search on filename.
          attr_reader :filename

          # @param model_id [String] Model identifier to search in.
          # @param filename [String, nil] Case-insensitive substring search on filename.
          # @param page [Integer, nil] 1-based page index.
          # @param per_page [Integer, nil] Number of items per page.
          def initialize(model_id:, filename: nil, page: nil, per_page: nil)
            super(page: page, per_page: per_page)
            raise Error::MindeeInputError, 'Model ID is required.' if model_id.nil? || model_id.empty?

            @model_id = model_id
            @filename = filename
          end

          # @return [String] Slug of searchable resources.
          def self.slug
            'rag-documents'
          end

          # @return [Class<Mindee::V2::Search::RAGDocuments::RAGDocumentSearchResponse>] Response class for the search.
          def self.response_class
            RAGDocumentSearchResponse
          end

          # Return the parameters for the request.
          # @return [Hash{String => String, Array<String>}]
          def request_parameters
            params = super

            params['model_id'] = @model_id
            filename = @filename
            params['filename'] = filename unless filename.nil?

            params
          end
        end
      end
    end
  end
end
