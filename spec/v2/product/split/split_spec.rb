# frozen_string_literal: true

require 'json'
require 'mindee'

describe Mindee::V2::Product::Split::SplitResponse, :v2 do
  let(:split_data_dir) { File.join(V2_PRODUCT_DATA_DIR, 'split') }

  it 'parses a single split properly' do
    json_path = File.join(split_data_dir, 'split_single.json')
    json_sample = JSON.parse(File.read(json_path))

    response = Mindee::V2::Product::Split::SplitResponse.new(json_sample)

    expect(response.inference).to be_a(Mindee::V2::Product::Split::SplitInference)
    expect(response.inference.result.splits).not_to be_empty
    expect(response.inference.result.splits[0].page_range.size).to eq(2)
    expect(response.inference.result.splits[0].page_range[0]).to eq(0)
    expect(response.inference.result.splits[0].page_range[1]).to eq(0)
    expect(response.inference.result.splits[0].document_type).to eq('receipt')
  end

  it 'parses multiple splits properly' do
    json_path = File.join(split_data_dir, 'split_multiple.json')
    json_sample = JSON.parse(File.read(json_path))

    response = Mindee::V2::Product::Split::SplitResponse.new(json_sample)

    expect(response.inference).to be_a(Mindee::V2::Product::Split::SplitInference)
    expect(response.inference.result).to be_a(Mindee::V2::Product::Split::SplitResult)
    expect(response.inference.result.splits[0]).to be_a(Mindee::V2::Product::Split::SplitRange)
    expect(response.inference.result.splits.size).to eq(3)

    split_zero = response.inference.result.splits[0]
    expect(split_zero.page_range.size).to eq(2)
    expect(split_zero.page_range[0]).to eq(0)
    expect(split_zero.page_range[1]).to eq(0)
    expect(split_zero.document_type).to eq('invoice')

    split_one = response.inference.result.splits[1]
    expect(split_one.page_range.size).to eq(2)
    expect(split_one.page_range[0]).to eq(1)
    expect(split_one.page_range[1]).to eq(3)
    expect(split_one.document_type).to eq('invoice')

    split_two = response.inference.result.splits[2]
    expect(split_two.page_range.size).to eq(2)
    expect(split_two.page_range[0]).to eq(4)
    expect(split_two.page_range[1]).to eq(4)
    expect(split_two.document_type).to eq('invoice')
  end
end
