# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module V2
    module Product
      module Extraction
        # Result of an extraction utility inference.
        class ExtractionResult
          # @return [Mindee::V2::Parsing::Field::InferenceFields] Fields produced by the model.
          attr_reader :fields
          # @return [Mindee::V2::Parsing::RawText, nil] Optional extra data.
          attr_reader :raw_text
          # @return [Mindee::V2::Parsing::RAGMetadata, nil] Optional RAG metadata.
          attr_reader :rag

          # @param server_response [Hash] Hash version of the JSON returned by the API.
          def initialize(server_response)
            raise ArgumentError, 'server_response must be a Hash' unless server_response.is_a?(Hash)

            @fields = Parsing::Field::InferenceFields.new(server_response['fields'])

            @raw_text = server_response['raw_text'] ? Parsing::RawText.new(server_response['raw_text']) : nil
            return unless server_response.key?('rag') && server_response['rag']

            @rag = Parsing::RAGMetadata.new(server_response['rag'])
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
end
