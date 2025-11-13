# frozen_string_literal: true

require 'mindee/product'
require 'mindee/input/sources'
require_relative '../data'

describe Mindee::Image do
  include Mindee::Image
  let(:barcode_path) do
    File.join(V1_DATA_DIR, 'products', 'barcode_reader', 'default_sample.jpg')
  end

  let(:barcode_json_path) do
    File.join(V1_DATA_DIR, 'products', 'barcode_reader', 'response_v1', 'complete.json')
  end

  context 'an image extractor' do
    it 'extracts barcode images correctly' do
      json_data = JSON.parse(File.read(barcode_json_path))
      inference = Mindee::Product::BarcodeReader::BarcodeReaderV1.new(json_data['document']['inference'])
      barcodes1 = inference.prediction.codes_1d.map(&:polygon)
      barcodes2 = inference.prediction.codes_2d.map(&:polygon)
      input_source = Mindee::Input::Source::PathInputSource.new(barcode_path)

      extracted_barcodes_1d = Mindee::Image::ImageExtractor.extract_multiple_images_from_source(input_source, 1,
                                                                                                barcodes1)
      extracted_barcodes_2d = Mindee::Image::ImageExtractor.extract_multiple_images_from_source(input_source, 1,
                                                                                                barcodes2)

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
