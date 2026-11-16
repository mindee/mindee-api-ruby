# frozen_string_literal: true

require 'time'
require_relative 'base_inference_response'

module Mindee
  module V2
    module Parsing
      # Base class for all RAG document responses from the V2 API.
      class BaseRagAnnotationResponse < BaseInferenceResponse
        # Unique identifier of the RAG document.
        # @return [String]
        attr_reader :id

        # Original filename of the uploaded document.
        # @return [String]
        attr_reader :filename

        # Date and time of the document creation.
        # @return [Time]
        attr_reader :created_at

        # Current status of the RAG document.
        # @return [String]
        attr_reader :status

        # Default constructor.
        # @param server_response [Hash[String | Symbol, untyped]]
        def initialize(server_response)
          super

          @id = server_response['id']
          @filename = server_response['filename']
          @created_at = Time.parse(server_response['created_at'])
          @status = server_response['status']
        end
      end
    end
  end
end
