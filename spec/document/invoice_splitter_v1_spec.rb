# frozen_string_literal: true

require 'json'
require 'mindee/parsing'

require_relative '../data'

DIR_INVOICE_SPLITTER_V1 = File.join(DATA_DIR, 'invoice_splitter', 'response_v1').freeze

describe Mindee::Prediction::InvoiceSplitterV1 do
  context 'An Invoice Splitter V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_INVOICE_SPLITTER_V1, 'empty.json')
      document = Mindee::Document.new(Mindee::Prediction::InvoiceSplitterV1, response['document'])
      prediction = document.inference.prediction
      expect(prediction.invoice_page_groups).to eq([])
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_INVOICE_SPLITTER_V1, 'summary_full.rst')
      response = load_json(DIR_INVOICE_SPLITTER_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::InvoiceSplitterV1, response['document'])
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete inference' do
      to_string = read_file(DIR_INVOICE_SPLITTER_V1, '2_invoices_inference_summary.rst')
      response = load_json(DIR_INVOICE_SPLITTER_V1, '2_invoices_response.json')
      document = Mindee::Document.new(Mindee::Prediction::InvoiceSplitterV1, response['document'])
      page = document.inference.pages[0]
      expect(page.orientation.value).to eq(0)
      expect(page.prediction.due_date.page_id).to eq(0)
      expect(page.to_s).to eq(to_string)
    end
  end
end
