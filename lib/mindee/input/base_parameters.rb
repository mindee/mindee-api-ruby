# frozen_string_literal: true

module Mindee
  module Input
    # Base class for parameters accepted by all V2 endpoints.
    class BaseParameters
      # @return [String] ID of the model (required).
      attr_reader :model_id

      # @return [String, nil] Optional alias for the file.
      attr_reader :file_alias

      # @return [Array<String>, nil] Optional list of Webhooks IDs to propagate the API response to.
      attr_reader :webhook_ids

      # @return [PollingOptions] Options for polling. Set only if having timeout issues.
      attr_reader :polling_options

      # @return [Boolean, nil] Whether to close the file after parsing.
      attr_reader :close_file

      # @return [String] Slug for the endpoint.

      # @param [String] model_id ID of the model
      # @param [String, nil] file_alias File alias, if applicable.
      # @param [Array<String>, nil] webhook_ids
      # @param [Hash, nil] polling_options
      # @param [Boolean, nil] close_file
      def initialize(
        model_id,
        file_alias: nil,
        webhook_ids: nil,
        polling_options: nil,
        close_file: true
      )
        raise Errors::MindeeInputError, 'Model ID is required.' if model_id.empty? || model_id.nil?

        @model_id = model_id
        @file_alias = file_alias
        @webhook_ids = webhook_ids || []
        @polling_options = get_clean_polling_options(polling_options)
        @close_file = close_file.nil? || close_file
      end

      # Loads a prediction from a Hash.
      # @param [Hash] params Parameters to provide as a hash.
      # @return [Hash]
      def self.from_hash(params: {})
        params.transform_keys!(&:to_sym)

        if params.empty? || params[:model_id].nil? || params[:model_id].empty?
          raise Errors::MindeeInputError, 'Model ID is required.'
        end

        polling_options_input = params.fetch(:page_options, PollingOptions.new)
        if polling_options_input.is_a?(Hash)
          polling_options_input = polling_options_input.transform_keys(&:to_sym)
          PollingOptions.new(
            initial_delay_sec: polling_options_input.fetch(:initial_delay_sec, 2.0),
            delay_sec: polling_options_input.fetch(:delay_sec, 1.5),
            max_retries: polling_options_input.fetch(:max_retries, 80)
          )
        end
        params
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
