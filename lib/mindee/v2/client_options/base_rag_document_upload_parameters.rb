# frozen_string_literal: true

module Mindee
  module V2
    module ClientOptions
      # Base parameters for document upload operations.
      class BaseRagDocumentUploadParameters
        # UUID of the model that the uploaded RAG document is linked to.
        # @return [String]
        attr_reader :model_id

        # Default constructor.
        # @param model_id [String] UUID of the model that the uploaded RAG document is linked to.
        def initialize(model_id)
          trimmed_id = model_id&.strip
          raise Error::MindeeError, 'Model ID must be provided' if trimmed_id.nil? || trimmed_id.empty?

          @model_id = trimmed_id
        end

        # Load from a hash
        # @param [Hash] params Parameters to provide as a hash.
        # @return [BaseRagDocumentUploadParameters]
        def self.from_hash(params: {})
          load_from_hash(params: params)
          new(params[:model_id])
        end

        # Loads parameters from a Hash.
        # @param [Hash] params Parameters to provide as a hash.
        # @return [Hash]
        def self.load_from_hash(params: {})
          params.transform_keys!(&:to_sym)

          if params.empty? || params[:model_id].nil? || params[:model_id].to_s.strip.empty?
            raise Error::MindeeInputError, 'Model ID is required.'
          end

          params
        end

        # Gets the request parameters for the upload request.
        # @return [Hash[String, String]]
        def request_parameters
          { 'model_id' => @model_id }
        end
      end
    end
  end
end
