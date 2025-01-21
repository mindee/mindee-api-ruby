# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'barcode_reader_v1_document'

module Mindee
  module Product
    module BarcodeReader
      # Barcode Reader API version 1.0 page data.
      class BarcodeReaderV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = BarcodeReaderV1PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # Barcode Reader V1 page prediction.
      class BarcodeReaderV1PagePrediction < BarcodeReaderV1Document
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
