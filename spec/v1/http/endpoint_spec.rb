# frozen_string_literal: true

require 'mindee'

describe Mindee::V1::HTTP::Endpoint do
  context 'An endpoint' do
    it 'should initialize' do
      endpoint = Mindee::V1::HTTP::Endpoint.new(
        'mindee', 'blahblah', '3',
        api_key: 'invalid-key'
      )
      expect(endpoint.request_timeout).to eq(120)
      expect(endpoint.api_key).to eq('invalid-key')
    end

    it 'should have a default root url' do
      endpoint = Mindee::V1::HTTP::Endpoint.new(
        'mindee', 'blahblah', '3',
        api_key: 'invalid-key'
      )
      expect(endpoint.url_root).to eq("#{Mindee::V1::HTTP::BASE_URL_DEFAULT}/products/mindee/blahblah/v3")
    end

    it 'should have an editable root url' do
      ENV[Mindee::V1::HTTP::BASE_URL_ENV_NAME] = 'localhost:1234/my-fake-root-url'
      endpoint = Mindee::V1::HTTP::Endpoint.new(
        'mindee', 'blahblah', '3',
        api_key: 'invalid-key'
      )
      expect(endpoint.url_root).to_not eq(Mindee::V1::HTTP::BASE_URL_DEFAULT)
      expect(endpoint.url_root).to eq('localhost:1234/my-fake-root-url/products/mindee/blahblah/v3')
      ENV.delete(Mindee::V1::HTTP::BASE_URL_ENV_NAME)
    end
  end
end
