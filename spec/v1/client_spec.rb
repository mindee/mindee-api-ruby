# frozen_string_literal: true

require 'mindee'

require_relative '../data'

describe Mindee::Client do
  context 'A client' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')

    it 'should open PDF files from a path' do
      input_source = mindee_client.source_from_path("#{V1_DATA_DIR}/products/invoices/invoice.pdf")
      expect(input_source).to respond_to(:read_contents)
      input_source = mindee_client.source_from_path("#{V1_DATA_DIR}/products/invoices/invoice_10p.pdf")
      expect(input_source).to respond_to(:read_contents)
    end

    it 'should open PDF files from a file handle' do
      file = File.open("#{V1_DATA_DIR}/products/invoices/invoice_10p.pdf", 'rb')
      input_source = mindee_client.source_from_file(file, 'invoice_10p.pdf')
      expect(input_source).to respond_to(:read_contents)
    end

    it 'should open PDF files from raw bytes' do
      file_data = File.binread("#{V1_DATA_DIR}/products/invoices/invoice_10p.pdf")
      input_source = mindee_client.source_from_bytes(file_data, 'invoice_10p.pdf')
      expect(input_source).to respond_to(:read_contents)
    end

    it 'should open PDF files from a base64 string' do
      file_data = File.read("#{V1_DATA_DIR}/products/invoices/invoice_10p.txt")
      input_source = mindee_client.source_from_b64string(file_data, 'invoice_10p.txt')
      expect(input_source).to respond_to(:read_contents)
    end

    it 'should open JPG files from a path' do
      input_source = mindee_client.source_from_path("#{FILE_TYPES_DIR}/receipt.jpg")
      expect(input_source).to respond_to(:read_contents)
      input_source = mindee_client.source_from_path("#{FILE_TYPES_DIR}/receipt.jpga")
      expect(input_source).to respond_to(:read_contents)
    end

    it 'should open JPG files from a file handle' do
      file = File.open("#{FILE_TYPES_DIR}/receipt.jpg", 'rb')
      input_source = mindee_client.source_from_file(file, 'receipt.jpg')
      expect(input_source).to respond_to(:read_contents)
    end

    it 'should open JPG files from raw bytes' do
      file_data = File.binread("#{FILE_TYPES_DIR}/receipt.jpg")
      input_source = mindee_client.source_from_bytes(file_data, 'receipt.jpg')
      expect(input_source).to respond_to(:read_contents)
    end

    it 'should not open an invalid file' do
      expect do
        mindee_client.source_from_path('/tmp/i-dont-exist')
      end.to raise_error Errno::ENOENT
    end

    it 'should load a local response' do
      local_resp = Mindee::Input::LocalResponse.new("#{V1_DATA_DIR}/products/invoices/response_v4/complete.json")
      mindee_client.load_prediction(Mindee::Product::Invoice::InvoiceV4, local_resp)
      expect(mindee_client).to_not be_nil
    end

    it 'should not load an invalid local response' do
      local_resp = Mindee::Input::LocalResponse.new("#{V1_DATA_DIR}/geometry/polygon.json")
      expect do
        mindee_client.load_prediction(Mindee::Product::Invoice::InvoiceV4, local_resp)
      end.to raise_error Mindee::Errors::MindeeInputError
    end

    it 'should not validate improper async parameters' do
      file_data = File.binread("#{FILE_TYPES_DIR}/receipt.jpg")
      input_source = mindee_client.source_from_bytes(file_data, 'receipt.jpg')
      expect do
        mindee_client.parse(
          input_source,
          Mindee::Product::Invoice::InvoiceV4,
          options: { max_retries: 0 }
        )
      end.to raise_error ArgumentError
      expect do
        mindee_client.parse(
          input_source,
          Mindee::Product::Invoice::InvoiceV4,
          options: { initial_delay_sec: 0.5 }
        )
      end.to raise_error ArgumentError
      expect do
        mindee_client.parse(
          input_source,
          Mindee::Product::Invoice::InvoiceV4,
          options: { delay_sec: 0.5 }
        )
      end.to raise_error ArgumentError
    end

    it 'should not initialize an invalid endpoint' do
      expect do
        mindee_client.send(
          :initialize_endpoint,
          Mindee::Product::Universal::Universal,
          endpoint_name: '',
          account_name: 'account_name',
          version: 'version'
        )
      end.to raise_error Mindee::Errors::MindeeConfigurationError

      expect do
        mindee_client.send(
          :initialize_endpoint,
          Mindee::Product::Universal::Universal,
          endpoint_name: '',
          account_name: 'account_name',
          version: 'version'
        )
      end.to raise_error Mindee::Errors::MindeeConfigurationError
    end
  end
end
