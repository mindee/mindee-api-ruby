# frozen_string_literal: true

require 'json'
require 'mindee/product'
require 'mindee/parsing'

require_relative '../../data'

DIR_IND_INDIAN_PASSPORT_V1 = File.join(DATA_DIR, 'products', 'ind_passport', 'response_v1').freeze

describe Mindee::Product::IND::IndianPassport::IndianPassportV1 do
  context 'A Passport - India V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_IND_INDIAN_PASSPORT_V1, 'empty.json')
      inference = Mindee::Parsing::Common::Document.new(
        Mindee::Product::IND::IndianPassport::IndianPassportV1,
        response['document']
      ).inference
      expect(inference.product.type).to eq('standard')
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_IND_INDIAN_PASSPORT_V1, 'summary_full.rst')
      response = load_json(DIR_IND_INDIAN_PASSPORT_V1, 'complete.json')
      document = Mindee::Parsing::Common::Document.new(
        Mindee::Product::IND::IndianPassport::IndianPassportV1,
        response['document']
      )
      expect(document.to_s).to eq(to_string)
    end
  end
end
