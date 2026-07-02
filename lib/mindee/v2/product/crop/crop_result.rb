# frozen_string_literal: true

require_relative 'crop_item'

module Mindee
  module V2
    module Product
      module Crop
        # Result of a crop utility inference.
        class CropResult
          # @return [Array<Cropitem>] List of results of cropped document regions.
          attr_reader :crops

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            @crops = if server_response.key?('crops')
                       server_response['crops'].map do |crop|
                         CropItem.new(crop)
                       end
                     end
          end

          # Apply the crop inference to a file and return a list of extracted images.
          #
          # @param input_source [Mindee::Input::Source::LocalInputSource] Local file to extract from
          # @return [Image::ExtractedImages] List of extracted images
          def extract_from_input_source(input_source)
            FileOperation::Crop.extract_crops(input_source, @crops)
          end

          # String representation.
          # @return [String]
          def to_s
            crops_str = @crops.join("\n")

            "Crops\n=====\n#{crops_str}"
          end
        end
      end
    end
  end
end
