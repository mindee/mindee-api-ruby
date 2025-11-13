# frozen_string_literal: true

require 'mindee'
require 'json'
require_relative '../../http/mock_http_response'

describe Mindee::HTTP::ErrorHandler do
  context 'An HTTP call' do
    it 'should make an invalid API sync parse call raising an exception' do
      mindee_client1 = Mindee::Client.new(api_key: 'invalid-api-key')
      file = File.open("#{FILE_TYPES_DIR}/receipt.jpg", 'rb')
      input_source = mindee_client1.source_from_file(file, 'receipt.jpg')
      doc_class = Mindee::Product::Receipt::ReceiptV5
      expect do
        mindee_client1.parse(input_source, doc_class, options: { all_words: false, close_file: true })
      end.to raise_error Mindee::Errors::MindeeHTTPClientError
    end

    it 'should make an invalid API async enqueue call raising an exception' do
      mindee_client1 = Mindee::Client.new(api_key: 'invalid-api-key')
      file = File.open("#{V1_DATA_DIR}/products/invoice_splitter/default_sample.pdf", 'rb')
      input_source = mindee_client1.source_from_file(file, 'default_sample.pdf')
      doc_class = Mindee::Product::Invoice::InvoiceV4
      expect do
        mindee_client1.enqueue(input_source, doc_class)
      end.to raise_error Mindee::Errors::MindeeHTTPClientError
    end

    it 'should make an invalid API async parse call raising an exception' do
      mindee_client1 = Mindee::Client.new(api_key: 'invalid-api-key')
      doc_class = Mindee::Product::InvoiceSplitter::InvoiceSplitterV1
      expect do
        mindee_client1.parse_queued('invalid-job-id', doc_class)
      end.to raise_error Mindee::Errors::MindeeHTTPClientError
    end
  end
end
