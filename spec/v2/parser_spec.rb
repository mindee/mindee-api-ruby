# frozen_string_literal: true

require 'json'
require_relative '../../bin/v2/parser'

describe MindeeCLI::V2Parser do
  subject(:parser) { described_class.new([]) }

  it 'keeps already parsed raw payloads unchanged' do
    payload = { 'api_request' => { 'status' => 'success' } }
    expect(parser.__send__(:raw_payload, payload)).to eq(payload)
  end

  it 'parses JSON string payloads' do
    payload = { 'api_request' => { 'status' => 'success' } }
    expect(parser.__send__(:raw_payload, JSON.generate(payload))).to eq(payload)
  end

  it 'parses double-encoded JSON string payloads once more' do
    payload = { 'api_request' => { 'status' => 'success' } }
    double_encoded = JSON.generate(JSON.generate(payload))
    expect(parser.__send__(:raw_payload, double_encoded)).to eq(payload)
  end
end
