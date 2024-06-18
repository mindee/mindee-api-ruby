# frozen_string_literal: true

require 'mindee/product'
require 'mindee/input/sources'
require 'mindee/image_extraction'
require_relative '../data'

describe Mindee::ImageExtraction do
  include Mindee::ImageExtraction
  let(:barcode_path) do
    File.join(DATA_DIR, 'products', 'barcode_reader', 'default_sample.jpg')
  end

  let(:barcode_json_path) do
    File.join(DATA_DIR, 'products', 'barcode_reader', 'response_v1', 'complete.json')
  end

  context 'an image extractor' do
    it 'extracts barcode images correctly' do
      # Assuming barcode_path and barcode_json_path are fixtures provided by RSpec

      # Load JSON fixture
      json_data = JSON.parse(File.read(barcode_json_path))
      inference = Mindee::Product::BarcodeReader::BarcodeReaderV1.new(json_data['document']['inference'])

      # Extract polygon coordinates
      barcodes1 = []
      inference.prediction.codes_1d.each do |barcode|
        barcodes1.push(barcode.polygon)
      end
      barcodes2 = []
      inference.prediction.codes_2d.each do |barcode|
        barcodes2.push(barcode.polygon)
      end

      # Create input source
      input_source = Mindee::Input::Source::PathInputSource.new(barcode_path)

      # Extract images

      extracted_barcodes_1d = extract_multiple_images_from_source(input_source, 1, barcodes1)
      extracted_barcodes_2d = extract_multiple_images_from_source(input_source, 1, barcodes2)

      # Assertions
      expect(extracted_barcodes_1d.size).to eq(1)
      expect(extracted_barcodes_2d.size).to eq(2)

      expect(extracted_barcodes_1d[0].as_source.filename).to end_with('jpg')
      extracted_barcodes_1d[0].buffer.rewind
      image_buffer1 = MiniMagick::Image.read(extracted_barcodes_1d[0].buffer)
      expect(image_buffer1.dimensions).to eq([353, 199])

      extracted_barcodes_2d[0].buffer.rewind
      image_buffer2 = MiniMagick::Image.read(extracted_barcodes_2d[0].buffer)
      expect(image_buffer2.dimensions).to eq([214, 216])
      expect(extracted_barcodes_2d[0].as_source.filename).to end_with('jpg')

      extracted_barcodes_2d[0].buffer.rewind
      image_buffer3 = MiniMagick::Image.read(extracted_barcodes_2d[1].buffer)
      expect(image_buffer3.dimensions).to eq([193, 201])
      expect(extracted_barcodes_2d[1].as_source.filename).to end_with('jpg')
    end
  end
end
