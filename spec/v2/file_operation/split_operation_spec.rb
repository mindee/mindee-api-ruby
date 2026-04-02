# frozen_string_literal: true

require 'json'
require 'mindee'
require 'mindee/v2/product'

describe Mindee::V2::Product::Split::SplitResponse, :v2 do
  let(:splits_default) do
    File.join(V2_PRODUCT_DATA_DIR, 'extraction', 'financial_document', 'default_sample.jpg')
  end

  let(:splits_5p) do
    File.join(V2_PRODUCT_DATA_DIR, 'split', 'invoice_5p.pdf')
  end

  let(:splits_single_page_json_path) do
    File.join(V2_PRODUCT_DATA_DIR, 'split', 'split_single.json')
  end

  let(:splits_multi_page_json_path) do
    File.join(V2_PRODUCT_DATA_DIR, 'split', 'split_multiple.json')
  end

  it 'processes single page split correctly' do
    input_sample = Mindee::Input::Source::PathInputSource.new(splits_default)
    response_hash = JSON.parse(File.read(splits_single_page_json_path))
    doc = described_class.new(response_hash)

    extracted_splits = doc.extract_from_file(input_sample)

    expect(extracted_splits.size).to eq(1)

    expect(extracted_splits[0].page_count).to eq(1)
  end

  it 'processes multi page receipt split correctly' do
    input_sample = Mindee::Input::Source::PathInputSource.new(splits_5p)
    response_hash = JSON.parse(File.read(splits_multi_page_json_path))
    doc = described_class.new(response_hash)

    extracted_splits = doc.extract_from_file(input_sample)

    expect(extracted_splits.size).to eq(3)

    expect(extracted_splits[0].page_count).to eq(1)
    expect(extracted_splits[1].page_count).to eq(3)
    expect(extracted_splits[2].page_count).to eq(1)
  end
end
