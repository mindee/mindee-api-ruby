# frozen_string_literal: true

require 'json'
require 'mindee/product'
require 'mindee/parsing'

require_relative '../data'

DIR_OCR = File.join(DATA_DIR, 'products', 'extras', 'ocr').freeze

describe Mindee::Product::Cropper::CropperV1 do
  context 'A custom tax extraction' do
    it 'should properly extract the tax from a document.' do
      response = load_json(DIR_OCR, 'complete.json')
      ocr = Mindee::Parsing::Common::Ocr::Ocr.new(
        response['document']['ocr']
      )
      found_tax = Mindee::Extraction::TaxExtractor.extract_custom_tax(ocr, ['Tax'], 0, 20)
      expect(found_tax.code).to eq("Tax")
      expect(found_tax.rate).to eq(8)
      expect(found_tax.value).to eq(nil)
      expect(found_tax.base).to be_nil
    end
  end
end
