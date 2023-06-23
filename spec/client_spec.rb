# frozen_string_literal: true

require 'mindee'

require_relative 'data'

describe Mindee::Client do
  context 'A client' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')

    it 'should open PDF files from a path' do
      doc = mindee_client.doc_from_path("#{DATA_DIR}/invoice/invoice.pdf")
      expect(doc).to respond_to(:read_document)
      doc = mindee_client.doc_from_path("#{DATA_DIR}/invoice/invoice_10p.pdf")
      expect(doc).to respond_to(:read_document)
    end

    it 'should open PDF files from a file handle' do
      file = File.open("#{DATA_DIR}/invoice/invoice_10p.pdf", 'rb')
      doc = mindee_client.doc_from_file(file, 'invoice_10p.pdf')
      expect(doc).to respond_to(:read_document)
    end

    it 'should open PDF files from raw bytes' do
      file_data = File.binread("#{DATA_DIR}/invoice/invoice_10p.pdf")
      doc = mindee_client.doc_from_bytes(file_data, 'invoice_10p.pdf')
      expect(doc).to respond_to(:read_document)
    end

    it 'should open PDF files from a base64 string' do
      file_data = File.read("#{DATA_DIR}/invoice/invoice_10p.txt")
      doc = mindee_client.doc_from_b64string(file_data, 'invoice_10p.txt')
      expect(doc).to respond_to(:read_document)
    end

    it 'should open JPG files from a path' do
      doc = mindee_client.doc_from_path("#{DATA_DIR}/receipt/receipt.jpg")
      expect(doc).to respond_to(:read_document)
      doc = mindee_client.doc_from_path("#{DATA_DIR}/receipt/receipt.jpga")
      expect(doc).to respond_to(:read_document)
    end

    it 'should open JPG files from a file handle' do
      file = File.open("#{DATA_DIR}/receipt/receipt.jpg", 'rb')
      doc = mindee_client.doc_from_file(file, 'receipt.jpg')
      expect(doc).to respond_to(:read_document)
    end

    it 'should open JPG files from raw bytes' do
      file_data = File.binread("#{DATA_DIR}/receipt/receipt.jpg")
      doc = mindee_client.doc_from_bytes(file_data, 'receipt.jpg')
      expect(doc).to respond_to(:read_document)
    end

    it 'should not open an invalid file' do
      expect do
        mindee_client.doc_from_path('/tmp/i-dont-exist')
      end.to raise_error Errno::ENOENT
    end

    it 'should make an invalid API sync parse call raising an exception' do
      mindee_client1 = Mindee::Client.new(api_key: 'invalid-api-key')
      file = File.open("#{DATA_DIR}/receipt/receipt.jpg", 'rb')
      doc = mindee_client1.doc_from_file(file, 'receipt.jpg')
      endpoint = mindee_client1.create_endpoint(Mindee::Product::Receipt::ReceiptV4)
      expect do
        mindee_client1.parse(doc, endpoint, all_words: false, close_file: true)
      end.to raise_error Mindee::Parsing::Common::HttpError
    end

    it 'should make an invalid API async enqueue call raising an exception' do
      mindee_client1 = Mindee::Client.new(api_key: 'invalid-api-key')
      file = File.open("#{DATA_DIR}/invoice_splitter/2_invoices.pdf", 'rb')
      doc = mindee_client1.doc_from_file(file, '2_invoices.pdf')
      endpoint = mindee_client1.create_endpoint(Mindee::Product::InvoiceSplitter::InvoiceSplitterV1)
      expect do
        mindee_client1.enqueue(doc, endpoint)
      end.to raise_error Mindee::Parsing::Common::HttpError
    end

    it 'should make an invalid API async parse call raising an exception' do
      mindee_client1 = Mindee::Client.new(api_key: 'invalid-api-key')
      endpoint = mindee_client1.create_endpoint(Mindee::Product::InvoiceSplitter::InvoiceSplitterV1)
      expect do
        mindee_client1.parse_queued('invalid-job-id', endpoint)
      end.to raise_error Mindee::Parsing::Common::HttpError
    end
  end
end
