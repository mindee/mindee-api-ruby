# frozen_string_literal: true

require 'json'
require 'mindee/product'

require_relative '../data'

DIR_INVOICE_V4 = File.join(DATA_DIR, 'invoice', 'response_v4').freeze

describe Mindee::Product::InvoiceV4 do
  context 'An Invoice V4' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_INVOICE_V4, 'empty.json')
      document = Mindee::Document.new(Mindee::Product::InvoiceV4, response['document'])
      expect(document.inference.product.type).to eq('standard')
      prediction = document.inference.prediction
      expect(prediction.invoice_number.value).to be_nil
      expect(prediction.invoice_number.polygon).to be_empty
      expect(prediction.invoice_number.bounding_box).to be_nil
      expect(prediction.date.value).to be_nil
      expect(prediction.date.page_id).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_INVOICE_V4, 'summary_full.rst')
      response = load_json(DIR_INVOICE_V4, 'complete.json')
      document = Mindee::Document.new(Mindee::Product::InvoiceV4, response['document'])
      prediction = document.inference.prediction
      expect(prediction.invoice_number.bounding_box.top_left.x).to eq(prediction.invoice_number.polygon[0][0])
      expect(prediction.date.value).to eq('2020-02-17')
      expect(prediction.due_date.value).to eq('2020-02-17')
      expect(prediction.due_date.page_id).to eq(0)
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_INVOICE_V4, 'summary_page0.rst')
      response = load_json(DIR_INVOICE_V4, 'complete.json')
      document = Mindee::Document.new(Mindee::Product::InvoiceV4, response['document'])
      page = document.inference.pages[0]
      expect(page.orientation.value).to eq(0)
      expect(page.prediction.due_date.page_id).to eq(0)
      expect(page.to_s).to eq(to_string)
    end
  end
end
