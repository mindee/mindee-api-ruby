# frozen_string_literal: true

module Mindee
  module Input
    # Parameters to set when sending a file for inference.
    class InferenceParameters
      # @return [String] ID of the model (required).
      attr_reader :model_id

      # @return [Boolean, nil] Enable Retrieval-Augmented Generation.
      attr_reader :rag

      # @return [String, nil] Optional alias for the file.
      attr_reader :file_alias

      # @return [Array<String>, nil] Optional list of webhooks IDs to propagate the API response to.
      attr_reader :webhook_ids

      # @return [PollingOptions] Options for polling. Set only if having timeout issues.
      attr_reader :polling_options

      # @return [Boolean, nil] Whether to close the file after parsing.
      attr_reader :close_file

      # @param params [Hash]
      def initialize(params: {})
        params = params.transform_keys(&:to_sym)

        if params.empty? || params[:model_id].nil? || params[:model_id].empty?
          raise Errors::MindeeInputError, 'Model ID is required.'
        end

        @model_id = params.fetch(:model_id)
        @rag = params.fetch(:rag, false)
        @file_alias = params.fetch(:file_alias, nil)
        @webhook_ids = params.fetch(:webhook_ids, [])
        polling_options = params.fetch(:page_options, PollingOptions.new)
        if polling_options.is_a?(Hash)
          polling_options = polling_options.transform_keys(&:to_sym)
          @polling_options = PollingOptions.new(
            initial_delay_sec: polling_options.fetch(:initial_delay_sec, 2.0),
            delay_sec: polling_options.fetch(:delay_sec, 1.5),
            max_retries: polling_options.fetch(:max_retries, 80)
          )
        end
        @polling_options = polling_options
        @close_file = params.fetch(:close_file, true)
      end
    end
  end
end
