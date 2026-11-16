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

        # Gets the request parameters for the upload request.
        # @return [Hash[String, String]]
        def request_parameters
          { 'model_id' => @model_id }
        end
      end
    end
  end
end
