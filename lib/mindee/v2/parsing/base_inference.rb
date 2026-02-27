# frozen_string_literal: true

require_relative '../product/base_product'
require_relative '../../parsing/v2/inference_response'

module Mindee
  module V2
    module Parsing
      # Base class for V2 inference responses.
      class BaseInference < Mindee::V2::Product::BaseProduct
        # @return [InferenceJob] Metadata about the job.
        attr_reader :job
        # @return [Parsing::V2::InferenceModel] Model info for the inference.
        attr_reader :model
        # @return [Parsing::V2::InferenceFile] File info for the inference.
        attr_reader :file
        # @return [String] ID of the inference.
        attr_reader :id

        def initialize(http_response)
          raise ArgumentError, 'Server response must be a Hash' unless http_response.is_a?(Hash)

          super()
          @model = Mindee::Parsing::V2::InferenceModel.new(http_response['model'])
          @file = Mindee::Parsing::V2::InferenceFile.new(http_response['file'])
          @id = http_response['id']
          @job = Mindee::Parsing::V2::InferenceJob.new(http_response['job']) if http_response.key?('job')
        end

        # String representation.
        # @return [String]
        def to_s
          [
            'Inference',
            '#########',
            @job.to_s,
            @model.to_s,
            @file.to_s,
          ].join("\n")
        end
      end
    end
  end
end
