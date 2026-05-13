# frozen_string_literal: true

require 'json'
require 'mindee/v2/product'

describe Mindee::V2::Product::Classification::Classification, :v2 do
  let(:classification_data_dir) { File.join(V2_PRODUCT_DATA_DIR, 'classification') }

  it 'should load a single result' do
    json_path = File.join(classification_data_dir, 'default_sample.json')
    json_sample = JSON.parse(File.read(json_path))
    response = Mindee::V2::Product::Classification::ClassificationResponse.new(json_sample)

    expect(response.inference).to be_a(Mindee::V2::Product::Classification::ClassificationInference)
    expect(response.inference.result).to be_a(Mindee::V2::Product::Classification::ClassificationResult)
    expect(
      response.inference.result.classification
    ).to be_a(Mindee::V2::Product::Classification::ClassificationClassifier)

    expect(response.inference.result.classification.document_type).to eq('invoice')
  end

  it 'should load a single result with extraction' do
    json_path = File.join(classification_data_dir, 'default_sample_extraction.json')
    json_sample = JSON.parse(File.read(json_path))
    response = Mindee::V2::Product::Classification::ClassificationResponse.new(json_sample)

    classification = response.inference.result.classification
    expect(classification.document_type).to eq('invoice')

    expect(classification.extraction_response).to be_a(Mindee::V2::Product::Extraction::ExtractionResponse)
    expect(
      classification.extraction_response.inference.result.fields.get_simple_field('customer_name').string_value
    ).to eq('Jiro Doi')
  end
end
