# frozen_string_literal: true

require 'json'
require 'mindee/parsing'

require_relative '../data'

describe Mindee::Parsing::Common do
  include Mindee::Parsing::Common
  context 'An OCR extraction' do
    json_data = load_json(V1_OCR_DIR, 'complete.json')
    it 'should extract ocr data from a document' do
      expected_text = read_file(V1_OCR_DIR, 'ocr.txt')
      ocr = Mindee::Parsing::Common::OCR::OCR.new(json_data['document']['ocr'])
      expect(ocr.to_s).to eq(expected_text)
      expect(ocr.mvision_v1.pages[0].to_s).to eq(expected_text)
    end
  end
end
