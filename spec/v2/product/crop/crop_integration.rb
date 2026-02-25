# frozen_string_literal: true

require 'mindee'
require 'mindee/v2/product'

describe Mindee::ClientV2, :integration, :v2 do
  let(:crop_model_id) do
    ENV.fetch('MINDEE_V2_SE_TESTS_CROP_MODEL_ID', nil)
  end

  let(:v2_client) do
    Mindee::ClientV2.new
  end

  it 'processes crop default sample correctly' do
    input_source = Mindee::Input::Source::PathInputSource.new(
      File.join(V2_PRODUCT_DATA_DIR, 'crop', 'default_sample.jpg')
    )

    params = Mindee::V2::Product::Crop::Params::CropParameters.new(crop_model_id)

    response = v2_client.enqueue_and_get_result(
      Mindee::V2::Product::Crop::CropResponse,
      input_source,
      params
    )

    expect(response.inference).not_to be_nil
    expect(response.inference.file.name).to eq('default_sample.jpg')
    expect(response.inference.result.crops).not_to be_empty
    expect(response.inference.result.crops.size).to eq(2)
  end
end
