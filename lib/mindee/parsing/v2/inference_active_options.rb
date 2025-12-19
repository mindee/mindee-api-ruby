# frozen_string_literal: true

module Mindee
  module Parsing
    module V2
      # Data schema options activated during the inference.
      class DataSchemaActiveOption
        # @return [Boolean]
        attr_reader :replace

        # @param server_response [Hash]
        def initialize(server_response)
          @replace = server_response[:replace] || server_response['replace']
        end

        # String representation.
        # @return [String]
        def to_s
          "Data Schema\n-----------\n:Replace: #{@replace ? 'True' : 'False'}"
        end
      end

      # Options which were activated during the inference.
      class InferenceActiveOptions
        # @return [Boolean] Whether the Raw Text feature was activated.
        attr_reader :raw_text
        # @return [Boolean] Whether the polygon feature was activated.
        attr_reader :polygon
        # @return [Boolean] Whether the confidence feature was activated.
        attr_reader :confidence
        # @return [Boolean] Whether the Retrieval-Augmented Generation feature was activated.
        attr_reader :rag
        # @return [Boolean] Whether the text context feature was activated.
        attr_reader :text_context
        # @return [DataSchemaActiveOption]
        attr_reader :data_schema

        # @param server_response [Hash] Raw JSON parsed into a Hash.
        def initialize(server_response)
          @raw_text = server_response['raw_text']
          @polygon = server_response['polygon']
          @confidence = server_response['confidence']
          @rag = server_response['rag']
          @text_context = server_response['text_context']
          @data_schema = DataSchemaActiveOption.new(server_response['data_schema'])
        end

        # String representation.
        # @return [String]
        def to_s
          parts = [
            'Active Options',
            '==============',
            ":Raw Text: #{@raw_text ? 'True' : 'False'}",
            ":Polygon: #{@polygon ? 'True' : 'False'}",
            ":Confidence: #{@confidence ? 'True' : 'False'}",
            ":RAG: #{@rag ? 'True' : 'False'}",
            ":Text Context: #{@text_context ? 'True' : 'False'}\n",
            @data_schema.to_s,
            '',
          ]
          parts.join("\n")
        end
      end
    end
  end
end
