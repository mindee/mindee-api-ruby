# frozen_string_literal: true

require 'mindee'
require 'json'
require_relative '../../http/mock_http_response'

describe Mindee::HTTP::ErrorHandler do
  context 'An HTTP call' do
    # NOTE: No reliable UT each HTTP error for ruby as the only semi-reliable http mock lib (Webmock) isn't compatible
    # with multipart/form-data yet
    # TODO: fix when this is patched: https://github.com/bblimke/webmock/pull/791

    it 'should fail on a 400 response with object' do
      file = File.read("#{V1_DATA_DIR}/errors/error_400_no_details.json")
      error_obj = MockHTTPResponse.new('1.0', '400', 'Some scary message here', file)
      error400 = Mindee::HTTP::ErrorHandler.handle_error('dummy-url', error_obj)
      expect do
        raise error400
      end.to raise_error Mindee::Errors::MindeeHTTPClientError
      expect(error400.status_code).to eq(400)
      expect(error400.api_code).to eq('SomeCode')
      expect(error400.api_message).to eq('Some scary message here')
      expect(error400.api_details).to be(nil)
    end

    it 'should fail on a 401 response with object' do
      file = File.read("#{V1_DATA_DIR}/errors/error_401_invalid_token.json")
      error_obj = MockHTTPResponse.new('1.0', '401', 'Authorization required', file)
      error401 = Mindee::HTTP::ErrorHandler.handle_error('dummy-url', error_obj)
      expect do
        raise error401
      end.to raise_error Mindee::Errors::MindeeHTTPClientError
      expect(error401.status_code).to eq(401)
      expect(error401.api_code).to eq('Unauthorized')
      expect(error401.api_message).to eq('Authorization required')
      expect(error401.api_details).to eq('Invalid token provided')
    end

    it 'should fail on a 429 response with object' do
      file = File.read("#{V1_DATA_DIR}/errors/error_429_too_many_requests.json")
      error_obj = MockHTTPResponse.new('1.0', '429', 'Too many requests', file)
      error429 = Mindee::HTTP::ErrorHandler.handle_error('dummy-url', error_obj)
      expect do
        raise error429
      end.to raise_error Mindee::Errors::MindeeHTTPClientError
      expect(error429.status_code).to eq(429)
      expect(error429.api_code).to eq('TooManyRequests')
      expect(error429.api_message).to eq('Too many requests')
      expect(error429.api_details).to eq('Too Many Requests.')
    end

    it 'should fail on a 500 response with object' do
      file = File.read("#{V1_DATA_DIR}/errors/error_500_inference_fail.json")
      error_obj = MockHTTPResponse.new('1.0', '500', 'Inference failed', file)
      error500 = Mindee::HTTP::ErrorHandler.handle_error('dummy-url', error_obj)
      expect do
        raise error500
      end.to raise_error Mindee::Errors::MindeeHTTPServerError
      expect(error500.status_code).to eq(500)
      expect(error500.api_code).to eq('failure')
      expect(error500.api_message).to eq('Inference failed')
      expect(error500.api_details).to eq('Can not run prediction: ')
    end

    it 'should fail on a 500 HTML response' do
      file = File.read("#{V1_DATA_DIR}/errors/error_50x.html")
      error_obj = MockHTTPResponse.new('1.0', '500', '', file)
      error500 = Mindee::HTTP::ErrorHandler.handle_error('dummy-url', error_obj)
      expect do
        raise error500
      end.to raise_error Mindee::Errors::MindeeHTTPServerError
      expect(error500.status_code).to eq(500)
      expect(error500.api_code).to eq('UnknownError')
      expect(error500.api_message).to eq('Server sent back an unexpected reply.')
      expect(error500.api_details).to eq(file.to_s)
    end

    it 'should fail on a 200 success but job failed' do
      file = File.read("#{V1_DATA_DIR}/async/get_failed_job_error.json")
      error_obj = MockHTTPResponse.new('1.0', '200', 'success', file)
      hashed_obj = JSON.parse(error_obj.body)
      expect(error_obj.code.to_i).to eq(200)
      expect(hashed_obj.dig('job', 'status')).to eq('failed')
      expect(Mindee::HTTP::ResponseValidation.valid_async_response?(error_obj)).to be(false)
      Mindee::HTTP::ResponseValidation.clean_request! error_obj
      error500 = Mindee::HTTP::ErrorHandler.handle_error('dummy-url', error_obj)
      expect do
        raise error500
      end.to raise_error Mindee::Errors::MindeeHTTPServerError
      expect(error500.status_code).to eq(500)
      expect(error500.api_code).to eq('ServerError')
      expect(error500.api_message).to eq('An error occurred')
      expect(error500.api_details).to eq('An error occurred')
    end
  end
end
