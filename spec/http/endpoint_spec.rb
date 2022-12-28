# frozen_string_literal: true

describe Mindee::HTTP::Endpoint do
  context 'An endpoint' do
    it 'should initialize' do
      endpoint = Mindee::HTTP::Endpoint.new('mindee', 'blahblah', '3', api_key: 'invalid-key')
      expect(endpoint.request_timeout).to eq(120)
      expect(endpoint.api_key).to eq('invalid-key')
    end
  end
end