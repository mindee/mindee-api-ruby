# frozen_string_literal: true

require 'json'
require 'mindee/product'

require_relative '../../data'

DIR_US_BANK_CHECK_V1 = File.join(DATA_DIR, 'us', 'bank_check', 'response_v1').freeze

describe Mindee::Product::US::BankCheckV1 do
  context 'A US Bank Check V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_US_BANK_CHECK_V1, 'empty.json')
      inference = Mindee::Document.new(Mindee::Product::US::BankCheckV1, response['document']).inference
      expect(inference.product.type).to eq('standard')
      expect(inference.prediction.account_number.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_US_BANK_CHECK_V1, 'summary_full.rst')
      response = load_json(DIR_US_BANK_CHECK_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Product::US::BankCheckV1, response['document'])
      inference = document.inference
      expect(inference.prediction.account_number.value).to eq('12345678910')
      expect(inference.prediction.check_position.rectangle.top_left.y).to eq(0.129)
      expect(inference.prediction.check_position.rectangle[0][1]).to eq(0.129)
      inference.prediction.signatures_positions.each do |pos|
        expect(pos).to be_a_kind_of(Mindee::PositionField)
      end
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_US_BANK_CHECK_V1, 'summary_page0.rst')
      response = load_json(DIR_US_BANK_CHECK_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Product::US::BankCheckV1, response['document'])
      page = document.inference.pages[0]
      expect(page.prediction.account_number.value).to eq('12345678910')
      expect(page.prediction.check_position.rectangle.top_left.y).to eq(0.129)
      expect(page.prediction.check_position.rectangle[0][1]).to eq(0.129)
      page.prediction.signatures_positions.each do |pos|
        expect(pos).to be_a_kind_of(Mindee::PositionField)
      end
      expect(page.to_s).to eq(to_string)
    end
  end
end
