# frozen_string_literal: true

require 'mindee'

describe Mindee::V2::Search::Models::ModelSearchParameters, :integration, :v2 do
  let(:v2_client) do
    Mindee::V2::Client.new
  end

  it 'must have results' do
    response = v2_client.search(described_class.new)

    expect(response).not_to be_nil
    expect(response.models).not_to be_empty
    expect(response.pagination).not_to be_nil
    expect(response.pagination.total_items).to be >= 1
    expect(response.pagination.page).to eq(1)
  end

  it 'must return empty' do
    response = v2_client.search(described_class.new(name: "je n'existe pas tralala"))

    expect(response).not_to be_nil
    expect(response.models).to be_empty
    expect(response.pagination).not_to be_nil
    expect(response.pagination.total_items).to eq(0)
    expect(response.pagination.page).to eq(1)
  end
end
