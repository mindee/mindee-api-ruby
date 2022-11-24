# frozen_string_literal: true

require 'json'

require 'mindee/documents'

DATA_DIR = File.join(__dir__, 'data').freeze
DIR_INVOICE_V3 = File.join(DATA_DIR, 'invoice', 'response_v3').freeze
DIR_RECEIPT_V3 = File.join(DATA_DIR, 'receipt', 'response_v3').freeze
DIR_PASSPORT_V1 = File.join(DATA_DIR, 'passport', 'response_v1').freeze
DIR_CUSTOM_V1 = File.join(DATA_DIR, 'custom', 'response_v1').freeze

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
      document = Mindee::Invoice.new(response['document']['inference']['prediction'])
      expect(document.document_type).to eq('invoice')
      expect(document.invoice_number.value).to be_nil
      expect(document.invoice_number.polygon).to be_empty
      expect(document.invoice_number.bbox).to be_nil
      expect(document.date.value).to be_nil
      expect(document.date.page_id).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_INVOICE_V3, 'doc_to_string.txt')
      response = load_json(DIR_INVOICE_V3, 'complete.json')
      document = Mindee::Invoice.new(response['document']['inference']['prediction'])
      expect(document.orientation).to be_nil
      expect(document.invoice_number.bbox).to eq(document.invoice_number.polygon)
      expect(document.to_s).to eq(to_string)
      expect(document.date.raw).to be_nil
      expect(document.due_date.raw).to eq('2020-02-17')
      expect(document.due_date.page_id).to eq(0)
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_INVOICE_V3, 'page0_to_string.txt')
      response = load_json(DIR_INVOICE_V3, 'complete.json')
      page_data = response['document']['inference']['pages'][0]
      document = Mindee::Invoice.new(page_data['prediction'], page_id: page_data['id'])
      expect(document.orientation.degrees).to eq(0)
      expect(document.due_date.page_id).to eq(0)
      expect(document.to_s).to eq(to_string)
    end
  end

  context 'A Receipt V3' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_RECEIPT_V3, 'empty.json')
      document = Mindee::Receipt.new(response['document']['inference']['prediction'])
      expect(document.document_type).to eq('receipt')
      expect(document.date.value).to be_nil
      expect(document.date.page_id).to be_nil
      expect(document.time.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_RECEIPT_V3, 'doc_to_string.txt')
      response = load_json(DIR_RECEIPT_V3, 'complete.json')
      document = Mindee::Receipt.new(response['document']['inference']['prediction'])
      expect(document.date.page_id).to eq(0)
      expect(document.date.raw).to eq('26-Feb-2016')
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_RECEIPT_V3, 'page0_to_string.txt')
      response = load_json(DIR_RECEIPT_V3, 'complete.json')
      page_data = response['document']['inference']['pages'][0]
      document = Mindee::Receipt.new(page_data['prediction'], page_id: page_data['id'])
      expect(document.orientation.degrees).to eq(0)
      expect(document.date.page_id).to eq(0)
      expect(document.to_s).to eq(to_string)
    end
  end

  context 'A Passport V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_PASSPORT_V1, 'empty.json')
      document = Mindee::Passport.new(response['document']['inference']['prediction'])
      expect(document.document_type).to eq('passport')
      expect(document.expired?).to eq(true)
      expect(document.surname.value).to be_nil
      expect(document.birth_date.value).to be_nil
      expect(document.issuance_date.value).to be_nil
      expect(document.expiry_date.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_PASSPORT_V1, 'doc_to_string.txt')
      response = load_json(DIR_PASSPORT_V1, 'complete.json')
      prediction = response['document']['inference']['prediction']
      document = Mindee::Passport.new(prediction)
      expect(document.all_checks).to eq(false)

      expect(document.checklist[:mrz_valid]).to eq(true)
      expect(document.mrz.confidence).to eq(1.0)

      expect(document.checklist[:mrz_valid_birth_date]).to eq(true)
      expect(document.birth_date.confidence).to eq(1.0)

      expect(document.checklist[:mrz_valid_expiry_date]).to eq(false)
      expect(document.expiry_date.confidence).to eq(0.98)

      expect(document.checklist[:mrz_valid_id_number]).to eq(true)
      expect(document.id_number.confidence).to eq(1.0)

      expect(document.checklist[:mrz_valid_surname]).to eq(true)
      expect(document.surname.confidence).to eq(1.0)

      expect(document.checklist[:mrz_valid_country]).to eq(true)
      expect(document.country.confidence).to eq(1.0)

      expect(document.expired?).to eq(false)
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page prediction' do
      to_string = read_file(DIR_PASSPORT_V1, 'page0_to_string.txt')
      response = load_json(DIR_PASSPORT_V1, 'complete.json')
      page_data = response['document']['inference']['pages'][0]
      document = Mindee::Passport.new(page_data['prediction'], page_id: page_data['id'])
      expect(document.all_checks).to eq(false)
      expect(document.expired?).to eq(false)
      expect(document.to_s).to eq(to_string)
    end
  end

  context 'A custom document V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_CUSTOM_V1, 'empty.json')
      prediction = response['document']['inference']['prediction']
      document = Mindee::CustomDocument.new('field_test', prediction)
      expect(document.document_type).to eq('field_test')
      expect(document.fields.length).to eq(10)
      expect(document.classifications.length).to eq(1)
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_CUSTOM_V1, 'doc_to_string.txt')
      response = load_json(DIR_CUSTOM_V1, 'complete.json')
      prediction = response['document']['inference']['prediction']
      document = Mindee::CustomDocument.new('field_test', prediction)
      expect(document.to_s).to eq(to_string)

      expect(document.fields[:string_all].values.size).to eq(3)
      expect(document.fields['string_all']).to be_nil
      expect(document.string_all.contents_str).to eq('Mindee is awesome')
      expect(document.string_all.contents_list).to eq(['Mindee', 'is', 'awesome'])

      expect(document.classifications[:doc_type].value).to eq('type_b')
      expect(document.doc_type.value).to eq('type_b')
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_CUSTOM_V1, 'page0_to_string.txt')
      response = load_json(DIR_CUSTOM_V1, 'complete.json')
      page_data = response['document']['inference']['pages'][0]
      document = Mindee::CustomDocument.new('field_test', page_data['prediction'], page_id: page_data['id'])
      expect(document.to_s).to eq(to_string)
      expect(document.string_all.contents_str(separator: '_')).to eq('Jenny_is_great')
      expect(document.string_all.contents_list).to eq(['Jenny', 'is', 'great'])
    end

    it 'should load a complete page 1 prediction' do
      to_string = read_file(DIR_CUSTOM_V1, 'page1_to_string.txt')
      response = load_json(DIR_CUSTOM_V1, 'complete.json')
      page_data = response['document']['inference']['pages'][1]
      document = Mindee::CustomDocument.new('field_test', page_data['prediction'], page_id: page_data['id'])
      expect(document.to_s).to eq(to_string)
    end
  end
end
