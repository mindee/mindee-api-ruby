# frozen_string_literal: true

require 'json'
require 'mindee/product'
require 'mindee/parsing'

require_relative '../../data'

DIR_US_HEALTHCARE_CARD_V1 = File.join(DATA_DIR, 'products', 'us_healthcare_cards', 'response_v1').freeze

describe Mindee::Product::US::HealthcareCard::HealthcareCardV1 do
  context 'A Healthcare Card V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_US_HEALTHCARE_CARD_V1, 'empty.json')
      inference = Mindee::Parsing::Common::Document.new(
        Mindee::Product::US::HealthcareCard::HealthcareCardV1,
        response['document']
      ).inference
      expect(inference.product.type).to eq('standard')
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_US_HEALTHCARE_CARD_V1, 'summary_full.rst')
      response = load_json(DIR_US_HEALTHCARE_CARD_V1, 'complete.json')
      document = Mindee::Parsing::Common::Document.new(
        Mindee::Product::US::HealthcareCard::HealthcareCardV1,
        response['document']
      )
      expect(document.to_s).to eq(to_string)
    end
  end
end
