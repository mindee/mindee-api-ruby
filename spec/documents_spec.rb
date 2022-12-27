# frozen_string_literal: true

require 'json'

require 'mindee/parsing'

require_relative 'data'

describe Mindee::Document do
  def load_json(dir_path, file_name)
    file_data = File.read(File.join(dir_path, file_name))
    JSON.parse(file_data)
  end

  def read_file(dir_path, file_name)
    File.read(File.join(dir_path, file_name)).strip
  end

  context 'An Invoice V3' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_INVOICE_V3, 'empty.json')
      inference = Mindee::Document.new(Mindee::InvoiceV3, response['document']).inference
      expect(inference.product.type).to eq('standard')
      expect(inference.prediction.invoice_number.value).to be_nil
      expect(inference.prediction.invoice_number.polygon).to be_empty
      expect(inference.prediction.invoice_number.bbox).to be_nil
      expect(inference.prediction.date.value).to be_nil
      expect(inference.prediction.date.page_id).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_INVOICE_V3, 'doc_to_string.txt')
      response = load_json(DIR_INVOICE_V3, 'complete.json')
      inference = Mindee::Document.new(Mindee::InvoiceV3, response['document']).inference
      expect(inference.prediction.invoice_number.bbox).to eq(inference.prediction.invoice_number.polygon)
      expect(inference.prediction.date.raw).to be_nil
      expect(inference.prediction.due_date.raw).to eq('2020-02-17')
      expect(inference.prediction.due_date.page_id).to eq(0)
      # expect(inference.to_s).to eq(to_string)
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_INVOICE_V3, 'page0_to_string.txt')
      response = load_json(DIR_INVOICE_V3, 'complete.json')
      inference = Mindee::Document.new(Mindee::InvoiceV3, response['document']).inference
      expect(inference.pages[0].orientation.value).to eq(0)
      expect(inference.pages[0].prediction.due_date.page_id).to eq(0)
      # expect(inference.pages[0].to_s).to eq(to_string)
    end
  end

  context 'A Receipt V3' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_RECEIPT_V3, 'empty.json')
      inference = Mindee::Document.new(Mindee::ReceiptV3, response['document']).inference
      expect(inference.product.type).to eq('standard')
      expect(inference.prediction.date.value).to be_nil
      expect(inference.prediction.date.page_id).to be_nil
      expect(inference.prediction.time.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_RECEIPT_V3, 'doc_to_string.txt')
      response = load_json(DIR_RECEIPT_V3, 'complete.json')
      inference = Mindee::Document.new(Mindee::ReceiptV3, response['document']).inference
      expect(inference.prediction.date.page_id).to eq(0)
      expect(inference.prediction.date.raw).to eq('26-Feb-2016')
      # expect(inference.prediction.to_s).to eq(to_string)
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_RECEIPT_V3, 'page0_to_string.txt')
      response = load_json(DIR_RECEIPT_V3, 'complete.json')
      inference = Mindee::Document.new(Mindee::ReceiptV3, response['document']).inference
      expect(inference.pages[0].orientation.value).to eq(0)
      expect(inference.pages[0].prediction.date.page_id).to eq(0)
      # expect(inference.pages[0].to_s).to eq(to_string)
    end
  end

  context 'A Passport V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_PASSPORT_V1, 'empty.json')
      inference = Mindee::Document.new(Mindee::PassportV1, response['document']).inference
      expect(inference.product.type).to eq('standard')
      expect(inference.prediction.expired?).to eq(true)
      expect(inference.prediction.surname.value).to be_nil
      expect(inference.prediction.birth_date.value).to be_nil
      expect(inference.prediction.issuance_date.value).to be_nil
      expect(inference.prediction.expiry_date.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_PASSPORT_V1, 'doc_to_string.txt')
      response = load_json(DIR_PASSPORT_V1, 'complete.json')
      inference = Mindee::Document.new(Mindee::PassportV1, response['document']).inference
      expect(inference.prediction.all_checks).to eq(false)

      expect(inference.prediction.checklist[:mrz_valid]).to eq(true)
      expect(inference.prediction.mrz.confidence).to eq(1.0)

      expect(inference.prediction.checklist[:mrz_valid_birth_date]).to eq(true)
      expect(inference.prediction.birth_date.confidence).to eq(1.0)

      expect(inference.prediction.checklist[:mrz_valid_expiry_date]).to eq(false)
      expect(inference.prediction.expiry_date.confidence).to eq(0.98)

      expect(inference.prediction.checklist[:mrz_valid_id_number]).to eq(true)
      expect(inference.prediction.id_number.confidence).to eq(1.0)

      expect(inference.prediction.checklist[:mrz_valid_surname]).to eq(true)
      expect(inference.prediction.surname.confidence).to eq(1.0)

      expect(inference.prediction.checklist[:mrz_valid_country]).to eq(true)
      expect(inference.prediction.country.confidence).to eq(1.0)

      expect(inference.prediction.expired?).to eq(false)
      # expect(inference.prediction.to_s).to eq(to_string)
    end

    it 'should load a complete page prediction' do
      to_string = read_file(DIR_PASSPORT_V1, 'page0_to_string.txt')
      response = load_json(DIR_PASSPORT_V1, 'complete.json')
      inference = Mindee::Document.new(Mindee::PassportV1, response['document']).inference
      expect(inference.prediction.all_checks).to eq(false)
      expect(inference.prediction.expired?).to eq(false)
      # expect(inference.prediction.to_s).to eq(to_string)
    end
  end

  context 'A custom document V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_CUSTOM_V1, 'empty.json')
      inference = Mindee::Document.new(Mindee::CustomV1, response['document']).inference
      expect(inference.product.type).to eq('constructed')
      expect(inference.prediction.fields.length).to eq(10)
      expect(inference.prediction.classifications.length).to eq(1)
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_CUSTOM_V1, 'doc_to_string.txt')
      response = load_json(DIR_CUSTOM_V1, 'complete.json')
      inference = Mindee::Document.new(Mindee::CustomV1, response['document']).inference
      # expect(document.to_s).to eq(to_string)

      expect(inference.prediction.fields[:string_all].values.size).to eq(3)
      expect(inference.prediction.fields['string_all']).to be_nil
      expect(inference.prediction.fields[:string_all].contents_str).to eq('Mindee is awesome')
      expect(inference.prediction.fields[:string_all].contents_list).to eq(['Mindee', 'is', 'awesome'])

      expect(inference.prediction.classifications[:doc_type].value).to eq('type_b')
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_CUSTOM_V1, 'page0_to_string.txt')
      response = load_json(DIR_CUSTOM_V1, 'complete.json')
      inference = Mindee::Document.new(Mindee::CustomV1, response['document']).inference
      expect(inference.pages[0].prediction.fields[:string_all].contents_str(separator: '_')).to eq('Jenny_is_great')
      expect(inference.pages[0].prediction.fields[:string_all].contents_list).to eq(['Jenny', 'is', 'great'])
      # expect(inference.pages[0].to_s).to eq(to_string)
    end

    it 'should load a complete page 1 prediction' do
      to_string = read_file(DIR_CUSTOM_V1, 'page1_to_string.txt')
      response = load_json(DIR_CUSTOM_V1, 'complete.json')
      inference = Mindee::Document.new(Mindee::CustomV1, response['document']).inference
      # expect(inference.pages[0].to_s).to eq(to_string)
    end
  end
end
