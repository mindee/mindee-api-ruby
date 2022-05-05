# frozen_string_literal: true

require 'mindee/client'

DATA_DIR = File.join(__dir__, 'data').freeze

describe Mindee::Client do
  context 'With a valid client' do
    mindee_client = Mindee::Client.new

    it 'should be configurable' do
      mindee_client.config_invoice('invalid-api-key')
                   .config_receipt('invalid-api-key')
                   .config_passport('invalid-api-key')
    end

    it 'should open PDF files from a path' do
      mindee_client.doc_from_path("#{DATA_DIR}/invoices/invoice.pdf")
      mindee_client.doc_from_path("#{DATA_DIR}/invoices/invoice_10p.pdf")
    end

    it 'should open PDF files from a file handle' do
      file = File.open("#{DATA_DIR}/invoices/invoice_10p.pdf", 'rb')
      mindee_client.doc_from_file(file, 'invoice_10p.pdf')
    end

    it 'should open PDF files from raw bytes' do
      filedata = File.binread("#{DATA_DIR}/invoices/invoice_10p.pdf")
      mindee_client.doc_from_bytes(filedata, 'invoice_10p.pdf')
    end

    it 'should open PDF files from a base64 string' do
      filedata = File.read("#{DATA_DIR}/invoices/invoice_10p.txt")
      mindee_client.doc_from_b64string(filedata, 'invoice_10p.txt')
    end

    it 'should open JPG files from a path' do
      mindee_client.doc_from_path("#{DATA_DIR}/receipts/receipt.jpg")
      mindee_client.doc_from_path("#{DATA_DIR}/receipts/receipt.jpga")
    end

    it 'should open JPG files from a file handle' do
      file = File.open("#{DATA_DIR}/receipts/receipt.jpg", 'rb')
      mindee_client.doc_from_file(file, 'receipt.jpg')
    end

    it 'should open JPG files from raw bytes' do
      filedata = File.binread("#{DATA_DIR}/receipts/receipt.jpg")
      mindee_client.doc_from_bytes(filedata, 'receipt.jpg')
    end
  end
end
