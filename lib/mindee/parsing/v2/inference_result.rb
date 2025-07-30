# frozen_string_literal: true

require_relative 'field/inference_fields'
require_relative 'inference_result_options'

module Mindee
  module Parsing
    module V2
      # Wrapper for the result of a V2 inference request.
      class InferenceResult
        # @return [Mindee::Parsing::V2::Field::InferenceFields] Fields produced by the model.
        attr_reader :fields
        # @return [Mindee::Parsing::V2::InferenceResultOptions, nil] Optional extra data.
        attr_reader :options

        # @param server_response [Hash] Hash version of the JSON returned by the API.
        def initialize(server_response)
          raise ArgumentError, 'server_response must be a Hash' unless server_response.is_a?(Hash)

          @fields = Field::InferenceFields.new(server_response['fields'])

          return unless server_response.key?('options') && server_response['options']

          @options = InferenceResultOptions.new(server_response['options'])
        end

        # RST-style string representation.
        #
        # @return [String]
        def to_s
          parts = [
            'Fields',
            '======',
            @fields.to_s,
          ]

          if @options
            parts += [
              'Options',
              '=======',
              @options.to_s,
            ]
          end

          parts.join("\n")
        end
      end
    end
  end
end
