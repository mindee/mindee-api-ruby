# frozen_string_literal: true

require 'mindee'

require_relative '../data'

describe Mindee::V1::Client do
  context 'A client' do
    mindee_client = Mindee::V1::Client.new(api_key: 'invalid-api-key')

    it 'should open PDF files from a path' do
      input_source = mindee_client.source_from_path("#{V1_DATA_DIR}/products/invoices/invoice.pdf")
      expect(input_source).to respond_to(:read_contents)
      input_source = mindee_client.source_from_path("#{V1_DATA_DIR}/products/invoices/invoice_10p.pdf")
      expect(input_source).to respond_to(:read_contents)
    end

    it 'should open PDF files from a file handle' do
      File.open("#{V1_DATA_DIR}/products/invoices/invoice_10p.pdf", 'rb') do |file|
        input_source = mindee_client.source_from_file(file, 'invoice_10p.pdf')
        expect(input_source).to respond_to(:read_contents)
      end
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
      File.open("#{FILE_TYPES_DIR}/receipt.jpg", 'rb') do |file|
        input_source = mindee_client.source_from_file(file, 'receipt.jpg')
        expect(input_source).to respond_to(:read_contents)
      end
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
      mindee_client.load_prediction(Mindee::V1::Product::Invoice::InvoiceV4, local_resp)
      expect(mindee_client).to_not be_nil
    end

    it 'should not load an invalid local response' do
      local_resp = Mindee::Input::LocalResponse.new("#{V1_DATA_DIR}/geometry/polygon.json")
      expect do
        mindee_client.load_prediction(Mindee::V1::Product::Invoice::InvoiceV4, local_resp)
      end.to raise_error Mindee::Error::MindeeInputError
    end

    it 'should not validate improper async parameters' do
      file_data = File.binread("#{FILE_TYPES_DIR}/receipt.jpg")
      input_source = mindee_client.source_from_bytes(file_data, 'receipt.jpg')
      expect do
        mindee_client.parse(
          input_source,
          Mindee::V1::Product::Invoice::InvoiceV4,
          options: { max_retries: 0 }
        )
      end.to raise_error ArgumentError
      expect do
        mindee_client.parse(
          input_source,
          Mindee::V1::Product::Invoice::InvoiceV4,
          options: { initial_delay_sec: 0.5 }
        )
      end.to raise_error ArgumentError
      expect do
        mindee_client.parse(
          input_source,
          Mindee::V1::Product::Invoice::InvoiceV4,
          options: { delay_sec: 0.5 }
        )
      end.to raise_error ArgumentError
    end

    it 'should not initialize an invalid endpoint' do
      expect do
        mindee_client.send(
          :initialize_endpoint,
          Mindee::V1::Product::Universal::Universal,
          endpoint_name: '',
          account_name: 'account_name',
          version: 'version'
        )
      end.to raise_error Mindee::Error::MindeeConfigurationError

      expect do
        mindee_client.send(
          :initialize_endpoint,
          Mindee::V1::Product::Universal::Universal,
          endpoint_name: '',
          account_name: 'account_name',
          version: 'version'
        )
      end.to raise_error Mindee::Error::MindeeConfigurationError
    end
  end

  context 'Cancellation token' do
    let(:client) { Mindee::V1::Client.new(api_key: 'dummy-key') }
    let(:input_source) { Mindee::Input::Source::PathInputSource.new(File.join(FILE_TYPES_DIR, 'receipt.jpg')) }
    let(:product_class) { Mindee::V1::Product::InvoiceSplitter::InvoiceSplitterV1 }
    let(:endpoint) do
      Mindee::V1::HTTP::Endpoint.new('mindee', 'invoice_splitter_async', '1', api_key: 'dummy-key')
    end
    let(:opts) { Mindee::V1::ParseOptions.new(params: { initial_delay_sec: 2, delay_sec: 1.5, max_retries: 2 }) }

    let(:mock_enqueue_res) do
      data = load_json(V1_ASYNC_DIR, 'post_success.json')
      Mindee::V1::Parsing::Common::ApiResponse.new(product_class, data, JSON.generate(data))
    end
    let(:mock_processing_res) do
      data = load_json(V1_ASYNC_DIR, 'get_processing.json')
      Mindee::V1::Parsing::Common::ApiResponse.new(product_class, data, JSON.generate(data))
    end

    before do
      allow(client).to receive(:sleep)
      allow(client).to receive(:enqueue).and_return(mock_enqueue_res)
      allow(client).to receive(:parse_queued).and_return(mock_processing_res)
    end

    it 'raises MindeeError when token is cancelled before first poll' do
      token = Mindee::HTTP::CancellationToken.new
      token.cancel

      expect do
        client.send(:enqueue_and_parse, input_source, product_class, endpoint, opts, token)
      end.to raise_error(Mindee::Error::MindeeError, %r{canceled})
    end

    it 'raises MindeeError when token is cancelled during poll loop' do
      token = Mindee::HTTP::CancellationToken.new
      call_count = 0
      allow(client).to receive(:parse_queued) do
        call_count += 1
        token.cancel if call_count == 1
        mock_processing_res
      end

      expect do
        client.send(:enqueue_and_parse, input_source, product_class, endpoint, opts, token)
      end.to raise_error(Mindee::Error::MindeeError, %r{canceled})
    end

    it 'raises timeout error (not cancel error) when no token is passed' do
      expect do
        client.send(:enqueue_and_parse, input_source, product_class, endpoint, opts)
      end.to raise_error(Mindee::Error::MindeeAPIError, %r{timed out})
    end
  end
end
