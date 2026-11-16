# frozen_string_literal: true

require_relative '../parsing/base_response'
require_relative '../parsing/base_inference_response'
require_relative '../parsing/base_rag_annotation_response'
require_relative '../client_options/base_product_parameters'
require_relative '../client_options/base_annotation_parameters'
require_relative '../client_options/base_rag_document_upload_parameters'

module Mindee
  module V2
    module Product
      # Base class for all V2 products.
      class BaseProduct
        # @return [String] API slug for this product.
        @slug = ''
        # @return [Class<BaseParameters>] Parameter class accepted by this product.
        @parameters_class = Mindee::V2::ClientOptions::BaseProductParameters
        # @return [Class<BaseInferenceResponse>] Response class returned by this product.
        @response_class = Mindee::V2::Parsing::BaseInferenceResponse
        # @return [Class<BaseRagAnnotationResponse>] Annotation Response class returned by this product.
        @annotation_response_class = Mindee::V2::Parsing::BaseRagAnnotationResponse
        # @return [Class<BaseAnnotationParameters>] Annotation Parameters class for this product.
        @annotation_parameters_class = Mindee::V2::ClientOptions::BaseAnnotationParameters
        # @return [Class<BaseRagDocumentUploadParameters>] Document Upload class for this product.
        @rag_document_upload_class = ClientOptions::BaseRagDocumentUploadParameters

        def initialize
          raise StandardError, 'Cannot instantiate abstract class.' if instance_of?(BaseProduct)
        end

        class << self
          attr_reader :parameters_class,
                      :slug,
                      :response_class,
                      :annotation_response_class,
                      :annotation_parameters_class,
                      :rag_document_upload_class
        end
      end
    end
  end
end
