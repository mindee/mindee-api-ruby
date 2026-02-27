# frozen_string_literal: true

require_relative 'data_schema'
require_relative '../input/base_parameters'

module Mindee
  module Input
    # Parameters to set when sending a file for inference.
    class InferenceParameters < Mindee::Input::BaseParameters
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
      # @param [Hash, nil] polling_options
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
        polling_options: nil,
        close_file: true,
        data_schema: nil
      )
        super(
          model_id,
          file_alias: file_alias,
          webhook_ids: webhook_ids,
          polling_options: polling_options,
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

      # Appends inference-specific form data to the provided array.
      # @param [Array] form_data Array of form fields
      # @return [Array]
      def append_form_data(form_data)
        new_form_data = super

        new_form_data.push(['rag', @rag.to_s]) unless @rag.nil?
        new_form_data.push(['raw_text', @raw_text.to_s]) unless @raw_text.nil?
        new_form_data.push(['polygon', @polygon.to_s]) unless @polygon.nil?
        new_form_data.push(['confidence', @confidence.to_s]) unless @confidence.nil?
        new_form_data.push(['text_context', @text_context]) if @text_context
        new_form_data.push(['data_schema', @data_schema.to_s]) if @data_schema

        new_form_data
      end

      # Loads a prediction from a Hash.
      # @param [Hash] params Parameters to provide as a hash.
      # @return [InferenceParameters]
      def self.from_hash(params: {})
        rag = params.fetch(:rag, nil)
        raw_text = params.fetch(:raw_text, nil)
        polygon = params.fetch(:polygon, nil)
        confidence = params.fetch(:confidence, nil)
        base_params = load_from_hash(params: params)
        new_params = base_params.merge(rag: rag, raw_text: raw_text, polygon: polygon, confidence: confidence)
        model_id = new_params.fetch(:model_id)

        InferenceParameters.new(
          model_id, rag: rag,
                    raw_text: raw_text,
                    polygon: polygon,
                    confidence: confidence,
                    file_alias: params.fetch(:file_alias, nil),
                    webhook_ids: params.fetch(:webhook_ids, nil),
                    close_file: params.fetch(:close_file, true)
        )
      end
    end
  end
end
