# frozen_string_literal: true

require 'json'
require 'mindee/product'

require_relative '../data'

DIR_INVOICE_SPLITTER_V1 = File.join(DATA_DIR, 'invoice_splitter', 'response_v1').freeze

describe Mindee::Product::InvoiceSplitterV1 do
  context 'An Invoice Splitter V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_INVOICE_SPLITTER_V1, 'empty.json')
      document = Mindee::Document.new(Mindee::Product::InvoiceSplitterV1, response['document'])
      prediction = document.inference.prediction
      expect(prediction.invoice_page_groups).to eq([])
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_INVOICE_SPLITTER_V1, 'summary_full.rst')
      response = load_json(DIR_INVOICE_SPLITTER_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Product::InvoiceSplitterV1, response['document'])
      expect(document.to_s).to eq(to_string)
    end
  end
end
