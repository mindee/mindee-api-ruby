# frozen_string_literal: true

require 'json'
require 'rspec'
require_relative 'extras_utils'

# NOTE: Implementing extras per pages without content (like the Java library)
# would be a breaking change for the Ruby SDK.
# This fixture is left here as a reminder that next major version should probably implement it.

# shared_context "load pages" do
#   let(:load_pages) do
#     prediction_data = JSON.parse(File.read(File.join(EXTRAS_DIR, 'full_text_ocr', 'complete.json')))
#     Mindee::Parsing::Common::ApiResponse.new(InternationalIdV2, prediction_data, prediction_data).
#       document.inference.pages
#   end
# end

def load_document_from_path(file_path)
  prediction_data = JSON.parse(File.read(file_path))
  Mindee::Parsing::Common::ApiResponse.new(
    Mindee::Product::InternationalId::InternationalIdV2,
    prediction_data,
    prediction_data
  ).document
end

describe 'FullTextOCR' do
  it 'gets full text OCR result' do
    expected_text = File.read(File.join(EXTRAS_DIR, 'full_text_ocr', 'full_text_ocr.txt'))

    full_text_ocr = load_document_from_path(File.join(EXTRAS_DIR, 'full_text_ocr', 'complete.json')).extras.full_text_ocr
    # page0_ocr = load_pages[0].extras.full_text_ocr.content

    expect(full_text_ocr.to_s.strip).to eq(expected_text.strip)
    # expect(page0_ocr).to eq(expected_text.split("\n").join("\n"))
  end

  it "doesn't get full text when the payload is empty" do
    full_text_ocr = load_document_from_path(File.join(DIR_PRODUCTS, 'international_id', 'response_v2', 'complete.json'))
    expect(full_text_ocr.extras).to be_nil
  end
end
