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
  it 'formats auth API errors as a CLI credential message' do
    cli_parser = described_class.new(['search-models'])
    error = Mindee::Error::MindeeHTTPErrorV2.new(
      {
        'status' => 401,
        'title' => 'Missing credentials',
        'code' => '401-008',
        'detail' => 'Credentials are required.',
        'errors' => [],
      }
    )
    allow(cli_parser).to receive(:validate_command!)
    allow(cli_parser).to receive(:print_result).and_raise(error)

    expect(cli_parser).to receive(:abort).with(
      "CLI error: Missing credentials. Provide an API key using '--key' or " \
      "the 'MINDEE_V2_API_KEY' environment variable."
    ).and_raise(SystemExit.new(1))

    expect { cli_parser.execute }.to raise_error(SystemExit)
  end

  it 'prefixes generic Mindee errors as CLI errors' do
    cli_parser = described_class.new(['search-models'])
    allow(cli_parser).to receive(:validate_command!)
    allow(cli_parser).to receive(:print_result).and_raise(Mindee::Error::MindeeAPIError, 'boom')

    expect(cli_parser).to receive(:abort).with('CLI error: boom').and_raise(SystemExit.new(1))

    expect { cli_parser.execute }.to raise_error(SystemExit)
  end
end
