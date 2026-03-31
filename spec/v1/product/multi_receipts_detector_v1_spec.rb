# frozen_string_literal: true

require 'json'
require 'mindee/v1/product'
require 'mindee/v1/parsing'

require_relative '../../data'

DIR_MULTI_RECEIPTS_DETECTOR_V1 = File.join(V1_DATA_DIR, 'products', 'multi_receipts_detector', 'response_v1').freeze

describe Mindee::V1::Product::MultiReceiptsDetector::MultiReceiptsDetectorV1 do
  context 'A Multi Receipts Detector V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_MULTI_RECEIPTS_DETECTOR_V1, 'empty.json')
      inference = Mindee::V1::Parsing::Common::Document.new(
        Mindee::V1::Product::MultiReceiptsDetector::MultiReceiptsDetectorV1,
        response['document']
      ).inference
      expect(inference.product.type).to eq('standard')
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_MULTI_RECEIPTS_DETECTOR_V1, 'summary_full.rst')
      response = load_json(DIR_MULTI_RECEIPTS_DETECTOR_V1, 'complete.json')
      document = Mindee::V1::Parsing::Common::Document.new(
        Mindee::V1::Product::MultiReceiptsDetector::MultiReceiptsDetectorV1,
        response['document']
      )
      expect(document.to_s).to eq(to_string)
    end
  end
end
