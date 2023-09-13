# frozen_string_literal: true

require 'mindee'

require_relative 'data'

describe Mindee::Client do
  context 'A client' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')

    it 'should open PDF files from a path' do
      input_source = mindee_client.source_from_path("#{DATA_DIR}/products/invoices/invoice.pdf")
      expect(input_source).to respond_to(:read_document)
      input_source = mindee_client.source_from_path("#{DATA_DIR}/products/invoices/invoice_10p.pdf")
      expect(input_source).to respond_to(:read_document)
    end

    it 'should open PDF files from a file handle' do
      file = File.open("#{DATA_DIR}/products/invoices/invoice_10p.pdf", 'rb')
      input_source = mindee_client.source_from_file(file, 'invoice_10p.pdf')
      expect(input_source).to respond_to(:read_document)
    end

    it 'should open PDF files from raw bytes' do
      file_data = File.binread("#{DATA_DIR}/products/invoices/invoice_10p.pdf")
      input_source = mindee_client.source_from_bytes(file_data, 'invoice_10p.pdf')
      expect(input_source).to respond_to(:read_document)
    end

    it 'should open PDF files from a base64 string' do
      file_data = File.read("#{DATA_DIR}/products/invoices/invoice_10p.txt")
      input_source = mindee_client.source_from_b64string(file_data, 'invoice_10p.txt')
      expect(input_source).to respond_to(:read_document)
    end

    it 'should open JPG files from a path' do
      input_source = mindee_client.source_from_path("#{DATA_DIR}/file_types/receipt.jpg")
      expect(input_source).to respond_to(:read_document)
      input_source = mindee_client.source_from_path("#{DATA_DIR}/file_types/receipt.jpga")
      expect(input_source).to respond_to(:read_document)
    end

    it 'should open JPG files from a file handle' do
      file = File.open("#{DATA_DIR}/file_types/receipt.jpg", 'rb')
      input_source = mindee_client.source_from_file(file, 'receipt.jpg')
      expect(input_source).to respond_to(:read_document)
    end

    it 'should open JPG files from raw bytes' do
      file_data = File.binread("#{DATA_DIR}/file_types/receipt.jpg")
      input_source = mindee_client.source_from_bytes(file_data, 'receipt.jpg')
      expect(input_source).to respond_to(:read_document)
    end

    it 'should not open an invalid file' do
      expect do
        mindee_client.source_from_path('/tmp/i-dont-exist')
      end.to raise_error Errno::ENOENT
    end
  end

  context 'A broken fixable PDF' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')
    it 'Should not raise a mime error' do
      expect do
        mindee_client.source_from_path("#{DATA_DIR}/file_types/pdf/broken_fixable.pdf", fix_pdf: true)
      end.not_to raise_error
    end
  end

  context 'A broken unfixable PDF' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')
    it 'Should raise an error' do
      expect do 
        mindee_client.source_from_path("#{DATA_DIR}/file_types/pdf/broken_unfixable.pdf", fix_pdf: true)
      end.to raise_error Mindee::Input::Source::UnfixablePDFError
    end
  end

  context 'A broken fixable invoice PDF' do
    mindee_client_valid = Mindee::Client.new()
    it 'Should send correct results' do
      source_doc_original = mindee_client_valid.source_from_path("#{DATA_DIR}/products/invoices/invoice.pdf")
      expect do 
        source_doc_fixed = mindee_client_valid.source_from_path("#{DATA_DIR}/file_types/pdf/broken_invoice.pdf", fix_pdf: true)
        result_original = mindee_client_valid.parse(source_doc_original, Mindee::Product::Invoice::InvoiceV4)
        result_fixed = mindee_client_valid.parse(source_doc_fixed, Mindee::Product::Invoice::InvoiceV4)
        expect(result_fixed.document.inference.to_s).to eq(result_original.document.inference.to_s)
      end.not_to raise_error
    end
  end
end
