# frozen_string_literal: true

require_relative '../product/base_product'
require_relative '../parsing'

module Mindee
  module V2
    module Parsing
      # Base class for V2 inference responses.
      class BaseInference < Mindee::V2::Product::BaseProduct
        # @return [InferenceJob] Metadata about the job.
        attr_reader :job
        # @return [V2::Parsing::InferenceModel] Model info for the inference.
        attr_reader :model
        # @return [V2::Parsing::InferenceFile] File info for the inference.
        attr_reader :file
        # @return [String] ID of the inference.
        attr_reader :id

        def initialize(http_response)
          raise ArgumentError, 'Server response must be a Hash' unless http_response.is_a?(Hash)

          super()
          @model = Mindee::V2::Parsing::InferenceModel.new(http_response['model'])
          @file = Mindee::V2::Parsing::InferenceFile.new(http_response['file'])
          @id = http_response['id']
          @job = Mindee::V2::Parsing::InferenceJob.new(http_response['job']) if http_response.key?('job')
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
