# frozen_string_literal: true

require 'json'
require 'mindee/product'
require 'mindee/parsing'

require_relative '../data'

DIR_MULTI_RECEIPTS_DETECTOR_V1 = File.join(DATA_DIR, 'products', 'multi_receipts_detector', 'response_v1').freeze

describe Mindee::Product::MultiReceiptsDetector::MultiReceiptsDetectorV1 do
  context 'A Multi Receipts Detector V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_MULTI_RECEIPTS_DETECTOR_V1, 'empty.json')
      inference = Mindee::Parsing::Common::Document.new(
        Mindee::Product::MultiReceiptsDetector::MultiReceiptsDetectorV1,
        response['document']
      ).inference
      expect(inference.product.type).to eq('standard')
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_MULTI_RECEIPTS_DETECTOR_V1, 'summary_full.rst')
      response = load_json(DIR_MULTI_RECEIPTS_DETECTOR_V1, 'complete.json')
      document = Mindee::Parsing::Common::Document.new(
        Mindee::Product::MultiReceiptsDetector::MultiReceiptsDetectorV1,
        response['document']
      )
      expect(document.to_s).to eq(to_string)
    end
  end
end
