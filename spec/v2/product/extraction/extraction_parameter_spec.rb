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

  describe 'request_parameters' do
    it 'returns hash with correct parameters' do
      param = Mindee::V2::Product::Extraction::Params::ExtractionParameters.new(
        'dummy-model',
        text_context: 'sample context',
        webhook_ids: ['hook-1', 'hook-2'],
        file_alias: 'my_file',
        rag: true,
        raw_text: false,
        polygon: true,
        confidence: false
      )
      params = param.request_parameters
      expect(params[:model_id]).to eq('dummy-model')
      expect(params[:alias]).to eq('my_file')
      expect(params[:webhook_ids]).to eq('hook-1,hook-2')
      expect(params[:text_context]).to eq('sample context')
      expect(params[:rag]).to eq('true')
      expect(params[:raw_text]).to eq('false')
      expect(params[:polygon]).to eq('true')
      expect(params[:confidence]).to eq('false')
    end
  end
end
