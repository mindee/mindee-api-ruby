# frozen_string_literal: true

require 'mindee'
require 'mindee/v2/file_operations'
require 'mindee/v2/product'

describe Mindee::V2::FileOperation::Crop, :integration, :v2, :all_deps do
  let(:crop_sample) do
    File.join(V2_PRODUCT_DATA_DIR, 'crop', 'default_sample.jpg')
  end

  let(:v2_client) do
    Mindee::V2::Client.new
  end

  let(:crop_model_id) do
    ENV.fetch('MINDEE_V2_SE_TESTS_CROP_MODEL_ID')
  end

  let(:findoc_model_id) do
    ENV.fetch('MINDEE_V2_SE_TESTS_FINDOC_MODEL_ID')
  end

  after(:all) do
    FileUtils.rm_f("#{OUTPUT_DIR}/crop_001.jpg")
    FileUtils.rm_f("#{OUTPUT_DIR}/crop_002.jpg")
  end

  # Validates the parsed financial document response properties.
  #
  # @param findoc_response [Mindee::V2::InferenceResponse] The inference response to check.
  def check_findoc_return(findoc_response)
    expect(findoc_response.inference.model.id.length).to be > 0
    expect(findoc_response.inference.result.fields['total_amount'].value).to be > 0
  end

  it 'extracts crops from image correctly' do
    crop_input = Mindee::Input::Source::PathInputSource.new(crop_sample)

    crop_params = { model_id: crop_model_id, close_file: false }

    response = v2_client.enqueue_and_get_result(
      Mindee::V2::Product::Crop::Crop,
      crop_input,
      crop_params
    )

    expect(response.inference.result.crops.size).to eq(2)

    extracted_images = described_class.extract_crops(crop_input, response.inference.result.crops)

    expect(extracted_images.size).to eq(2)
    expect(extracted_images[0].filename).to eq('default_sample.jpg_page0-0.jpg')
    expect(extracted_images[1].filename).to eq('default_sample.jpg_page0-1.jpg')

    findoc_params = { model_id: findoc_model_id, close_file: false }

    invoice0 = v2_client.enqueue_and_get_result(
      Mindee::V2::Product::Extraction::Extraction,
      extracted_images[0].as_input_source,
      findoc_params
    )

    check_findoc_return(invoice0)

    extracted_images.save_all_to_disk(OUTPUT_DIR)

    expect(File.size(File.join(OUTPUT_DIR, 'crop_001.jpg'))).to be_between(600_000, 672_913)
    expect(File.size(File.join(OUTPUT_DIR, 'crop_002.jpg'))).to be_between(600_000, 675_728)
  end
end
