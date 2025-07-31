# frozen_string_literal: true

module Mindee
  module Input
    # Parameters to set when sending a file for inference.
    #
    # Rough equivalent of the Python dataclass:
    #     mindee.input.inference_parameters.InferenceParameters
    class InferenceParameters
      # @return [String] ID of the model (required).
      attr_reader :model_id

      # @return [Boolean, nil] Enable Retrieval-Augmented Generation.
      attr_accessor :rag

      # @return [String, nil] Optional alias for the file.
      attr_accessor :file_alias

      # @return [Array<String>, nil] Optional list of webhooks IDs to propagate the API response to.
      attr_accessor :webhook_ids

      # @return [PollingOptions, nil] Options for polling. Set only if having timeout issues.
      attr_accessor :polling_options

      # @return [Boolean, nil] Whether to close the file after parsing.
      attr_accessor :close_file

      # @param model_id [String]  ID of the model (required).
      # @param rag [Boolean]      Enable RAG (default: false).
      # @param file_alias [String, nil] Optional alias (default: nil).
      # @param webhook_ids [Array<String>, nil] Webhook IDs (default: nil).
      # @param polling_options [PollingOptions, nil] Polling options (default: nil).
      # @param close_file [Boolean] Close the file after parsing (default: true).
      def initialize(model_id:,
                     rag: false,
                     file_alias: nil,
                     webhook_ids: nil,
                     polling_options: nil,
                     close_file: true)
        @model_id = model_id
        @rag = rag
        @file_alias = file_alias
        @webhook_ids = webhook_ids.nil? ? [] : webhook_ids
        @polling_options = polling_options.nil? ? PollingOptions.new : polling_options
        @close_file = close_file.nil? || close_file
      end
    end
  end
end
