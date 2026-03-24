# frozen_string_literal: true

require 'json'
require 'mindee'
require 'mindee/v2/parsing/common_response'

describe Mindee::V2::Parsing::CommonResponse do
  it 'stores raw_http as a JSON string' do
    server_response = {
      'api_request' => { 'status' => 'success' },
      'job' => { 'status' => 'Processing' },
    }

    response = described_class.new(server_response)
    expect(response.raw_http).to be_a(String)
    expect(JSON.parse(response.raw_http)).to eq(server_response)
  end
end
