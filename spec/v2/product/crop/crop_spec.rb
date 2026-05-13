# frozen_string_literal: true

require 'json'
require 'mindee/v2/product'

require_relative '../../../data'

describe Mindee::V2::Product::Crop::Crop do
  let(:crop_data_dir) { File.join(V2_PRODUCT_DATA_DIR, 'crop') }

  it 'should load a single result' do
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

  it 'should load multiple results' do
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
    crop0 = response.inference.result.crops[0]
    expect(crop0.location.polygon.size).to eq(4)
    expect(crop0.location.polygon[0][0]).to eq(0.214)
    expect(crop0.location.polygon[0][1]).to eq(0.079)
    expect(crop0.location.polygon[1][0]).to eq(0.476)
    expect(crop0.location.polygon[1][1]).to eq(0.079)
    expect(crop0.location.polygon[2][0]).to eq(0.476)
    expect(crop0.location.polygon[2][1]).to eq(0.979)
    expect(crop0.location.polygon[3][0]).to eq(0.214)
    expect(crop0.location.polygon[3][1]).to eq(0.979)

    expect(crop0.location.page).to eq(0)
    expect(crop0.object_type).to eq('invoice')

    # Second Crop assertions
    crop1 = response.inference.result.crops[1]
    expect(crop1.location.polygon.size).to eq(4)
    expect(crop1.location.polygon[0][0]).to eq(0.547)
    expect(crop1.location.polygon[0][1]).to eq(0.15)
    expect(crop1.location.polygon[1][0]).to eq(0.862)
    expect(crop1.location.polygon[1][1]).to eq(0.15)
    expect(crop1.location.polygon[2][0]).to eq(0.862)
    expect(crop1.location.polygon[2][1]).to eq(0.97)
    expect(crop1.location.polygon[3][0]).to eq(0.547)
    expect(crop1.location.polygon[3][1]).to eq(0.97)

    expect(crop1.location.page).to eq(0)
    expect(crop1.object_type).to eq('receipt')

    expect(response.to_s).to eq(rst_sample)
  end

  it 'should load extraction properties' do
    json_path = File.join(crop_data_dir, 'default_sample_extraction.json')
    json_sample = JSON.parse(File.read(json_path))
    response = Mindee::V2::Product::Crop::CropResponse.new(json_sample)

    expect(response.inference).to be_a(Mindee::V2::Product::Crop::CropInference)
    crops = response.inference.result.crops
    expect(response.inference.result.crops.size).to eq(2)

    crop0 = crops[0]
    expect(crop0.object_type).to eq('receipt')
    expect(crop0.location.polygon).not_to be_nil
    expect(crop0.location.page).to eq(0)
    extraction_response0 = crop0.extraction_response
    expect(extraction_response0).not_to be_nil
    expect(
      extraction_response0.inference.result.fields.get_simple_field('supplier_name').value
    ).to eq('CHEZ ALAIN MIAM MIAM')

    crop1 = crops[1]
    expect(crop1.object_type).to eq('receipt')
    expect(crop1.location.polygon).not_to be_nil
    expect(crop1.location.page).to eq(0)
    extraction_response1 = crop1.extraction_response
    expect(extraction_response1).not_to be_nil
    expect(
      extraction_response1.inference.result.fields.get_simple_field('supplier_name').value
    ).to eq('La cerise sur la pizza')
  end
end
