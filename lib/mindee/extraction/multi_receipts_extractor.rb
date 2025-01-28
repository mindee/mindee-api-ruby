# frozen_string_literal: true

module Mindee
  # Custom extraction module
  module Extraction
    # Multi-receipts extraction
    # Extracts individual receipts from multi-receipts documents.
    #
    # @param input_source [LocalInputSource] Local Input Source to extract sub-receipts from.
    # @param inference [Inference] Results of the inference.
    # @return [Array<ExtractedImage>] Individual extracted receipts as an array of ExtractedMultiReceiptsImage.
    def self.extract_receipts(input_source, inference)
      images = []
      unless inference.prediction.receipts
        raise Errors::MindeeInputError,
              'No possible receipts candidates found for Multi-Receipts extraction.'
      end

      (0...input_source.count_pdf_pages).each do |page_id|
        receipt_positions = inference.pages[page_id].prediction.receipts.map(&:bounding_box)
        images.concat(
          Mindee::Image::ImageExtractor.extract_multiple_images_from_source(input_source, page_id + 1,
                                                                            receipt_positions)
        )
      end

      images
    end
  end
end
