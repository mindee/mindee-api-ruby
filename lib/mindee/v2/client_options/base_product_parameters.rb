# frozen_string_literal: true

module Mindee
  module V2
    module ClientOptions
      # Base class for parameters accepted by all V2 endpoints.
      class BaseProductParameters
        # @return [String] Model ID to use for the inference. Required.
        attr_reader :model_id

        # @return [String, nil] Optional: a free-form string to tag the request with your own identifier.
        # For example, an internal document ID, reference number, or database key.
        # If set, it will be included in the job and result responses.
        attr_reader :file_alias

        # @return [Array<String>, nil] Webhook IDs to call after all processing is finished.
        # If empty, no webhooks will be used.
        attr_reader :webhook_ids

        # @return [Boolean, nil] Whether to close the file after parsing.
        attr_reader :close_file

        # @param [String] model_id ID of the model
        # @param [String, nil] file_alias File alias, if applicable.
        # @param [Array<String>, nil] webhook_ids List of webhook IDs to propagate the API response to.
        # @param [Boolean, nil] close_file Whether to close the file after parsing.
        def initialize(
          model_id,
          file_alias: nil,
          webhook_ids: nil,
          close_file: true
        )
          raise Error::MindeeInputError, 'Model ID is required.' if model_id.nil? || model_id.empty?

          @model_id = model_id
          @file_alias = file_alias
          @webhook_ids = webhook_ids || []
          @close_file = close_file.nil? || close_file
        end

        # @return [String] Slug for the endpoint.
        def self.slug
          if self == BaseProductParameters
            raise NotImplementedError, 'Cannot access `slug` directly on the BaseProductParameters class.'
          end

          ''
        end

        # @return [String] Slug for the endpoint.
        def slug
          self.class.slug
        end

        # Load from a hash
        # @param [Hash] params Parameters to provide as a hash.
        # @return [BaseProductParameters]
        def self.from_hash(params: {})
          load_from_hash(params: params)
          new(
            params[:model_id],
            file_alias: params[:file_alias],
            webhook_ids: params[:webhook_ids],
            close_file: params[:close_file]
          )
        end

        # Loads a prediction from a Hash.
        # @param [Hash] params Parameters to provide as a hash.
        # @return [Hash]
        def self.load_from_hash(params: {})
          params.transform_keys!(&:to_sym)

          if params.empty? || params[:model_id].nil? || params[:model_id].empty?
            raise Error::MindeeInputError, 'Model ID is required.'
          end

          params
        end

        # Gets the base request parameters for the endpoint.
        # @return [Hash{Symbol => String, Array<String>}]
        def request_parameters
          form_data = { model_id: @model_id }
          file_alias = @file_alias
          form_data[:alias] = file_alias if file_alias
          webhook_ids = @webhook_ids
          form_data[:webhook_ids] = webhook_ids.join(',') if webhook_ids && !webhook_ids.empty?
          form_data
        end
      end
    end
  end
end
