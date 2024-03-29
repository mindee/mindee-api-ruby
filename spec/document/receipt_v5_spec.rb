# frozen_string_literal: true

require 'json'
require 'mindee/product'
require 'mindee/parsing'

require_relative '../data'

DIR_RECEIPT_V5 = File.join(DATA_DIR, 'products', 'expense_receipts', 'response_v5').freeze

describe Mindee::Product::Receipt::ReceiptV5 do
  context 'A Receipt V5' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_RECEIPT_V5, 'empty.json')
      inference = Mindee::Parsing::Common::Document.new(
        Mindee::Product::Receipt::ReceiptV5,
        response['document']
      ).inference
      expect(inference.product.type).to eq('standard')
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_RECEIPT_V5, 'summary_full.rst')
      response = load_json(DIR_RECEIPT_V5, 'complete.json')
      document = Mindee::Parsing::Common::Document.new(
        Mindee::Product::Receipt::ReceiptV5,
        response['document']
      )
      expect(document.to_s).to eq(to_string)
    end
  end
end
