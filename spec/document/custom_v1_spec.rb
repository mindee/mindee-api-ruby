# frozen_string_literal: true

require 'json'
require 'mindee/product'
require 'mindee/parsing'

require_relative '../data'

DIR_CUSTOM_V1 = File.join(DATA_DIR, 'products', 'custom', 'response_v1').freeze

describe Mindee::Product::Custom::CustomV1 do
  context 'A custom document V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_CUSTOM_V1, 'empty.json')
      inference = Mindee::Parsing::Common::Document.new(Mindee::Product::Custom::CustomV1,
                                                        response['document']).inference
      expect(inference.product.type).to eq('constructed')
      expect(inference.prediction.fields.length).to eq(10)
      expect(inference.prediction.classifications.length).to eq(1)
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_CUSTOM_V1, 'summary_full.rst')
      response = load_json(DIR_CUSTOM_V1, 'complete.json')
      document = Mindee::Parsing::Common::Document.new(Mindee::Product::Custom::CustomV1, response['document'])
      expect(document.to_s).to eq(to_string)
      prediction = document.inference.prediction

      prediction.fields.each do |field_name, field_data|
        expect(field_name).to be_kind_of(Symbol)
        expect(field_data.values).to be_kind_of(Array)
        expect(field_data.contents_str).to be_kind_of(String)
      end

      expect(prediction.fields[:string_all].values.size).to eq(3)
      expect(prediction.fields['string_all']).to be_nil
      expect(prediction.fields[:string_all].contents_str).to eq('Mindee is awesome')
      expect(prediction.fields[:string_all].contents_list).to eq(['Mindee', 'is', 'awesome'])

      expect(prediction.classifications[:doc_type].value).to eq('type_b')
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_CUSTOM_V1, 'summary_page0.rst')
      response = load_json(DIR_CUSTOM_V1, 'complete.json')
      inference = Mindee::Parsing::Common::Document.new(Mindee::Product::Custom::CustomV1,
                                                        response['document']).inference
      expect(inference.pages[0].prediction.fields[:string_all].contents_str(separator: '_')).to eq('Jenny_is_great')
      expect(inference.pages[0].prediction.fields[:string_all].contents_list).to eq(['Jenny', 'is', 'great'])
      expect(inference.pages[0].to_s).to eq(to_string)
    end

    it 'should load a complete page 1 prediction' do
      to_string = read_file(DIR_CUSTOM_V1, 'summary_page1.rst')
      response = load_json(DIR_CUSTOM_V1, 'complete.json')
      inference = Mindee::Parsing::Common::Document.new(Mindee::Product::Custom::CustomV1,
                                                        response['document']).inference
      expect(inference.pages[1].to_s).to eq(to_string)
    end
  end
end
