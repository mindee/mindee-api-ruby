# frozen_string_literal: true

require 'mindee'
require 'mindee/v2/parsing/search'

describe Mindee::V2::Parsing::Search::SearchResponse do
  it 'initializes' do
    json_file_path = File.join(V2_DATA_DIR, 'search', 'models.json')

    response = described_class.new(JSON.parse(File.read(json_file_path)))

    expect(response).not_to be_nil
    expect(response.models.size).to eq(5)
    model0 = response.models[0]
    expect(model0.name).to eq('Extraction With Webhooks')
    expect(model0.webhooks.size).to eq(2)
    expect(model0.webhooks[0].url).to eq('https://failure.mindee.com')
  end
end
