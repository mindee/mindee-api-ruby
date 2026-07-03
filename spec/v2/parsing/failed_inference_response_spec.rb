# frozen_string_literal: true

require 'mindee/v2/parsing'

describe Mindee::V2::Parsing::FailedInferenceResponse do
  it 'initializes' do
    json_file_path = File.join(V2_DATA_DIR, 'errors', 'webhook_error_500_failed.json')

    response = described_class.new(JSON.parse(File.read(json_file_path)))
    expect(response).not_to be_nil
    expect(response.inference_id).to eq('12345678-1234-1234-1234-123456789ABC')
    expect(response.file_name).to eq('default_sample.jpg')
    expect(response.file_alias).to eq('dummy-alias.jpg')
    expect(response.error.status).to eq(500)
    expect(response.error.code).to eq('500-012')
  end
end
