# frozen_string_literal: true

require 'mindee/v2/product/extraction/params/data_schema'
require 'mindee/v2/product/extraction/params/extraction_parameters'

describe Mindee::V2::Product::Extraction::Params::ExtractionParameters do
  let(:extracted_schema_content) do
    File.read(File.join(V2_PRODUCT_DATA_DIR, 'extraction', 'data_schema_replace_param.json'))
  end
  let(:extracted_schema_hash) { JSON.parse(extracted_schema_content) }
  let(:extracted_schema_str) { extracted_schema_hash.to_json }
  let(:extracted_schema_object) { Mindee::V2::Product::Extraction::Params::DataSchema.new(extracted_schema_hash) }

  describe 'Data Schema' do
    describe "shouldn't replace when unset" do
      it 'should initialize with a data schema' do
        param = Mindee::V2::Product::Extraction::Params::ExtractionParameters.new(
          'dummy-model'
        )
        expect(param.data_schema).to be_nil
      end

      it 'should initialize with string' do
        param = Mindee::V2::Product::Extraction::Params::ExtractionParameters.new(
          'dummy-model',
          data_schema: extracted_schema_str
        )
        expect(param.data_schema.to_s).to eq(extracted_schema_str)
      end

      it 'should initialize with hash' do
        param = Mindee::V2::Product::Extraction::Params::ExtractionParameters.new(
          'dummy-model',
          data_schema: extracted_schema_hash
        )
        expect(param.data_schema.to_s).to eq(extracted_schema_str)
      end

      it 'should initialize with DataSchema object' do
        param = Mindee::V2::Product::Extraction::Params::ExtractionParameters.new(
          'dummy-model',
          data_schema: extracted_schema_object
        )
        expect(param.data_schema.to_s).to eq(extracted_schema_str)
      end
    end
  end
end
