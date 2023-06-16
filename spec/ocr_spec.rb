# frozen_string_literal: true
require 'json'
require 'mindee'

require_relative './data'

DIR_OCR = File.join(DATA_DIR, 'ocr')

describe Mindee::Ocr::Ocr do
  context 'An OCR extraction' do
    json_data = load_json(DIR_OCR, 'complete_with_ocr.json')
    it 'should extract ocr data from a document' do
      expected_text = read_file(DIR_OCR, 'ocr.txt')
      ocr = Mindee::Ocr::Ocr.new(json_data["document"]["ocr"])
      expect(ocr.to_s).to eq(expected_text)
      expect(ocr.mvision_v1.pages[0].to_s).to eq(expected_text)
    end
  end
end


# def test_response
#   json_data = json.load(open("./data/ocr/complete_with_ocr.json"))
#   with open("./tests/data/ocr/ocr.txt") as file_handle:
#       expected_text = file_handle.read()
#   ocr = Ocr(json_data["document"]["ocr"])
#   assert str(ocr) == expected_text
#   assert str(ocr.mvision_v1.pages[0]) == expected_text
# end