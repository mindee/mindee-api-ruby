# frozen_string_literal: true

require 'json'
require 'mindee/product'
require 'mindee/parsing'

require_relative '../../data'

DIR_US_US_MAIL_V3 = File.join(DATA_DIR, 'products', 'us_mail', 'response_v3').freeze

describe Mindee::Product::US::UsMail::UsMailV3 do
  context 'A US Mail V3' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_US_US_MAIL_V3, 'empty.json')
      inference = Mindee::Parsing::Common::Document.new(
        Mindee::Product::US::UsMail::UsMailV3,
        response['document']
      ).inference
      expect(inference.product.type).to eq('standard')
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_US_US_MAIL_V3, 'summary_full.rst')
      response = load_json(DIR_US_US_MAIL_V3, 'complete.json')
      document = Mindee::Parsing::Common::Document.new(
        Mindee::Product::US::UsMail::UsMailV3,
        response['document']
      )
      expect(document.to_s).to eq(to_string)
    end
  end
end
