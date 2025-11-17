# frozen_string_literal: true

require_relative 'field/inference_fields'
require_relative 'rag_metadata'
require_relative 'raw_text'

module Mindee
  module Parsing
    module V2
      # Wrapper for the result of a V2 inference request.
      class InferenceResult
        # @return [Mindee::Parsing::V2::Field::InferenceFields] Fields produced by the model.
        attr_reader :fields
        # @return [Mindee::Parsing::V2::RawText, nil] Optional extra data.
        attr_reader :raw_text
        # @return [Mindee::Parsing::V2::RagMetadata, nil] Optional RAG metadata.
        attr_reader :rag

        # @param server_response [Hash] Hash version of the JSON returned by the API.
        def initialize(server_response)
          raise ArgumentError, 'server_response must be a Hash' unless server_response.is_a?(Hash)

          @fields = Field::InferenceFields.new(server_response['fields'])

          @raw_text = server_response['raw_text'] ? RawText.new(server_response['raw_text']) : nil
          @rag = server_response.key?('rag') && server_response['rag'] ? RagMetadata.new(server_response['rag']) : nil
        end

        # String representation.
        # @return [String]
        def to_s
          parts = [
            'Fields',
            '======',
            @fields.to_s,
          ]
          parts.join("\n")
        end
      end
    end
  end
end
