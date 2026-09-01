# frozen_string_literal: true

require 'mindee'
require 'mindee/input/local_response'
require_relative '../../data'

describe Mindee::V2::Search::Models::ModelSearchResponse do
  it 'should load search models locally' do
    file_path = File.join(V2_DATA_DIR, 'search', 'models.json')
    local_response = Mindee::Input::LocalResponse.new(file_path)
    response = local_response.deserialize_response(described_class)

    expect(response).to be_a(described_class)

    expect(response.models.size).to eq(5)
    expect(response.pagination.total_items).to eq(5)
    expect(response.pagination.page).to eq(1)
    expect(response.pagination.per_page).to eq(50)
    expect(response.pagination.total_pages).to eq(1)

    first_item = response.models[0]
    expect(first_item.name).to eq('Extraction With Webhooks')
    expect(first_item.id).to eq('afde5151-aa11-aa11-9289-fa04e50ca3b9')
    expect(first_item.model_type).to eq('extraction')

    expect(first_item.webhooks.size).to eq(2)
    expect(first_item.webhooks[0].id).to eq('a2286ed9-aa11-aa11-bdc5-2f8496c5641a')
    expect(first_item.webhooks[0].name).to eq('FAILURE')
    expect(first_item.webhooks[0].url).to eq('https://failure.mindee.com')

    last_item = response.models[-1]
    expect(last_item.name).to eq('Extraction Without Webhooks Key')
    expect(last_item.id).to eq('e14e0923-ee55-ee55-a335-8d2110917d7b')
  end
end
