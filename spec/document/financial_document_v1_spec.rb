# frozen_string_literal: true

require 'json'
require 'mindee/product'

require_relative '../data'

DIR_FINANCIAL_DOCUMENT_V1 = File.join(DATA_DIR, 'financial_document', 'response_v1').freeze

describe Mindee::Product::FinancialDocumentV1 do
  context 'A FinancialDocumentV1' do
    context 'when processing an invoice' do
      it 'should load an empty document prediction' do
        response = load_json(DIR_FINANCIAL_DOCUMENT_V1, 'empty.json')
        document = Mindee::Document.new(Mindee::Product::FinancialDocumentV1, response['document'])
        expect(document.inference.product.type).to eq('standard')
        prediction = document.inference.prediction
        expect(prediction.invoice_number.value).to be_nil
        expect(prediction.invoice_number.polygon).to be_empty
        expect(prediction.invoice_number.bounding_box).to be_nil
        expect(prediction.date.value).to be_nil
        expect(prediction.date.page_id).to be_nil
      end

      it 'should load a complete document prediction' do
        to_string = read_file(DIR_FINANCIAL_DOCUMENT_V1, 'summary_full_invoice.rst')
        response = load_json(DIR_FINANCIAL_DOCUMENT_V1, 'complete_invoice.json')
        document = Mindee::Document.new(Mindee::Product::FinancialDocumentV1, response['document'])
        prediction = document.inference.prediction
        expect(prediction.invoice_number.bounding_box.top_left.x).to eq(prediction.invoice_number.polygon[0][0])
        expect(prediction.date.value).to eq('2019-02-11')
        expect(prediction.due_date.value).to eq('2019-02-26')
        expect(prediction.due_date.page_id).to eq(0)
        expect(document.to_s).to eq(to_string)
      end

      it 'should load a complete page 0 prediction' do
        to_string = read_file(DIR_FINANCIAL_DOCUMENT_V1, 'summary_page0_invoice.rst')
        response = load_json(DIR_FINANCIAL_DOCUMENT_V1, 'complete_invoice.json')
        document = Mindee::Document.new(Mindee::Product::FinancialDocumentV1, response['document'])
        page = document.inference.pages[0]
        expect(page.orientation.value).to eq(0)
        expect(page.due_date.page_id).to eq(0)
        expect(page.to_s).to eq(to_string)
      end
    end

    context 'when processing a receipt' do
      it 'should load an empty document prediction' do
        response = load_json(DIR_FINANCIAL_DOCUMENT_V1, 'empty.json')
        inference = Mindee::Document.new(Mindee::Product::FinancialDocumentV1, response['document']).inference
        expect(inference.product.type).to eq('standard')
        expect(inference.prediction.date.value).to be_nil
        expect(inference.prediction.date.page_id).to be_nil
        expect(inference.prediction.time.value).to be_nil
      end

      it 'should load a complete document prediction' do
        to_string = read_file(DIR_FINANCIAL_DOCUMENT_V1, 'summary_full_receipt.rst')
        response = load_json(DIR_FINANCIAL_DOCUMENT_V1, 'complete_receipt.json')
        document = Mindee::Document.new(Mindee::Product::FinancialDocumentV1, response['document'])
        expect(document.inference.prediction.date.page_id).to eq(0)
        expect(document.inference.prediction.date.value).to eq('2014-07-07')
        expect(document.to_s).to eq(to_string)
      end

      it 'should load a complete page 0 prediction' do
        to_string = read_file(DIR_FINANCIAL_DOCUMENT_V1, 'summary_page0_receipt.rst')
        response = load_json(DIR_FINANCIAL_DOCUMENT_V1, 'complete_receipt.json')
        document = Mindee::Document.new(Mindee::Product::FinancialDocumentV1, response['document'])
        page = document.inference.pages[0]
        expect(page.orientation.value).to eq(0)
        expect(page.date.page_id).to eq(0)
        expect(page.to_s).to eq(to_string)
      end
    end
  end
end
