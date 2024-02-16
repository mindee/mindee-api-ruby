# frozen_string_literal: true

require 'json'
require 'mindee/product'
require 'mindee/parsing'

require_relative '../../data'

DIR_FR_BANK_ACCOUNT_DETAILS_V2 = File.join(DATA_DIR, 'products', 'bank_account_details', 'response_v2').freeze

describe Mindee::Product::FR::BankAccountDetails::BankAccountDetailsV2 do
  context 'A Bank Account Details V2' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_FR_BANK_ACCOUNT_DETAILS_V2, 'empty.json')
      inference = Mindee::Parsing::Common::Document.new(
        Mindee::Product::FR::BankAccountDetails::BankAccountDetailsV2,
        response['document']
      ).inference
      expect(inference.product.type).to eq('standard')
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_FR_BANK_ACCOUNT_DETAILS_V2, 'summary_full.rst')
      response = load_json(DIR_FR_BANK_ACCOUNT_DETAILS_V2, 'complete.json')
      document = Mindee::Parsing::Common::Document.new(
        Mindee::Product::FR::BankAccountDetails::BankAccountDetailsV2,
        response['document']
      )
      expect(document.to_s).to eq(to_string)
    end
  end
end
