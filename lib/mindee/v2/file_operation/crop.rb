# frozen_string_literal: true

module Mindee
  module V2
    module FileOperation
      # Crop operations.
      module Crop
        # Extracts a single crop as complete PDFs from the document.
        #
        # @param input_source [LocalInputSource] Local Input Source to extract sub-receipts from.
        # @param crop [FieldLocation] Crop to extract.
        # @return [ExtractedImage]
        def self.extract_single_crop(input_source, crop)
          polygons = [crop.polygon]
          Mindee::Image::ImageExtractor.extract_multiple_images_from_source(
            input_source, crop.page, polygons
          ).first
        end

        # Extracts individual receipts from multi-receipts documents.
        #
        # @param input_source [LocalInputSource] Local Input Source to extract sub-receipts from.
        # @param crops [Array<CropItem>] List of crops.
        # @return [CropFiles] Individual extracted receipts as an array of ExtractedImage.
        # @raise [MindeeError] if the crops array is empty.
        def self.extract_crops(input_source, crops)
          if crops.nil? || crops.empty?
            raise Mindee::Error::MindeeError,
                  'No possible candidates found for Crop extraction.'
          end

          polygons = Array.new(input_source.page_count) { [] }

          crops.each do |crop|
            polygons[crop.location.page] << crop.location.polygon
          end

          images = []
          polygons.each_with_index do |page_polygons, page_index|
            extracted = Mindee::Image::ImageExtractor.extract_multiple_images_from_source(
              input_source, page_index, page_polygons
            )
            images.concat(extracted)
          end

          CropFiles.new(images)
        end
      end
    end
  end
end
