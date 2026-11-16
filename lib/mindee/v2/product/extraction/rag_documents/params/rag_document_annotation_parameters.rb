# frozen_string_literal: true

require 'json'
require 'mindee/v2/client_options/base_annotation_parameters'
require_relative '../rag_annotation'

module Mindee
  module V2
    module Product
      module Extraction
        module RagDocuments
          module Params
            # Annotation parameters for RAG documents.
            class RagDocumentAnnotationParameters < Mindee::V2::ClientOptions::BaseAnnotationParameters
              # New public status to apply to the document (for example, to deactivate it).
              # @return [String, nil]
              attr_reader :status

              # Field-level RAG annotation and guidelines configuration for the document.
              # @return [RagAnnotation, nil]
              attr_reader :annotation

              # Default constructor.
              # @param document_id [String] UUID of the annotated document.
              # @param status [String, nil] New public status to apply to the document.
              # @param annotation [RagAnnotation, String, Hash[String | Symbol, untyped], nil] Field-level
              #   RAG annotation and guidelines configuration.
              def initialize(document_id, status: nil, annotation: nil)
                super(document_id)

                @status = status
                @annotation = parse_annotation(annotation)
              end

              # Load from a hash
              # @param [Hash] params Parameters to provide as a hash.
              # @return [RagDocumentAnnotationParameters]
              def self.from_hash(params: {})
                load_from_hash(params: params)
                new(
                  params[:document_id],
                  status: params[:status],
                  annotation: params[:annotation]
                )
              end

              # Gets the request parameters for the annotation request.
              # @return [Hash[String, untyped]]
              def request_parameters
                parameters = {} # : Hash[String, untyped]
                parameters['status'] = @status if @status
                parameters['annotation'] = @annotation.to_h if @annotation
                parameters
              end

              private

              # @param annotation [RagAnnotation, String, Hash[String | Symbol, untyped], nil]
              # @return [RagAnnotation, nil]
              def parse_annotation(annotation)
                return nil if annotation.nil?
                return annotation if annotation.is_a?(RagAnnotation)
                return RagAnnotation.new(JSON.parse(annotation)) if annotation.is_a?(String)
                return RagAnnotation.new(JSON.parse(annotation.to_json)) if annotation.is_a?(Hash)

                raise TypeError, 'Invalid RAG Annotation format.'
              end
            end
          end
        end
      end
    end
  end
end
