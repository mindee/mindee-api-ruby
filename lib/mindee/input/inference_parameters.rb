# frozen_string_literal: true

module Mindee
  module Input
    # Parameters to set when sending a file for inference.
    class InferenceParameters
      # @return [String] ID of the model (required).
      attr_reader :model_id

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

      # @return [String, nil] Optional alias for the file.
      attr_reader :file_alias

      # @return [String, nil] Additional text context used by the model during inference.
      #   Not recommended, for specific use only.
      attr_reader :text_context

      # @return [Array<String>, nil] Optional list of Webhooks IDs to propagate the API response to.
      attr_reader :webhook_ids

      # @return [PollingOptions] Options for polling. Set only if having timeout issues.
      attr_reader :polling_options

      # @return [Boolean, nil] Whether to close the file after parsing.
      attr_reader :close_file

      # rubocop:disable Metrics/ParameterLists
      # @param [String] model_id ID of the model
      # @param [nil] rag Whether to enable RAG.
      # @param [nil] raw_text Whether to enable rax text.
      # @param [nil] polygon Whether to enable polygons.
      # @param [nil] confidence Whether to enable confidence scores.
      # @param [nil] file_alias File alias, if applicable.
      # @param [nil] webhook_ids
      # @param [nil] polling_options
      # @param [TrueClass] close_file
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
        close_file: true
      )
        raise Errors::MindeeInputError, 'Model ID is required.' if model_id.empty? || model_id.nil?

        @model_id = model_id
        @rag = rag
        @raw_text = raw_text
        @polygon = polygon
        @confidence = confidence
        @file_alias = file_alias
        @webhook_ids = webhook_ids || []
        @text_context = text_context
        @polling_options = get_clean_polling_options(polling_options)
        @close_file = close_file.nil? || close_file
        # rubocop:enable Metrics/ParameterLists
      end

      # Validates the parameters for async auto-polling
      def validate_async_params
        min_delay_sec = 1
        min_initial_delay_sec = 1
        min_retries = 2

        if @polling_options.delay_sec < min_delay_sec
          raise ArgumentError,
                "Cannot set auto-poll delay to less than #{min_delay_sec} second(s)"
        end
        if @polling_options.initial_delay_sec < min_initial_delay_sec
          raise ArgumentError,
                "Cannot set initial parsing delay to less than #{min_initial_delay_sec} second(s)"
        end
        return unless @polling_options.max_retries < min_retries

        raise ArgumentError,
              "Cannot set auto-poll retries to less than #{min_retries}"
      end

      # Loads a prediction from a Hash.
      # @param [Hash] params Parameters to provide as a hash.
      # @return [InferenceParameters]
      def self.from_hash(params: {})
        params.transform_keys!(&:to_sym)

        if params.empty? || params[:model_id].nil? || params[:model_id].empty?
          raise Errors::MindeeInputError, 'Model ID is required.'
        end

        model_id = params.fetch(:model_id)
        rag = params.fetch(:rag, nil)
        raw_text = params.fetch(:raw_text, nil)
        polygon = params.fetch(:polygon, nil)
        confidence = params.fetch(:confidence, nil)
        file_alias = params.fetch(:file_alias, nil)
        webhook_ids = params.fetch(:webhook_ids, [])
        polling_options_input = params.fetch(:page_options, PollingOptions.new)
        if polling_options_input.is_a?(Hash)
          polling_options_input = polling_options_input.transform_keys(&:to_sym)
          PollingOptions.new(
            initial_delay_sec: polling_options_input.fetch(:initial_delay_sec, 2.0),
            delay_sec: polling_options_input.fetch(:delay_sec, 1.5),
            max_retries: polling_options_input.fetch(:max_retries, 80)
          )
        end
        close_file = params.fetch(:close_file, true)
        InferenceParameters.new(model_id, rag: rag, raw_text: raw_text, polygon: polygon, confidence: confidence,
                                          file_alias: file_alias, webhook_ids: webhook_ids, close_file: close_file)
      end

      private

      # Cleans a proper polling options object potentially from a hash.
      # @param [Hash, PollingOptions, nil] polling_options Polling options.
      # @return [PollingOptions] Valid polling options object.
      def get_clean_polling_options(polling_options)
        return PollingOptions.new if polling_options.is_a?(PollingOptions)

        if polling_options.is_a?(Hash)
          polling_options = polling_options.transform_keys(&:to_sym)
          output_polling_options = PollingOptions.new(
            initial_delay_sec: polling_options.fetch(:initial_delay_sec, 2.0),
            delay_sec: polling_options.fetch(:delay_sec, 1.5),
            max_retries: polling_options.fetch(:max_retries, 80)
          )
        else
          output_polling_options = if polling_options.is_a?(PollingOptions)
                                     polling_options || PollingOptions.new
                                   else
                                     PollingOptions.new
                                   end
        end
        output_polling_options
      end
    end
  end
end
