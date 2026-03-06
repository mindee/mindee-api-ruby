# frozen_string_literal: true

require 'mindee'
require 'mindee/v2/parsing/job_webhook'

describe Mindee::V2::Parsing::JobWebhook do
  describe '#initialize' do
    context 'when error key is present but value is nil' do
      it 'does not raise an error and sets @error to nil' do
        server_response = {
          'id' => '12345678-1234-1234-1234-123456789012',
          'status' => 'Processing',
          'error' => nil,
        }

        webhook = described_class.new(server_response)

        expect(webhook.id).to eq('12345678-1234-1234-1234-123456789012')
        expect(webhook.status).to eq('Processing')
        expect(webhook.error).to be_nil
      end
    end

    context 'when error key is absent' do
      it 'does not raise an error and sets @error to nil' do
        server_response = {
          'id' => '12345678-1234-1234-1234-123456789012',
          'status' => 'Processing',
        }

        webhook = described_class.new(server_response)

        expect(webhook.id).to eq('12345678-1234-1234-1234-123456789012')
        expect(webhook.status).to eq('Processing')
        expect(webhook.error).to be_nil
      end
    end

    context 'when error key is present with valid error data' do
      it 'creates an ErrorResponse object' do
        server_response = {
          'id' => '12345678-1234-1234-1234-123456789012',
          'status' => 'Failed',
          'error' => {
            'status' => 500,
            'detail' => 'Internal server error',
            'title' => 'Server Error',
            'code' => 'INTERNAL_ERROR',
          },
        }

        webhook = described_class.new(server_response)

        expect(webhook.id).to eq('12345678-1234-1234-1234-123456789012')
        expect(webhook.status).to eq('Failed')
        expect(webhook.error).to be_a(Mindee::V2::Parsing::ErrorResponse)
        expect(webhook.error.status).to eq(500)
        expect(webhook.error.detail).to eq('Internal server error')
      end
    end
  end
end
