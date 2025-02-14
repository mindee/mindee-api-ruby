# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module BarcodeReader
      # Barcode Reader API version 1.0 document data.
      class BarcodeReaderV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # List of decoded 1D barcodes.
        # @return [Array<Mindee::Parsing::Standard::StringField>]
        attr_reader :codes_1d
        # List of decoded 2D barcodes.
        # @return [Array<Mindee::Parsing::Standard::StringField>]
        attr_reader :codes_2d

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super(prediction, page_id)
          @codes_1d = [] # : Array[Parsing::Standard::StringField]
          prediction['codes_1d'].each do |item|
            @codes_1d.push(Parsing::Standard::StringField.new(item, page_id))
          end
          @codes_2d = [] # : Array[Parsing::Standard::StringField]
          prediction['codes_2d'].each do |item|
            @codes_2d.push(Parsing::Standard::StringField.new(item, page_id))
          end
        end

        # @return [String]
        def to_s
          codes_1d = @codes_1d.join("\n #{' ' * 13}")
          codes_2d = @codes_2d.join("\n #{' ' * 13}")
          out_str = String.new
          out_str << "\n:Barcodes 1D: #{codes_1d}".rstrip
          out_str << "\n:Barcodes 2D: #{codes_2d}".rstrip
          out_str[1..].to_s
        end
      end
    end
  end
end
