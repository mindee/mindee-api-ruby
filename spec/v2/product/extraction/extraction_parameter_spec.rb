# frozen_string_literal: true

require 'json'
require_relative '../../../data'

require 'mindee/v2/product/extraction/params/data_schema'
require 'mindee/v2/product/extraction/params/extraction_parameters'

describe Mindee::V2::Product::Extraction::Params::ExtractionParameters do
  let(:replace_path) { File.join(V2_PRODUCT_DATA_DIR, 'extraction', 'data_schema_replace_param.json') }
  let(:data_schema_dict) { JSON.parse(File.read(replace_path)) }
  let(:data_schema_string) { data_schema_dict.to_json }
  let(:data_schema_instance) { Mindee::V2::Product::Extraction::Params::DataSchema.new(data_schema_dict) }

  it 'should init with minimum values' do
    model_id = 'dummy-model'
    product_params = Mindee::V2::Product::Extraction::Params::ExtractionParameters.new(model_id)
    expect(product_params.model_id).to eq(model_id)
    expect(product_params.request_parameters['model_id']).to eq(model_id)
  end

  describe 'Data Schema' do
    describe "shouldn't replace when unset" do
      it 'should leave unset when not provided' do
        param = Mindee::V2::Product::Extraction::Params::ExtractionParameters.new(
          'dummy-model'
        )
        expect(param.data_schema).to be_nil
      end

      it 'should initialize with string' do
        param = Mindee::V2::Product::Extraction::Params::ExtractionParameters.new(
          'dummy-model',
          data_schema: data_schema_string
        )
        expect(param.data_schema.to_s).to eq(data_schema_string)
      end

      it 'should initialize with hash' do
        param = Mindee::V2::Product::Extraction::Params::ExtractionParameters.new(
          'dummy-model',
          data_schema: data_schema_dict
        )
        expect(param.data_schema.to_s).to eq(data_schema_string)
      end

      it 'should initialize with DataSchema object' do
        param = Mindee::V2::Product::Extraction::Params::ExtractionParameters.new(
          'dummy-model',
          data_schema: data_schema_instance
        )
        expect(param.data_schema.to_s).to eq(data_schema_string)
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
      expect(params['model_id']).to eq('dummy-model')
      expect(params['alias']).to eq('my_file')
      expect(params['webhook_ids']).to eq('hook-1,hook-2')
      expect(params['text_context']).to eq('sample context')
      expect(params['rag']).to eq('true')
      expect(params['raw_text']).to eq('false')
      expect(params['polygon']).to eq('true')
      expect(params['confidence']).to eq('false')
    end
  end
end
