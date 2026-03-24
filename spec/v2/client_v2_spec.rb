# frozen_string_literal: true

require 'json'
require 'mindee'
require 'mindee/v2/product'
require_relative '../http/mock_http_response' # <- the original helper

using Mindee::V2::Product::Extraction::Params
using Mindee::V2::Product::Extraction

describe Mindee::ClientV2 do
  let(:input_doc)      { Mindee::Input::Source::PathInputSource.new(File.join(FILE_TYPES_DIR, 'pdf', 'blank.pdf')) }
  let(:base_url)       { 'https://dummy-url' }
  let(:api_key)        { 'dummy-api-key' }

  let(:client) do
    ENV['MINDEE_V2_BASE_URL'] = 'https://dummy-url'
    Mindee::ClientV2.new(api_key: api_key)
  end
  let(:api) do
    client.instance_variable_get(:@mindee_api)
  end

  let(:json400) do
    {
      status: 400,
      detail: 'Unsupported content.',
    }
  end

  def build_mock_http_response(hash, status_code = 400, status_msg = 'Bad Request')
    MockHTTPResponse.new('1.1', status_code.to_s, status_msg, hash)
  end

  def stub_next_request_with(method, hash:, status_code: 0)
    fake_response = build_mock_http_response(hash, status_code)
    allow_any_instance_of(Mindee::HTTP::MindeeApiV2)
      .to receive(method)
      .and_return(fake_response)
  end

  it 'inherits base URL, token & headers from the env / options' do
    settings = api.settings

    expect(settings.base_url).to eq(base_url)
    expect(settings.api_key).to eq(api_key)
  end

  it 'enqueue(path) raises MindeeHTTPErrorV2 on 4xx' do
    expect do
      stub_next_request_with(:enqueue, hash: JSON.generate(json400))
      params = Mindee::V2::Product::Extraction::Params::ExtractionParameters.new(
        'dummy-model',
        raw_text: false,
        text_context: 'Hello my name is mud.'
      )
      client.enqueue(Mindee::V2::Product::Extraction::Extraction, input_doc, params)
    end.to raise_error(Mindee::Errors::MindeeHTTPErrorV2) { |e|
      expect(e.status).to eq(400)
      expect(e.detail).to eq('Unsupported content.')
    }
  end

  it 'enqueue_and_get_inference(path) raises MindeeHTTPErrorV2 on 4xx' do
    expect do
      stub_next_request_with(:enqueue, hash: JSON.generate(json400))
      params = Mindee::V2::Product::Extraction::Params::ExtractionParameters.new('dummy-model')
      client.enqueue_and_get_result(Mindee::V2::Product::Extraction::Extraction, input_doc, params)
    end.to raise_error(Mindee::Errors::MindeeHTTPErrorV2) { |e|
      expect(e.status).to eq(400)
      expect(e.detail).to eq('Unsupported content.')
    }
  end

  it 'bubbles-up HTTP errors with details' do
    error_hash = json400.merge({ status: 413, detail: 'File exceeds size limit' })

    expect do
      stub_next_request_with(:enqueue, hash: JSON.generate(error_hash))
      params = Mindee::V2::Product::Extraction::Params::ExtractionParameters.new('dummy-model')
      client.enqueue(Mindee::V2::Product::Extraction::Extraction, input_doc, params)
    end.to raise_error(Mindee::Errors::MindeeHTTPErrorV2) { |e|
      expect(e.status).to eq(413)
      expect(e.detail).to include('File exceeds size limit')
    }
  end

  it 'get_job(job_id) returns a fully-formed JobResponse' do
    json_path = File.join(V2_DATA_DIR, 'job', 'ok_processing.json')
    parsed = File.read(json_path)
    stub_next_request_with(:poll, hash: parsed, status_code: 200)

    resp = client.get_job('123e4567-e89b-12d3-a456-426614174000')
    expect(resp).to be_a(Mindee::V2::Parsing::JobResponse)
    expect(resp.raw_http).to eq(JSON.generate(JSON.parse(parsed)))
    expect(resp.job.status).to eq('Processing')
    expect(
      resp.job.created_at.strftime('%Y-%m-%dT%H:%M:%S.%6N')
    ).to eq('2025-07-03T14:27:58.974451')
    expect(resp.job.completed_at).to be_nil
  end

  it 'should deserialize a job properly' do
    json_path = File.join(V2_DATA_DIR, 'job', 'ok_processed_webhooks_ok.json')
    parsed = File.read(json_path)
    stub_next_request_with(:poll, hash: parsed, status_code: 200)

    resp = client.get_job('123e4567-e89b-12d3-a456-426614174000')
    expect(resp).to be_a(Mindee::V2::Parsing::JobResponse)
    expect(resp.raw_http).to eq(JSON.generate(JSON.parse(parsed)))
    expect(resp.job.status).to eq('Processed')
    expect(resp.job.model_id).to eq('87654321-4321-4321-4321-CBA987654321')
    expect(resp.job.filename).to eq('default_sample.jpg')
    expect(resp.job.alias).to eq('dummy-alias.jpg')
    expect(
      resp.job.created_at.strftime('%Y-%m-%dT%H:%M:%S.%6N')
    ).to eq('2026-04-20T18:27:58.974451')
    expect(
      resp.job.completed_at.strftime('%Y-%m-%dT%H:%M:%S.%6N')
    ).to eq('2026-04-20T18:32:02.734312')
  end
  ENV.delete('MINDEE_V2_BASE_URL')
end
