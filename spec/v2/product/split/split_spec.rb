# frozen_string_literal: true

require 'json'
require 'mindee'
require 'mindee/v2/product'

describe Mindee::V2::Product::Split::Split, :v2 do
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

    split0 = response.inference.result.splits[0]
    expect(split0.page_range.size).to eq(2)
    expect(split0.page_range[0]).to eq(0)
    expect(split0.page_range[1]).to eq(0)
    expect(split0.document_type).to eq('passport')

    split1 = response.inference.result.splits[1]
    expect(split1.page_range.size).to eq(2)
    expect(split1.page_range[0]).to eq(1)
    expect(split1.page_range[1]).to eq(3)
    expect(split1.document_type).to eq('invoice')

    split2 = response.inference.result.splits[2]
    expect(split2.page_range.size).to eq(2)
    expect(split2.page_range[0]).to eq(4)
    expect(split2.page_range[1]).to eq(4)
    expect(split2.document_type).to eq('receipt')
  end

  it 'should load extraction properties' do
    json_path = File.join(split_data_dir, 'default_sample_extraction.json')
    json_sample = JSON.parse(File.read(json_path))
    response = Mindee::V2::Product::Split::SplitResponse.new(json_sample)

    expect(response.inference).to be_a(Mindee::V2::Product::Split::SplitInference)

    splits = response.inference.result.splits
    expect(splits.size).to eq(2)

    split0 = splits[0]
    expect(split0.document_type).to eq('invoice')
    expect(split0.page_range[0]).to eq(0)
    extraction_response0 = split0.extraction_response
    expect(extraction_response0).not_to be_nil
    expect(
      extraction_response0.inference.result.fields.get_simple_field('supplier_phone_number').string_value
    ).to eq('05 05 44 44 90')

    split1 = splits[1]
    expect(split1.document_type).to eq('invoice')
    expect(split1.page_range[0]).to eq(1)
    extraction_response1 = split1.extraction_response
    expect(extraction_response1).not_to be_nil
    expect(
      extraction_response1.inference.result.fields.get_simple_field('supplier_phone_number').string_value
    ).to eq('416-555-1212')
  end
end
