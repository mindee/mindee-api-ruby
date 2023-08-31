# frozen_string_literal: true

require 'json'
require 'mindee'
require_relative 'data'
DIR_ASYNC = File.join(DATA_DIR, 'async').freeze

describe Mindee::Parsing::Common::ApiResponse do
  context 'An async request' do
    it 'should be able to be sent' do
      response = load_json(DIR_ASYNC, 'post_success.json')
      parsed_response = Mindee::Parsing::Common::ApiResponse.new(Mindee::Product::InvoiceSplitter::InvoiceSplitterV1,
                                                                 response, response)
      expect(parsed_response.job.status).to eq(Mindee::Parsing::Common::JobStatus::WAITING)
      expect(parsed_response.job.id).to eq('76c90710-3a1b-4b91-8a39-31a6543e347c')
      expect(parsed_response.job.status).to_not respond_to(:available_at)
      expect(parsed_response.job.status).to_not respond_to(:millisecs_taken)
      expect(parsed_response.api_request.error).to eq({})
      expect(parsed_response.raw_http).to eq(response)
    end

    it 'should not be able to be sent on incompatible endpoints' do
      response = load_json(DIR_ASYNC, 'post_fail_forbidden.json')
      parsed_response = Mindee::Parsing::Common::ApiResponse.new(Mindee::Product::InvoiceSplitter::InvoiceSplitterV1,
                                                                 response, response)
      expect(parsed_response.job.status).to be(nil)
      expect(parsed_response.job.id).to be(nil)
      expect(parsed_response.job.status).to_not respond_to(:available_at)
      expect(parsed_response.job.status).to_not respond_to(:millisecs_taken)
      expect(parsed_response.api_request.status).to eq(Mindee::Parsing::Common::RequestStatus::FAILURE)
      expect(parsed_response.api_request.error['code']).to eq('Forbidden')
      expect(parsed_response.raw_http).to eq(response)
    end

    it 'should be able to poll processing a queue' do
      response = load_json(DIR_ASYNC, 'get_processing.json')
      parsed_response = Mindee::Parsing::Common::ApiResponse.new(Mindee::Product::InvoiceSplitter::InvoiceSplitterV1,
                                                                 response, response)
      expect(parsed_response.job.issued_at.strftime('%Y-%m-%dT%H:%M:%S.%6N')).to eq('2023-03-16T12:33:49.602947')
      expect(parsed_response.job.status).to eq(Mindee::Parsing::Common::JobStatus::PROCESSING)
      expect(parsed_response.job.id).to eq('76c90710-3a1b-4b91-8a39-31a6543e347c')
      expect(parsed_response.job.status).to_not respond_to(:available_at)
      expect(parsed_response.job.status).to_not respond_to(:millisecs_taken)
      expect(parsed_response.api_request.error['code']).to eq(nil)
      expect(parsed_response.raw_http).to eq(response)
    end

    it 'should be able to poll a completed queue' do
      response = load_json(DIR_ASYNC, 'get_completed.json')
      parsed_response = Mindee::Parsing::Common::ApiResponse.new(Mindee::Product::InvoiceSplitter::InvoiceSplitterV1,
                                                                 response, response)
      expect(parsed_response.job.issued_at.strftime('%Y-%m-%dT%H:%M:%S.%6N')).to eq('2023-03-21T13:52:56.326107')
      expect(parsed_response.job.status).to eq(Mindee::Parsing::Common::JobStatus::COMPLETED)
      expect(parsed_response.job.id).to eq('b6caf9e8-9bcc-4412-bcb7-f5b416678f0d')
      expect(parsed_response.job.available_at.strftime('%Y-%m-%dT%H:%M:%S.%6N')).to eq('2023-03-21T13:53:00.990339')
      expect(parsed_response.job.millisecs_taken).to eq(4664)
      expect(parsed_response.document).to_not be(nil)
      expect(parsed_response.api_request.error['code']).to eq(nil)
      expect(parsed_response.raw_http).to eq(response)
    end
  end
end
