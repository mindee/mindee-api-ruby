# frozen_string_literal: true

require 'json'
require 'mindee'
require_relative 'data'
require 'date'
DIR_INVOICE_SPLITTER_V1 = File.join(DATA_DIR, 'invoice_splitter', 'response_v1').freeze
DIR_ASYNC = File.join(DATA_DIR, 'async').freeze


describe Mindee::ApiResponse do
  context 'An' do
    it 'should be able to send a post request' do
      response = load_json(DIR_ASYNC, 'post_success.json')
      parsed_response = Mindee::ApiResponse.new(Mindee::Prediction::InvoiceSplitterV1, response)
      expect(parsed_response.job.status).to eq("waiting")
      expect(parsed_response.job.id).to eq("76c90710-3a1b-4b91-8a39-31a6543e347c")
      expect(parsed_response.api_request.error).to eq({})
    end

    it 'should not be able to send a post request on incompatible endpoints' do
      response = load_json(DIR_ASYNC, 'post_fail_forbidden.json')
      parsed_response = Mindee::ApiResponse.new(Mindee::Prediction::InvoiceSplitterV1, response)
      expect(parsed_response.job.status).to be(nil)
      expect(parsed_response.job.id).to be(nil)
      expect(parsed_response.api_request.error['code']).to eq("Forbidden")
    end

    it 'should be able to poll a queue' do
      response = load_json(DIR_ASYNC, 'get_processing.json')
      parsed_response = Mindee::ApiResponse.new(Mindee::Prediction::InvoiceSplitterV1, response)
      expect(parsed_response.job.issued_at.to_s).to eq("2023-03-16T12:33:49+00:00")
      expect(parsed_response.job.status).to eq("processing")
      expect(parsed_response.job.id).to eq("76c90710-3a1b-4b91-8a39-31a6543e347c")
      expect(parsed_response.job.status).to_not respond_to(:available_at)
      expect(parsed_response.api_request.error['code']).to eq(nil)
    end


    it 'should be able to poll a queue' do
      response = load_json(DIR_ASYNC, 'get_completed.json')
      parsed_response = Mindee::ApiResponse.new(Mindee::Prediction::InvoiceSplitterV1, response)
      expect(parsed_response.job.issued_at.to_s).to eq("2023-03-21T13:52:56+00:00")
      expect(parsed_response.job.status).to eq("completed")
      expect(parsed_response.job.id).to eq("b6caf9e8-9bcc-4412-bcb7-f5b416678f0d")
      expect(parsed_response.job.available_at.to_s).to eq("2023-03-21T13:53:00+00:00")
      expect(parsed_response.document).to_not be(nil)
      expect(parsed_response.api_request.error['code']).to eq(nil)
    end


  end
end