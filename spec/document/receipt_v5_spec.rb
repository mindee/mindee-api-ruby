# frozen_string_literal: true

require 'json'
require 'mindee/product'
require 'mindee/parsing'

require_relative '../data'

DIR_RECEIPT_V5 = File.join(DATA_DIR, 'receipt', 'response_v5').freeze

describe Mindee::Product::Receipt::ReceiptV5 do
  include Mindee::Parsing::Common
  context 'A Expense Receipt V5' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_RECEIPT_V5, 'empty.json')
      inference = Mindee::Parsing::Common::Document.new(Mindee::Product::Receipt::ReceiptV5,
                                                        response['document']).inference
      expect(inference.product.type).to eq('standard')
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_RECEIPT_V5, 'summary_full.rst')
      response = load_json(DIR_RECEIPT_V5, 'complete.json')
      document = Mindee::Parsing::Common::Document.new(Mindee::Product::Receipt::ReceiptV5, response['document'])
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_RECEIPT_V5, 'summary_page0.rst')
      response = load_json(DIR_RECEIPT_V5, 'complete.json')
      document = Mindee::Parsing::Common::Document.new(Mindee::Product::Receipt::ReceiptV5, response['document'])
      page = document.inference.pages[0]
      expect(page.orientation.value).to eq(0)
      expect(page.to_s).to eq(to_string)
    end
  end
end
