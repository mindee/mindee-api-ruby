# frozen_string_literal: true

require_relative 'inference_model'
require_relative 'inference_file'
require_relative 'inference_result'

module Mindee
  module Parsing
    module V2
      # Complete data returned by an inference request:
      #  • model information
      #  • file information
      #  • inference result (fields, options, …)
      class Inference
        # @return [InferenceModel] Information about the model used.
        attr_reader :model
        # @return [InferenceFile] Information about the processed file.
        attr_reader :file
        # @return [InferenceResult] Result contents.
        attr_reader :result
        # @return [String, nil] Identifier of the inference (when provided by API).
        attr_reader :id

        # @param server_response [Hash] Hash representation of the JSON returned by the service.
        def initialize(server_response)
          raise ArgumentError, 'server_response must be a Hash' unless server_response.is_a?(Hash)

          @model  = InferenceModel.new(server_response['model'])
          @file   = InferenceFile.new(server_response['file'])
          @result = InferenceResult.new(server_response['result'])

          @id = server_response['id'] if server_response.key?('id')
        end

        # RST-style string representation (keeps parity with TS implementation).
        #
        # @return [String]
        def to_s
          [
            'Inference',
            '#########',
            'Model',
            '=====',
            ":ID: #{@model.id}",
            '',
            @file.to_s,
            @result.to_s,
            '',
          ].join("\n")
        end
      end
    end
  end
end
