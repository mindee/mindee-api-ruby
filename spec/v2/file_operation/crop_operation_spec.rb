# frozen_string_literal: true

require 'json'
require 'mini_magick' if Mindee::Dependency.all_deps_available?
require 'mindee'
require 'mindee/v2/file_operation'
require 'mindee/v2/product'

describe Mindee::V2::FileOperation::Crop, :v2, :all_deps do
  let(:crops_single_page_path) do
    File.join(V2_PRODUCT_DATA_DIR, 'crop', 'default_sample.jpg')
  end

  let(:crops_multi_page_path) do
    File.join(V2_PRODUCT_DATA_DIR, 'crop', 'multipage_sample.pdf')
  end

  let(:crops_single_page_json_path) do
    File.join(V2_PRODUCT_DATA_DIR, 'crop', 'crop_single.json')
  end

  let(:crops_multi_page_json_path) do
    File.join(V2_PRODUCT_DATA_DIR, 'crop', 'crop_multiple.json')
  end

  it 'processes single page crop split correctly' do
    input_sample = Mindee::Input::Source::PathInputSource.new(crops_single_page_path)
    response_hash = JSON.parse(File.read(crops_single_page_json_path))
    doc = Mindee::V2::Product::Crop::CropResponse.new(response_hash)

    extracted_crops = described_class.extract_crops(input_sample, doc.inference.result.crops)

    expect(extracted_crops.size).to eq(1)

    expect(extracted_crops[0].page_id).to eq(0)
    expect(extracted_crops[0].element_id).to eq(0)

    image_buffer0 = MiniMagick::Image.read(extracted_crops[0].buffer)
    expect(image_buffer0.dimensions).to eq([2822, 1572])
  end

  it 'processes multi page receipt split correctly' do
    input_sample = Mindee::Input::Source::PathInputSource.new(crops_multi_page_path)
    response_hash = JSON.parse(File.read(crops_multi_page_json_path))
    doc = Mindee::V2::Product::Crop::CropResponse.new(response_hash)

    extracted_crops = described_class.extract_crops(input_sample, doc.inference.result.crops)

    expect(extracted_crops.size).to eq(2)

    expect(extracted_crops[0].page_id).to eq(0)
    expect(extracted_crops[0].element_id).to eq(0)
    image_buffer0 = MiniMagick::Image.read(extracted_crops[0].buffer)
    expect(image_buffer0.dimensions).to eq([156, 758])

    expect(extracted_crops[1].page_id).to eq(0)
    expect(extracted_crops[1].element_id).to eq(1)
    image_buffer1 = MiniMagick::Image.read(extracted_crops[1].buffer)
    expect(image_buffer1.dimensions).to eq([187, 690])
  end
end
