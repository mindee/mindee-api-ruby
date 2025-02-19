# frozen_string_literal: true

require 'mindee/product'
require 'mindee/input/sources'
require 'mindee/extraction'
require_relative '../data'

describe 'multi-receipts extraction' do
  let(:empty_inference) do
    double('Inference', prediction: double('Prediction', receipts: nil), pages: [])
  end

  let(:valid_inference_with_no_receipts) do
    double('Inference', prediction: double('Prediction', receipts: []), pages: [])
  end

  let(:empty_input_source) do
    double('InputSource', count_pages: 0)
  end
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

  context 'with single page multi receipt' do
    it 'splits receipts correctly' do
      input_sample = Mindee::Input::Source::PathInputSource.new(multi_receipts_single_page_path)
      response = load_json(multi_receipts_single_page_json_path, 'complete.json')
      doc = Mindee::Product::MultiReceiptsDetector::MultiReceiptsDetectorV1.new(response['document']['inference'])
      extracted_receipts = Mindee::Extraction.extract_receipts(input_sample, doc)

      expect(extracted_receipts.size).to eq(6)

      expect(extracted_receipts[0].page_id).to eq(1)
      expect(extracted_receipts[0].element_id).to eq(0)
      image_buffer0 = MiniMagick::Image.read(extracted_receipts[0].buffer)
      # NOTE: this varies from other SDKs due to different image processing.
      expect(image_buffer0.dimensions).to eq([341, 504])
      expect(extracted_receipts[0].as_source.filename).to end_with('jpg')

      expect(extracted_receipts[1].page_id).to eq(1)
      expect(extracted_receipts[1].element_id).to eq(1)
      image_buffer1 = MiniMagick::Image.read(extracted_receipts[1].buffer)
      expect(image_buffer1.dimensions).to eq([461, 908])
      expect(extracted_receipts[1].as_source.filename).to end_with('jpg')

      expect(extracted_receipts[2].page_id).to eq(1)
      expect(extracted_receipts[2].element_id).to eq(2)
      image_buffer2 = MiniMagick::Image.read(extracted_receipts[2].buffer)
      expect(image_buffer2.dimensions).to eq([472, 790])
      expect(extracted_receipts[2].as_source.filename).to end_with('jpg')

      expect(extracted_receipts[3].page_id).to eq(1)
      expect(extracted_receipts[3].element_id).to eq(3)
      image_buffer3 = MiniMagick::Image.read(extracted_receipts[3].buffer)
      expect(image_buffer3.dimensions).to eq([464, 1200])
      expect(extracted_receipts[3].as_source.filename).to end_with('jpg')

      expect(extracted_receipts[4].page_id).to eq(1)
      expect(extracted_receipts[4].element_id).to eq(4)
      image_buffer4 = MiniMagick::Image.read(extracted_receipts[4].buffer)
      expect(image_buffer4.dimensions).to eq([530, 944])
      expect(extracted_receipts[4].as_source.filename).to end_with('jpg')

      expect(extracted_receipts[5].page_id).to eq(1)
      expect(extracted_receipts[5].element_id).to eq(5)
      image_buffer5 = MiniMagick::Image.read(extracted_receipts[5].buffer)
      expect(image_buffer5.dimensions).to eq([366, 593])
      expect(extracted_receipts[5].as_source.filename).to end_with('jpg')
    end
  end

  context 'with multi page receipt' do
    it 'splits receipts correctly' do
      input_sample = Mindee::Input::Source::PathInputSource.new(multi_receipts_multi_page_path)
      response = load_json(multi_receipts_multi_page_json_path, 'multipage_sample.json')
      doc = Mindee::Product::MultiReceiptsDetector::MultiReceiptsDetectorV1.new(response['document']['inference'])
      extracted_receipts = Mindee::Extraction.extract_receipts(input_sample, doc)

      expect(extracted_receipts.size).to eq(5)

      expect(extracted_receipts[0].page_id).to eq(1)
      expect(extracted_receipts[0].element_id).to eq(0)
      image_buffer0 = MiniMagick::Image.read(extracted_receipts[0].buffer)
      expect(image_buffer0.dimensions).to eq([198, 566])
      expect(extracted_receipts[0].as_source.filename).to end_with('jpg')

      expect(extracted_receipts[1].page_id).to eq(1)
      expect(extracted_receipts[1].element_id).to eq(1)
      image_buffer1 = MiniMagick::Image.read(extracted_receipts[1].buffer)
      expect(image_buffer1.dimensions).to eq([205, 382])
      expect(extracted_receipts[1].as_source.filename).to end_with('jpg')

      expect(extracted_receipts[2].page_id).to eq(1)
      expect(extracted_receipts[2].element_id).to eq(2)
      image_buffer2 = MiniMagick::Image.read(extracted_receipts[2].buffer)
      expect(image_buffer2.dimensions).to eq([195, 232])
      expect(extracted_receipts[2].as_source.filename).to end_with('jpg')

      expect(extracted_receipts[3].page_id).to eq(2)
      expect(extracted_receipts[3].element_id).to eq(0)
      image_buffer3 = MiniMagick::Image.read(extracted_receipts[3].buffer)
      expect(image_buffer3.dimensions).to eq([213, 355])
      expect(extracted_receipts[3].as_source.filename).to end_with('jpg')

      expect(extracted_receipts[4].page_id).to eq(2)
      expect(extracted_receipts[4].element_id).to eq(1)
      image_buffer4 = MiniMagick::Image.read(extracted_receipts[4].buffer)
      expect(image_buffer4.dimensions).to eq([212, 516])
      expect(extracted_receipts[4].as_source.filename).to end_with('jpg')
    end
  end

  context 'when no receipts are found in inference' do
    it 'raises a MindeeInputError' do
      expect do
        Mindee::Extraction.extract_receipts(empty_input_source, empty_inference)
      end.to raise_error(Mindee::Errors::MindeeInputError,
                         'No possible receipts candidates found for Multi-Receipts extraction.')
    end
  end

  context 'when input source has no pages' do
    it 'returns an empty array' do
      extracted_receipts = Mindee::Extraction.extract_receipts(empty_input_source,
                                                               valid_inference_with_no_receipts)
      expect(extracted_receipts).to eq([])
    end
  end
end
