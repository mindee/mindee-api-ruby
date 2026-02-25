# frozen_string_literal: true

require 'mindee'
require 'mindee/v2/product'

describe Mindee::ClientV2, :integration, :v2 do
  let(:ocr_model_id) do
    ENV.fetch('MINDEE_V2_SE_TESTS_OCR_MODEL_ID')
  end

  let(:v2_client) do
    Mindee::ClientV2.new
  end

  it 'processes ocr default sample correctly' do
    input_source = Mindee::Input::Source::PathInputSource.new(
      File.join(V2_PRODUCT_DATA_DIR, 'ocr', 'default_sample.jpg')
    )

    params = OcrParameters.new(ocr_model_id)

    response = v2_client.enqueue_and_get_result(
      Mindee::V2::Product::Ocr::OcrResponse,
      input_source,
      params
    )

    expect(response.inference).not_to be_nil
    expect(response.inference.file.name).to eq('default_sample.jpg')
    expect(response.inference).to be_a(Mindee::V2::Product::Ocr::OcrInference)
    expect(response.inference.result).to be_a(Mindee::V2::Product::Ocr::OcrResult)
    expect(response.inference.result.pages.size).to eq(1)
    expect(response.inference.result.pages[0].words.size).to be > 5
  end
end
