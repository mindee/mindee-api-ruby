# frozen_string_literal: true

require 'json'
require 'mindee/v2/product'

describe Mindee::V2::Product::Classification::ClassificationResponse, :v2 do
  let(:classification_data_dir) { File.join(V2_PRODUCT_DATA_DIR, 'classification') }

  it 'parses a single classification properly' do
    json_path = File.join(classification_data_dir, 'classification_single.json')
    json_sample = JSON.parse(File.read(json_path))

    response = Mindee::V2::Product::Classification::ClassificationResponse.new(json_sample)

    expect(response.inference).to be_a(Mindee::V2::Product::Classification::ClassificationInference)
    expect(response.inference.result).to be_a(Mindee::V2::Product::Classification::ClassificationResult)
    expect(
      response.inference.result.classification
    ).to be_a(Mindee::V2::Product::Classification::ClassificationClassifier)

    expect(response.inference.result.classification.document_type).to eq('invoice')
  end
end
