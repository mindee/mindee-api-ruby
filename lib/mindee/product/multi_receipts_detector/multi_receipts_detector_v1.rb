# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'multi_receipts_detector_v1_document'
require_relative 'multi_receipts_detector_v1_page'

module Mindee
  module Product
    # Multi Receipts Detector module.
    module MultiReceiptsDetector
      # Multi Receipts Detector V1 prediction inference.
      class MultiReceiptsDetectorV1 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'multi_receipts_detector'
        @endpoint_version = '1'

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = MultiReceiptsDetectorV1Document.new(prediction['prediction'], nil)
          @pages = []
          prediction['pages'].each do |page|
            if page.key?('prediction') && !page['prediction'].nil? && !page['prediction'].empty?
              @pages.push(MultiReceiptsDetectorV1Page.new(page))
            end
          end
        end

        class << self
          # Name of the endpoint for this product.
          # @return [String]
          attr_reader :endpoint_name
          # Version for this product.
          # @return [String]
          attr_reader :endpoint_version
        end
      end
    end
  end
end
