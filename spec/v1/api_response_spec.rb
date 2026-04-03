# frozen_string_literal: true

require 'json'
require 'mindee'
require_relative '../data'

describe Mindee::V1::Parsing::Common::ApiResponse do
  context 'An Invoice document' do
    it 'should be properly created from an ApiResponse' do
      response = load_json(V1_PRODUCT_DATA_DIR, 'invoices/response_v4/complete.json')
      raw_response = JSON.generate(response)
      rst_response = read_file(V1_PRODUCT_DATA_DIR, 'invoices/response_v4/summary_full.rst')
      parsed_response = Mindee::V1::Parsing::Common::ApiResponse.new(Mindee::V1::Product::Invoice::InvoiceV4,
                                                                     response, raw_response)
      expect(parsed_response.document.inference).to be_a Mindee::V1::Product::Invoice::InvoiceV4
      expect(parsed_response.document.inference.prediction).to be_a Mindee::V1::Product::Invoice::InvoiceV4Document
      expect(parsed_response.raw_http).to eq(raw_response)
      expect(parsed_response.document.n_pages).to eq(1)
      expect(parsed_response.document.inference.pages.length).to eq(1)
      expect(parsed_response.document.to_s).to eq(rst_response.to_s)
    end
  end
end
