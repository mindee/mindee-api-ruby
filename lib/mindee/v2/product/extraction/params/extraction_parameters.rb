# frozen_string_literal: true

require_relative '../../../client_options/base_product_parameters'
require_relative 'data_schema'

module Mindee
  module V2
    module Product
      module Extraction
        module Params
          # Parameters accepted by the extraction v2 endpoint.
          class ExtractionParameters < Mindee::V2::ClientOptions::BaseProductParameters
            # @return [Boolean, nil] Enhance extraction accuracy with Retrieval-Augmented Generation.
            attr_reader :rag

            # @return [Boolean, nil] Extract the full text content from the document as strings,
            #   and fill the raw_text` attribute.
            attr_reader :raw_text

            # @return [Boolean, nil] Calculate bounding box polygons for all fields,
            #   and fill their `locations` attribute.
            attr_reader :polygon

            # @return [Boolean, nil] Boost the precision and accuracy of all extractions.
            #   Calculate confidence scores for all fields, and fill their confidence attribute.
            attr_reader :confidence

            # @return [String, nil] Additional text context used by the model during inference.
            #   Not recommended, for specific use only.
            attr_reader :text_context

            # @return [DataSchemaField]
            attr_reader :data_schema

            # @return [String] Slug for the endpoint.
            def self.slug
              'extraction'
            end

            # rubocop:disable Metrics/ParameterLists
            # @param [String] model_id ID of the model
            # @param [Boolean, nil] rag Whether to enable RAG.
            # @param [Boolean, nil] raw_text Whether to enable rax text.
            # @param [Boolean, nil] polygon Whether to enable polygons.
            # @param [Boolean, nil] confidence Whether to enable confidence scores.
            # @param [String, nil] file_alias File alias, if applicable.
            # @param [Array<String>, nil] webhook_ids
            # @param [String, nil] text_context
            # @param [Boolean, nil] close_file
            # @param [DataSchemaField, String, Hash nil] data_schema
            def initialize(
              model_id,
              rag: nil,
              raw_text: nil,
              polygon: nil,
              confidence: nil,
              file_alias: nil,
              webhook_ids: nil,
              text_context: nil,
              close_file: true,
              data_schema: nil
            )
              super(
                model_id,
                file_alias: file_alias,
                webhook_ids: webhook_ids,
                close_file: close_file
              )

              @rag = rag
              @raw_text = raw_text
              @polygon = polygon
              @confidence = confidence
              @text_context = text_context
              @data_schema = DataSchema.new(data_schema) unless data_schema.nil?
              # rubocop:enable Metrics/ParameterLists
            end

            # Gets inference-specific request parameters.
            # @return [Hash{String => String, Array<String>}]
            def request_parameters
              form_data = super

              form_data['rag'] = @rag.to_s unless @rag.nil?
              form_data['raw_text'] = @raw_text.to_s unless @raw_text.nil?
              form_data['polygon'] = @polygon.to_s unless @polygon.nil?
              form_data['confidence'] = @confidence.to_s unless @confidence.nil?
              text_context = @text_context
              form_data['text_context'] = text_context if text_context
              form_data['data_schema'] = @data_schema.to_s if @data_schema

              form_data
            end

            # Loads a prediction from a Hash.
            # @param [Hash] params Parameters to provide as a hash.
            # @return [ExtractionParameters]
            def self.from_hash(params: {})
              rag = params.fetch(:rag, nil)
              raw_text = params.fetch(:raw_text, nil)
              polygon = params.fetch(:polygon, nil)
              confidence = params.fetch(:confidence, nil)
              base_params = load_from_hash(params: params)
              new_params = base_params.merge(rag: rag, raw_text: raw_text, polygon: polygon, confidence: confidence)
              model_id = new_params.fetch(:model_id)

              ExtractionParameters.new(
                model_id,
                rag: rag,
                raw_text: raw_text,
                polygon: polygon,
                confidence: confidence,
                file_alias: params.fetch(:file_alias, nil),
                webhook_ids: params.fetch(:webhook_ids, nil),
                text_context: base_params.fetch(:text_context, nil),
                data_schema: base_params.fetch(:data_schema, nil),
                close_file: params.fetch(:close_file, true)
              )
            end
          end
        end
      end
    end
  end
end
