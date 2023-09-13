# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'barcode_reader_v1_document'
require_relative 'barcode_reader_v1_page'

module Mindee
  module Product
    # Barcode Reader module.
    module BarcodeReader
      # Barcode Reader V1 prediction inference.
      class BarcodeReaderV1 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'barcode_reader'
        @endpoint_version = '1'

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = BarcodeReaderV1Document.new(prediction['prediction'], nil)
          @pages = []
          prediction['pages'].each do |page|
            @pages.push(BarcodeReaderV1Page.new(page))
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
