# frozen_string_literal: true

require 'json'

require 'mindee/parsing'

require_relative '../data'

describe Mindee::Document do
  def load_json(dir_path, file_name)
    file_data = File.read(File.join(dir_path, file_name))
    JSON.parse(file_data)
  end

  def read_file(dir_path, file_name)
    File.read(File.join(dir_path, file_name)).strip
  end

  context 'A bank account details V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_FR_BANK_ACCOUNT_DETAILS_V1, 'empty.json')
      document = Mindee::Document.new(Mindee::Prediction::FR::BankAccountDetailsV1, response['document'])
      expect(document.inference.product.type).to eq('standard')
      prediction = document.inference.prediction
      expect(prediction.iban.value).to be_nil
      expect(prediction.iban.polygon).to be_empty
      expect(prediction.iban.bounding_box).to be_nil
      expect(prediction.swift.value).to be_nil
      expect(prediction.account_holder_name.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_FR_BANK_ACCOUNT_DETAILS_V1, 'summary_full.rst')
      response = load_json(DIR_FR_BANK_ACCOUNT_DETAILS_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::FR::BankAccountDetailsV1, response['document'])
      prediction = document.inference.prediction
      expect(prediction.swift.page_id).to eq(0)
      expect(prediction.swift.value).to eq('CMCIFR')
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_FR_BANK_ACCOUNT_DETAILS_V1, 'summary_page0.rst')
      response = load_json(DIR_FR_BANK_ACCOUNT_DETAILS_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::FR::BankAccountDetailsV1, response['document'])
      page = document.inference.pages[0]
      expect(page.prediction.swift.page_id).to eq(0)
      expect(page.prediction.swift.value).to eq('CMCIFR')
      expect(page.to_s).to eq(to_string)
    end
  end

  context 'A carte vitale V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_FR_CARTE_VITALE_V1, 'empty.json')
      document = Mindee::Document.new(Mindee::Prediction::FR::CarteVitaleV1, response['document'])
      expect(document.inference.product.type).to eq('standard')
      prediction = document.inference.prediction
      expect(prediction.surname.value).to be_nil
      expect(prediction.social_security.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_FR_CARTE_VITALE_V1, 'summary_full.rst')
      response = load_json(DIR_FR_CARTE_VITALE_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::FR::CarteVitaleV1, response['document'])
      expect(document.inference.prediction.social_security.page_id).to eq(0)
      expect(document.inference.prediction.social_security.value).to eq('269054958815780')
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_FR_CARTE_VITALE_V1, 'summary_page0.rst')
      response = load_json(DIR_FR_CARTE_VITALE_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::FR::CarteVitaleV1, response['document'])
      page = document.inference.pages[0]
      expect(page.orientation.value).to eq(0)
      expect(page.prediction.social_security.page_id).to eq(0)
      expect(page.to_s).to eq(to_string)
    end
  end

  context 'An ID card V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_FR_ID_CARD_V1, 'empty.json')
      document = Mindee::Document.new(Mindee::Prediction::FR::IdCardV1, response['document'])
      expect(document.inference.product.type).to eq('standard')
      prediction = document.inference.prediction
      expect(prediction.surname.value).to be_nil
      expect(prediction.birth_date.value).to be_nil
      expect(prediction.gender.value).to be_nil
      expect(prediction.expiry_date.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_FR_ID_CARD_V1, 'summary_full.rst')
      response = load_json(DIR_FR_ID_CARD_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::FR::IdCardV1, response['document'])
      expect(document.inference.product.type).to eq('standard')
      prediction = document.inference.prediction
      expect(prediction.surname.value).to eq('DAMBARD')
      expect(prediction.birth_date.value).to eq('1994-04-24')
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page prediction' do
      to_string = read_file(DIR_FR_ID_CARD_V1, 'summary_page0.rst')
      response = load_json(DIR_FR_ID_CARD_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::FR::IdCardV1, response['document'])
      page = document.inference.pages[0]
      expect(page.to_s).to eq(to_string)
    end
  end
end
