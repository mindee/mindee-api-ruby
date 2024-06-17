# frozen_string_literal: true

require 'mindee/product'
require 'mindee/input/sources'
require 'mindee/image_extraction'
require_relative '../data'

describe Mindee::ImageExtraction do
  include Mindee::ImageExtraction
  let(:multi_receipts_single_page_path) do
    File.join(DATA_DIR, 'products', 'multi_receipts_detector', 'default_sample.jpg')
  end

  let(:multi_receipts_single_page_json_path) do
    File.join(DATA_DIR, 'products', 'multi_receipts_detector', 'response_v1')
  end

  let(:multi_receipts_multi_page_path) do
    File.join(DATA_DIR, 'products', 'multi_receipts_detector', 'multipage_sample.pdf')
  end

  let(:multi_receipts_multi_page_json_path) do
    File.join(DATA_DIR, 'products', 'multi_receipts_detector', 'response_v1')
  end

  describe '#extract_receipts' do
    context 'with single page multi receipt' do
      it 'splits receipts correctly' do
        input_sample = Mindee::Input::Source::PathInputSource.new(multi_receipts_single_page_path)
        response = load_json(multi_receipts_single_page_json_path, 'complete.json')
        doc = Mindee::Product::MultiReceiptsDetector::MultiReceiptsDetectorV1.new(response['document']['inference'])
        extracted_receipts = extract_receipts(input_sample, doc)

        expect(extracted_receipts.size).to eq(6)

        expect(extracted_receipts[0].page_id).to eq(1)
        expect(extracted_receipts[0].element_id).to eq(0)
        image_buffer0 = MiniMagick::Image.read(extracted_receipts[0].buffer)
        expect(image_buffer0.dimensions).to eq([341, 505])

        expect(extracted_receipts[1].page_id).to eq(1)
        expect(extracted_receipts[1].element_id).to eq(1)
        image_buffer1 = MiniMagick::Image.read(extracted_receipts[1].buffer)
        expect(image_buffer1.dimensions).to eq([461, 908])

        expect(extracted_receipts[2].page_id).to eq(1)
        expect(extracted_receipts[2].element_id).to eq(2)
        image_buffer2 = MiniMagick::Image.read(extracted_receipts[2].buffer)
        expect(image_buffer2.dimensions).to eq([471, 790])

        expect(extracted_receipts[3].page_id).to eq(1)
        expect(extracted_receipts[3].element_id).to eq(3)
        image_buffer3 = MiniMagick::Image.read(extracted_receipts[3].buffer)
        expect(image_buffer3.dimensions).to eq([464, 1200])

        expect(extracted_receipts[4].page_id).to eq(1)
        expect(extracted_receipts[4].element_id).to eq(4)
        image_buffer4 = MiniMagick::Image.read(extracted_receipts[4].buffer)
        expect(image_buffer4.dimensions).to eq([530, 943])

        expect(extracted_receipts[5].page_id).to eq(1)
        expect(extracted_receipts[5].element_id).to eq(5)
        image_buffer5 = MiniMagick::Image.read(extracted_receipts[5].buffer)
        expect(image_buffer5.dimensions).to eq([367, 593])
      end
    end

    context 'with multi page receipt' do
      it 'splits receipts correctly' do
        input_sample = Mindee::Input::Source::PathInputSource.new(multi_receipts_multi_page_path)
        response = load_json(multi_receipts_multi_page_json_path, 'multipage_sample.json')
        doc = Mindee::Product::MultiReceiptsDetector::MultiReceiptsDetectorV1.new(response['document']['inference'])
        extracted_receipts = extract_receipts(input_sample, doc)

        expect(extracted_receipts.size).to eq(5)

        expect(extracted_receipts[0].page_id).to eq(1)
        expect(extracted_receipts[0].element_id).to eq(0)
        image_buffer0 = MiniMagick::Image.read(extracted_receipts[0].buffer)
        expect(image_buffer0.dimensions).to eq([198, 566])

        expect(extracted_receipts[1].page_id).to eq(1)
        expect(extracted_receipts[1].element_id).to eq(1)
        image_buffer1 = MiniMagick::Image.read(extracted_receipts[1].buffer)
        expect(image_buffer1.dimensions).to eq([206, 382])

        expect(extracted_receipts[2].page_id).to eq(1)
        expect(extracted_receipts[2].element_id).to eq(2)
        image_buffer2 = MiniMagick::Image.read(extracted_receipts[2].buffer)
        expect(image_buffer2.dimensions).to eq([195, 231])

        expect(extracted_receipts[3].page_id).to eq(2)
        expect(extracted_receipts[3].element_id).to eq(0)
        image_buffer3 = MiniMagick::Image.read(extracted_receipts[3].buffer)
        expect(image_buffer3.dimensions).to eq([213, 356])

        expect(extracted_receipts[4].page_id).to eq(2)
        expect(extracted_receipts[4].element_id).to eq(1)
        image_buffer4 = MiniMagick::Image.read(extracted_receipts[4].buffer)
        expect(image_buffer4.dimensions).to eq([212, 516])
      end
    end
  end
end
