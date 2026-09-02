# frozen_string_literal: true

require 'mindee'
require 'mindee/input/local_response'
require_relative '../../data'

describe Mindee::V2::Search::RAGDocuments::RAGDocumentSearchResponse do
  it 'should load search rag documents locally' do
    file_path = File.join(V2_DATA_DIR, 'search', 'rag_documents.json')
    local_response = Mindee::Input::LocalResponse.new(file_path)
    response = local_response.deserialize_response(described_class)

    expect(response).to be_a(described_class)

    expect(response.rag_documents.size).to eq(3)
    expect(response.pagination.total_items).to eq(3)
    expect(response.pagination.page).to eq(1)
    expect(response.pagination.per_page).to eq(50)
    expect(response.pagination.total_pages).to eq(1)

    first_item = response.rag_documents[0]
    expect(first_item.id).to eq('cc831599-c545-48b7-aa27-6d7ccd5b8d32')
    expect(first_item.model_id).to eq('12345678-1234-1234-1234-123456789abc')
    expect(first_item.filename).to eq('invoice_01.pdf')
    expect(first_item.created_at).to eq(Time.utc(2026, 6, 30, 13, 13, 46, 168_586))
    expect(first_item.total_matches).to eq(0)
    expect(first_item.last_match_at).to be_nil
    expect(first_item.status).to eq('Processing')

    second_item = response.rag_documents[1]
    expect(second_item.id).to eq('27467e4c-5602-4315-90d9-3d2da69b05ab')
    expect(second_item.model_id).to eq('12345678-1234-1234-1234-123456789abc')
    expect(second_item.filename).to eq('invoice_02.pdf')
    expect(second_item.created_at).to eq(Time.utc(2026, 6, 30, 13, 13, 46, 168_586))
    expect(second_item.total_matches).to eq(0)
    expect(second_item.last_match_at).to be_nil
    expect(second_item.status).to eq('Draft')

    third_item = response.rag_documents[2]
    expect(third_item.id).to eq('a6bcae7d-0439-476b-8a63-5a39ec05dc21')
    expect(third_item.model_id).to eq('12345678-1234-1234-1234-jobid1234567')
    expect(third_item.filename).to eq('invoice_03.pdf')
    expect(third_item.created_at).to eq(Time.utc(2026, 6, 17, 14, 35, 46, 228_006))
    expect(third_item.total_matches).to eq(5)
    expect(third_item.last_match_at).to eq(Time.utc(2026, 6, 18, 14, 35, 46, 248_006))
    expect(third_item.status).to eq('Active')
  end
end
