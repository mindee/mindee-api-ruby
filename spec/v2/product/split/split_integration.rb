# frozen_string_literal: true

require 'mindee'
require 'mindee/v2/product'

describe Mindee::ClientV2, :integration, :v2 do
  let(:split_model_id) do
    ENV.fetch('MINDEE_V2_SE_TESTS_SPLIT_MODEL_ID')
  end

  let(:v2_client) do
    Mindee::ClientV2.new
  end

  it 'processes split default sample correctly' do
    input_source = Mindee::Input::Source::PathInputSource.new(
      File.join(V2_PRODUCT_DATA_DIR, 'split', 'default_sample.pdf')
    )

    params = { model: split_model_id }

    response = v2_client.enqueue_and_get_result(
      Mindee::V2::Product::Split::Split,
      input_source,
      params
    )

    expect(response.inference).not_to be_nil
    expect(response.inference.file.name).to eq('default_sample.pdf')
    expect(response.inference.result.splits).not_to be_empty
    expect(response.inference.result.splits.size).to eq(2)
  end
end
