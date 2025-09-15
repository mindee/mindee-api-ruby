# frozen_string_literal: true

require_relative 'inference_model'
require_relative 'inference_file'
require_relative 'inference_result'
require_relative 'inference_active_options'

module Mindee
  module Parsing
    module V2
      # Complete data returned by an inference request.
      class Inference
        # @return [String] Identifier of the inference (when provided by API).
        attr_reader :id
        # @return [InferenceModel] Information about the model used.
        attr_reader :model
        # @return [InferenceFile] Information about the processed file.
        attr_reader :file
        # @return [InferenceActiveOptions] Options which were activated during the inference.
        attr_reader :active_options
        # @return [InferenceResult] Result contents.
        attr_reader :result

        # @param server_response [Hash] Hash representation of the JSON returned by the service.
        def initialize(server_response)
          raise ArgumentError, 'server_response must be a Hash' unless server_response.is_a?(Hash)

          @model  = InferenceModel.new(server_response['model'])
          @file   = InferenceFile.new(server_response['file'])
          @active_options = InferenceActiveOptions.new(server_response['active_options'])
          @result = InferenceResult.new(server_response['result'])

          @id = server_response['id']
        end

        # String representation.
        # @return [String]
        def to_s
          [
            'Inference',
            '#########',
            @model.to_s,
            @file.to_s,
            @active_options.to_s,
            @result.to_s,
            '',
          ].join("\n")
        end
      end
    end
  end
end
