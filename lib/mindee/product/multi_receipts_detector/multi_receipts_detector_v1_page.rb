# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'multi_receipts_detector_v1_document'

module Mindee
  module Product
    module MultiReceiptsDetector
      # Multi Receipts Detector API version 1.1 page data.
      class MultiReceiptsDetectorV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = if prediction['prediction'].empty?
                          {}
                        else
                          MultiReceiptsDetectorV1PagePrediction.new(
                            prediction['prediction'],
                            prediction['id']
                          )
                        end
        end
      end

      # Multi Receipts Detector V1 page prediction.
      class MultiReceiptsDetectorV1PagePrediction < MultiReceiptsDetectorV1Document
        # @return [String]
        def to_s
          out_str = String.new
          out_str << "\n#{super}"
          out_str
        end
      end
    end
  end
end
