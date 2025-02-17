# frozen_string_literal: true

require 'json'
require 'rspec'
require_relative 'extras_utils'

shared_context 'load pages' do
  let(:load_pages) do
    prediction_data = JSON.parse(File.read(File.join(EXTRAS_DIR, 'full_text_ocr', 'complete.json')))
    Mindee::Parsing::Common::ApiResponse.new(
      Mindee::Product::InternationalId::InternationalIdV2,
      prediction_data,
      prediction_data
    ).document.inference.pages
  end
end

shared_context 'load document' do
  let(:load_document) do
    prediction_data = JSON.parse(File.read(File.join(EXTRAS_DIR, 'full_text_ocr', 'complete.json')))
    Mindee::Parsing::Common::ApiResponse.new(
      Mindee::Product::InternationalId::InternationalIdV2,
      prediction_data,
      prediction_data
    ).document
  end
  let(:load_invalid_document) do
    prediction_data = JSON.parse(
      File.read(File.join(DIR_PRODUCTS, 'bank_statement_fr', 'response_v1', 'complete.json'))
    )
    Mindee::Parsing::Common::ApiResponse.new(
      Mindee::Product::FR::BankStatement::BankStatementV1,
      prediction_data,
      prediction_data
    ).document
  end
end

describe 'FullTextOCR' do
  include_context 'load document'
  include_context 'load pages'

  it 'gets full text OCR result' do
    expected_text = File.read(File.join(EXTRAS_DIR, 'full_text_ocr', 'full_text_ocr.txt'))

    full_text_ocr = load_document.extras.full_text_ocr
    page0_ocr = load_pages[0].extras.full_text_ocr.contents

    expect(full_text_ocr.to_s.strip).to eq(expected_text.strip)
    expect(page0_ocr).to eq(expected_text.split("\n").join("\n"))
  end

  it "doesn't get full text when the payload is empty" do
    full_text_ocr = load_invalid_document
    expect(full_text_ocr.extras).to be_nil
  end

  it "doesn't get full text when loading dummy data" do
    synthetic_response = {
      'id' => 'mock_id',
      'name' => 'mock_name',
      'inference' => {
        'extras' => {},
        'finished_at' => '1900-01-00T00:00:00.000000',
        'is_rotation_applied' => nil,
        'product' => {
          'name' => 'mock_name',
          'type' => 'mock_type',
          'version' => 'mock_version',
        },
        'pages' => [
          {
            'extras' => {},
            'id' => 0,
            'orientation' => {
              'value' => 0,
            },
            'prediction' => {},
          },
        ],
        'prediction' => {
          'account_number' => {
            'value' => nil,
            'confidence' => 0,
          },
          'bank_address' => {
            'value' => nil,
            'confidence' => 0,
          },
          'bank_name' => {
            'value' => nil,
            'confidence' => 0,
          },
          'client_address' => {
            'value' => nil,
            'confidence' => 0,
          },
          'client_name' => {
            'value' => nil,
            'confidence' => 0,
          },
          'closing_balance' => {
            'value' => nil,
            'confidence' => 0,
          },
          'opening_balance' => {
            'value' => nil,
            'confidence' => 0,
          },
          'statement_date' => {
            'value' => nil,
            'confidence' => 0,
          },
          'statement_end_date' => {
            'value' => nil,
            'confidence' => 0,
          },
          'statement_start_date' => {
            'value' => nil,
            'confidence' => 0,
          },
          'total_credits' => {
            'value' => nil,
            'confidence' => 0,
          },
          'total_debits' => {
            'value' => nil,
            'confidence' => 0,
          },
          'transactions' => [
            {
              'value' => nil,
              'confidence' => 0,
            },
          ],
        },
      },
      'extras' => {},
      'n_pages' => 0,
    }
    built_doc = Mindee::Parsing::Common::Document.new(
      Mindee::Product::FR::BankStatement::BankStatementV1,
      synthetic_response
    )
    expect(built_doc.extras).to be_nil
  end
end
