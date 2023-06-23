# frozen_string_literal: true

require 'json'
require 'mindee/product'
require 'mindee/parsing'

require_relative '../data'

DIR_PASSPORT_V1 = File.join(DATA_DIR, 'passport', 'response_v1').freeze

describe Mindee::Product::Passport::PassportV1 do
  include Mindee::Parsing::Common
  context 'A Passport V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_PASSPORT_V1, 'empty.json')
      inference = Mindee::Parsing::Common::Document.new(Mindee::Product::Passport::PassportV1,
                                                        response['document']).inference
      expect(inference.product.type).to eq('standard')
      expect(inference.prediction.expired?).to eq(true)
      expect(inference.prediction.surname.value).to be_nil
      expect(inference.prediction.birth_date.value).to be_nil
      expect(inference.prediction.issuance_date.value).to be_nil
      expect(inference.prediction.expiry_date.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_PASSPORT_V1, 'summary_full.rst')
      response = load_json(DIR_PASSPORT_V1, 'complete.json')
      document = Mindee::Parsing::Common::Document.new(Mindee::Product::Passport::PassportV1, response['document'])
      prediction = document.inference.prediction
      expect(prediction.expired?).to eq(false)
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page prediction' do
      to_string = read_file(DIR_PASSPORT_V1, 'summary_page0.rst')
      response = load_json(DIR_PASSPORT_V1, 'complete.json')
      document = Mindee::Parsing::Common::Document.new(Mindee::Product::Passport::PassportV1, response['document'])
      page = document.inference.pages[0]
      expect(page.expired?).to eq(false)
      expect(page.to_s).to eq(to_string)
    end
  end
end
