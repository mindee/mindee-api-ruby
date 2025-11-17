# frozen_string_literal: true

module Mindee
  module Parsing
    module V2
      # Metadata about the RAG operation.
      class RAGMetadata
        # ID of the matched document, if present.
        attr_accessor :retrieved_document_id

        def initialize(server_response)
          @retrieved_document_id = server_response.fetch('retrieved_document_id', nil)
        end
      end
    end
  end
end
