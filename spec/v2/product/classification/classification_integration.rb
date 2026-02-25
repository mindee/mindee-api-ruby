# frozen_string_literal: true

require 'mindee'

describe Mindee::ClientV2, :integration, :v2 do
  let(:classification_model_id) do
    ENV.fetch('MINDEE_V2_SE_TESTS_CLASSIFICATION_MODEL_ID', nil)
  end

  let(:v2_client) do
    Mindee::ClientV2.new
  end

  it 'processes classification default sample correctly' do
    input_source = Mindee::Input::Source::PathInputSource.new(
      File.join(V2_PRODUCT_DATA_DIR, 'classification', 'default_invoice.jpg')
    )

    params = Mindee::Input::InferenceParameters.new(classification_model_id)

    response = v2_client.enqueue_and_get_result(
      Mindee::V2::Product::Classification::ClassificationResponse,
      input_source,
      params
    )

    expect(response.inference).not_to be_nil
    expect(response.inference.file.name).to eq('default_invoice.jpg')
    expect(response.inference.result.classification).not_to be_nil
    expect(response.inference.result.classification.document_type).to eq('invoice')
  end
end
