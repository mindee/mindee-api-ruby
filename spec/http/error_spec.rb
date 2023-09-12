# frozen_string_literal: true

require 'mindee'
require 'json'

describe Mindee::HTTP::Error do
  context 'An HTTP call' do
    it 'should make an invalid API sync parse call raising an exception' do
      mindee_client1 = Mindee::Client.new(api_key: 'invalid-api-key')
      file = File.open("#{DATA_DIR}/file_types/receipt.jpg", 'rb')
      input_source = mindee_client1.source_from_file(file, 'receipt.jpg')
      doc_class = Mindee::Product::Receipt::ReceiptV5
      expect do
        mindee_client1.parse(input_source, doc_class, all_words: false, close_file: true)
      end.to raise_error Mindee::HTTP::Error::MindeeHttpClientError
    end

    it 'should make an invalid API async enqueue call raising an exception' do
      mindee_client1 = Mindee::Client.new(api_key: 'invalid-api-key')
      file = File.open("#{DATA_DIR}/products/invoice_splitter/default_sample.pdf", 'rb')
      input_source = mindee_client1.source_from_file(file, 'default_sample.pdf')
      doc_class = Mindee::Product::Invoice::InvoiceV4
      expect do
        mindee_client1.enqueue(input_source, doc_class)
      end.to raise_error Mindee::HTTP::Error::MindeeHttpClientError
    end

    it 'should make an invalid API async parse call raising an exception' do
      mindee_client1 = Mindee::Client.new(api_key: 'invalid-api-key')
      doc_class = Mindee::Product::InvoiceSplitter::InvoiceSplitterV1
      expect do
        mindee_client1.parse_queued('invalid-job-id', doc_class)
      end.to raise_error Mindee::HTTP::Error::MindeeHttpClientError
    end

    # NOTE: No reliable UT each HTTP errorfor ruby as the only semi-reliable http mock lib (Webmock) isn't compatible
    # with multipart/form-data yet
    # TODO: fix when this is patched: https://github.com/bblimke/webmock/pull/791

    it 'should fail on a 400 response with object' do
      file = File.read("#{DATA_DIR}/errors/error_400_no_details.json")
      error_obj = JSON.parse(file)
      error400 = Mindee::HTTP::Error.handle_error!('dummy-url', error_obj, 400)
      expect do
        raise error400
      end.to raise_error Mindee::HTTP::Error::MindeeHttpClientError
      expect(error400.status_code).to eq(400)
      expect(error400.api_code).to eq('SomeCode')
      expect(error400.api_message).to eq('Some scary message here')
      expect(error400.api_details).to be(nil)
    end

    it 'should fail on a 401 response with object' do
      file = File.read("#{DATA_DIR}/errors/error_401_invalid_token.json")
      error_obj = JSON.parse(file)
      error401 = Mindee::HTTP::Error.handle_error!('dummy-url', error_obj, 401)
      expect do
        raise error401
      end.to raise_error Mindee::HTTP::Error::MindeeHttpClientError
      expect(error401.status_code).to eq(401)
      expect(error401.api_code).to eq('Unauthorized')
      expect(error401.api_message).to eq('Authorization required')
      expect(error401.api_details).to eq('Invalid token provided')
    end

    it 'should fail on a 429 response with object' do
      file = File.read("#{DATA_DIR}/errors/error_429_too_many_requests.json")
      error_obj = JSON.parse(file)
      error429 = Mindee::HTTP::Error.handle_error!('dummy-url', error_obj, 429)
      expect do
        raise error429
      end.to raise_error Mindee::HTTP::Error::MindeeHttpClientError
      expect(error429.status_code).to eq(429)
      expect(error429.api_code).to eq('TooManyRequests')
      expect(error429.api_message).to eq('Too many requests')
      expect(error429.api_details).to eq('Too Many Requests.')
    end

    it 'should fail on a 500 response with object' do
      file = File.read("#{DATA_DIR}/errors/error_500_inference_fail.json")
      error_obj = JSON.parse(file)
      error500 = Mindee::HTTP::Error.handle_error!('dummy-url', error_obj, 500)
      expect do
        raise error500
      end.to raise_error Mindee::HTTP::Error::MindeeHttpServerError
      expect(error500.status_code).to eq(500)
      expect(error500.api_code).to eq('failure')
      expect(error500.api_message).to eq('Inference failed')
      expect(error500.api_details).to eq('Can not run prediction: ')
    end

    it 'should fail on a 500 HTML response' do
      file = File.read("#{DATA_DIR}/errors/error_50x.html")
      error_obj = file
      error500 = Mindee::HTTP::Error.handle_error!('dummy-url', error_obj, 500)
      expect do
        raise error500
      end.to raise_error Mindee::HTTP::Error::MindeeHttpServerError
      expect(error500.status_code).to eq(500)
      expect(error500.api_code).to eq('UnknownError')
      expect(error500.api_message).to eq('Server sent back an unexpected reply.')
      expect(error500.api_details).to eq(file.to_s)
    end
  end
end
