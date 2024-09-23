# frozen_string_literal: true

require_relative '../common/image_extractor'

module Mindee
  # Image Extraction Module.
  module Extraction
    # Multi-receipts extraction class wrapper.
    class MultiReceiptsExtractor
      def self.extract_receipts(input_source, inference)
        # Extracts individual receipts from multi-receipts documents.
        #
        # @param input_source [LocalInputSource] Local Input Source to extract sub-receipts from.
        # @param inference [Inference] Results of the inference.
        # @return [Array<ExtractedImage>] Individual extracted receipts as an array of ExtractedMultiReceiptsImage.

        images = []
        raise 'No possible receipts candidates found for MultiReceipts extraction.' unless inference.prediction.receipts

        (0...input_source.count_pdf_pages).each do |page_id|
          receipt_positions = inference.pages[page_id].prediction.receipts.map(&:bounding_box)
          images.concat(
            Mindee::Extraction::ImageExtractor.extract_multiple_images_from_source(input_source, page_id + 1,
                                                                                   receipt_positions)
          )
        end

        images
      end
    end
  end
end
