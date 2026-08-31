# frozen_string_literal: true

require 'mindee'

describe Mindee::V2::Search::RAGDocuments::RAGDocumentSearchParameters, :integration, :v2 do
  let(:findoc_model_id) do
    ENV.fetch('MINDEE_V2_SE_TESTS_FINDOC_MODEL_ID', nil)
  end

  let(:v2_client) do
    Mindee::V2::Client.new
  end

  it 'must have results' do
    expect(findoc_model_id).not_to be_nil, 'MINDEE_V2_SE_TESTS_FINDOC_MODEL_ID must be set'

    response = v2_client.search(described_class.new(model_id: findoc_model_id))

    expect(response).not_to be_nil
    expect(response.rag_documents).not_to be_empty
    expect(response.pagination).not_to be_nil
    expect(response.pagination.total_items).to be >= 1
    expect(response.pagination.page).to eq(1)
  end
end
