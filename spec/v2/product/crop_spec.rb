# frozen_string_literal: true

require 'json'
require 'mindee/v2/product'

require_relative '../../data'

describe Mindee::V2::Product::Crop::CropResponse do
  let(:crop_data_dir) { File.join(V2_PRODUCTS_DIR, 'crop') }

  it 'parses a single crop properly' do
    json_path = File.join(crop_data_dir, 'crop_single.json')
    rst_path  = File.join(crop_data_dir, 'crop_single.rst')

    json_sample = JSON.parse(File.read(json_path))
    rst_sample  = File.read(rst_path)

    response = Mindee::V2::Product::Crop::CropResponse.new(json_sample)

    expect(response.inference).to be_a(Mindee::V2::Product::Crop::CropInference)
    expect(response.inference.result.crops).not_to be_empty

    crop = response.inference.result.crops[0]
    expect(crop.location.polygon.size).to eq(4)
    expect(crop.location.polygon[0][0]).to eq(0.15)
    expect(crop.location.polygon[0][1]).to eq(0.254)
    expect(crop.location.polygon[1][0]).to eq(0.85)
    expect(crop.location.polygon[1][1]).to eq(0.254)
    expect(crop.location.polygon[2][0]).to eq(0.85)
    expect(crop.location.polygon[2][1]).to eq(0.947)
    expect(crop.location.polygon[3][0]).to eq(0.15)
    expect(crop.location.polygon[3][1]).to eq(0.947)

    expect(crop.location.page).to eq(0)
    expect(crop.object_type).to eq('invoice')

    expect(response.to_s).to eq(rst_sample)
  end

  it 'parses multiple crops properly' do
    json_path = File.join(crop_data_dir, 'crop_multiple.json')
    rst_path  = File.join(crop_data_dir, 'crop_multiple.rst')

    json_sample = JSON.parse(File.read(json_path))
    rst_sample  = File.read(rst_path)

    response = Mindee::V2::Product::Crop::CropResponse.new(json_sample)

    expect(response.inference).to be_a(Mindee::V2::Product::Crop::CropInference)
    expect(response.inference.result).to be_a(Mindee::V2::Product::Crop::CropResult)
    expect(response.inference.result.crops[0]).to be_a(Mindee::V2::Product::Crop::CropItem)
    expect(response.inference.result.crops.size).to eq(2)

    # First Crop assertions
    crop_zero = response.inference.result.crops[0]
    expect(crop_zero.location.polygon.size).to eq(4)
    expect(crop_zero.location.polygon[0][0]).to eq(0.214)
    expect(crop_zero.location.polygon[0][1]).to eq(0.079)
    expect(crop_zero.location.polygon[1][0]).to eq(0.476)
    expect(crop_zero.location.polygon[1][1]).to eq(0.079)
    expect(crop_zero.location.polygon[2][0]).to eq(0.476)
    expect(crop_zero.location.polygon[2][1]).to eq(0.979)
    expect(crop_zero.location.polygon[3][0]).to eq(0.214)
    expect(crop_zero.location.polygon[3][1]).to eq(0.979)

    expect(crop_zero.location.page).to eq(0)
    expect(crop_zero.object_type).to eq('invoice')

    # Second Crop assertions
    crop_one = response.inference.result.crops[1]
    expect(crop_one.location.polygon.size).to eq(4)
    expect(crop_one.location.polygon[0][0]).to eq(0.547)
    expect(crop_one.location.polygon[0][1]).to eq(0.15)
    expect(crop_one.location.polygon[1][0]).to eq(0.862)
    expect(crop_one.location.polygon[1][1]).to eq(0.15)
    expect(crop_one.location.polygon[2][0]).to eq(0.862)
    expect(crop_one.location.polygon[2][1]).to eq(0.97)
    expect(crop_one.location.polygon[3][0]).to eq(0.547)
    expect(crop_one.location.polygon[3][1]).to eq(0.97)

    expect(crop_one.location.page).to eq(0)
    expect(crop_one.object_type).to eq('invoice')

    expect(response.to_s).to eq(rst_sample)
  end
end
