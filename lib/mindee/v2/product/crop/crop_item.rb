# frozen_string_literal: true

module Mindee
  module V2
    module Product
      module Crop
        # Result of a cropped document region.
        class CropItem
          # @return [String] Type or classification of the detected object.
          attr_reader :object_type
          # @return [V2::Parsing::Field::FieldLocation] Coordinates of the detected object on the document.
          attr_reader :location

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            @object_type = server_response['object_type']
            @location = Mindee::V2::Parsing::Field::FieldLocation.new(server_response['location'])
          end

          # String representation.
          # @return [String]
          def to_s
            "* :Location: #{location}\n  :Object Type: #{object_type}"
          end

          # Extract all crop items from this page
          #
          # @param input_source [Mindee::Input::Source::LocalInputSource] Local file to extract from
          # @return [ExtractedImage]
          def extract_from_file(input_source)
            Image::ImageExtractor.extract_multiple_images_from_source(
              input_source, @location.page, [@location.polygon]
            )[0]
          end
        end
      end
    end
  end
end
