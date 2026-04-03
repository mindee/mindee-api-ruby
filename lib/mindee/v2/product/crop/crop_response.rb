# frozen_string_literal: true

require_relative '../../parsing/base_response'
require_relative 'params/crop_parameters'
require_relative 'crop_inference'

module Mindee
  module V2
    module Product
      module Crop
        # HTTP response wrapper that embeds a V2 Inference.
        class CropResponse < Mindee::V2::Parsing::BaseResponse
          # @return [CropInference] Parsed inference payload.
          attr_reader :inference

          # @param server_response [Hash] Hash parsed from the API JSON response.
          def initialize(server_response)
            super

            @inference = CropInference.new(server_response['inference'])
          end

          # String representation.
          # @return [String]
          def to_s
            @inference.to_s
          end

          # Apply the crop inference to a file and return a list of extracted images.
          #
          # @param input_source [Mindee::Input::Source::LocalInputSource] Local file to extract from
          # @return [FileOperation::CropFiles] List of extracted PDFs
          def extract_from_file(input_source)
            FileOperation::Crop.extract_crops(input_source, @inference.result.crops)
          end
        end
      end
    end
  end
end
