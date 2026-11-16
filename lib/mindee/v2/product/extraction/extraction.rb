# frozen_string_literal: true

require_relative 'extraction_response'
require_relative 'params/extraction_parameters'
require_relative 'rag_documents/extraction_rag_annotation_response'
require_relative 'rag_documents/params/rag_document_annotation_parameters'
require_relative 'rag_documents/params/rag_document_upload_parameters'

module Mindee
  module V2
    module Product
      # Extraction module.
      module Extraction
        # Extraction product.
        # Note: currently a placeholder for the `Inference` class.
        class Extraction < Product::BaseProduct
          @slug = 'extraction'
          @parameters_class = Product::Extraction::Params::ExtractionParameters
          @response_class = Product::Extraction::ExtractionResponse
          @annotation_response_class = Product::Extraction::RagDocuments::ExtractionRagAnnotationResponse
        end
      end
    end
  end
end
