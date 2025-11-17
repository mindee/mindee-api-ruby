# frozen_string_literal: true

# Metadata about the RAG operation.
class RagMetadata
  # ID of the matched document, if present.
  attr_accessor :retrieved_document_id

  def initialize(server_response)
    @retrieved_document_id = server_response.fetch('retrieved_document_id', nil)
  end
end
