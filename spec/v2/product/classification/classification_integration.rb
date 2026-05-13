# frozen_string_literal: true

require 'mindee'
require 'mindee/v2/product'

describe Mindee::V2::Product::Classification, :integration, :v2 do
  let(:classification_model_id) do
    ENV.fetch('MINDEE_V2_SE_TESTS_CLASSIFICATION_MODEL_ID', nil)
  end

  let(:v2_client) do
    Mindee::V2::Client.new
  end

  it 'processes classification default sample correctly' do
    input_source = Mindee::Input::Source::PathInputSource.new(
      File.join(V2_PRODUCT_DATA_DIR, 'classification', 'default_sample.jpg')
    )

    params = { model_id: classification_model_id }

    response = v2_client.enqueue_and_get_result(
      Mindee::V2::Product::Classification::Classification,
      input_source,
      params
    )

    expect(response.inference).not_to be_nil
    expect(response.inference.file.name).to eq('default_sample.jpg')
    expect(response.inference.result.classification).not_to be_nil
    expect(response.inference.result.classification.document_type).to eq('invoice')
  end
end
