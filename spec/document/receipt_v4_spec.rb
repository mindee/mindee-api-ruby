# frozen_string_literal: true

require 'json'
require 'mindee/parsing'

require_relative '../data'

DIR_RECEIPT_V4 = File.join(DATA_DIR, 'receipt', 'response_v4').freeze

describe Mindee::Product::ReceiptV4 do
  context 'A Receipt V4' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_RECEIPT_V4, 'empty.json')
      inference = Mindee::Document.new(Mindee::Prediction::ReceiptV4, response['document']).inference
      expect(inference.product.type).to eq('standard')
      expect(inference.prediction.date.value).to be_nil
      expect(inference.prediction.date.page_id).to be_nil
      expect(inference.prediction.time.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_RECEIPT_V4, 'summary_full.rst')
      response = load_json(DIR_RECEIPT_V4, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::ReceiptV4, response['document'])
      expect(document.inference.prediction.date.page_id).to eq(0)
      expect(document.inference.prediction.date.value).to eq('2014-07-07')
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_RECEIPT_V4, 'summary_page0.rst')
      response = load_json(DIR_RECEIPT_V4, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::ReceiptV4, response['document'])
      page = document.inference.pages[0]
      expect(page.orientation.value).to eq(0)
      expect(page.prediction.date.page_id).to eq(0)
      expect(page.to_s).to eq(to_string)
    end
  end
end
