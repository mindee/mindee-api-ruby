# frozen_string_literal: true

require 'json'

require 'mindee/documents'

DATA_DIR = File.join(__dir__, 'data').freeze

describe Mindee::Document do
  def load_json(file_path)
    file_data = File.read(File.join(DATA_DIR, file_path))
    JSON.parse(file_data)
  end

  context 'An Invoice' do
    it 'should load an empty document prediction' do
      response = load_json('invoice/response/empty.json')
      document = Mindee::Invoice.new(response['document']['inference']['prediction'])
      expect(document.document_type).to eq('invoice')
      expect(document.invoice_number.value).to be_nil
      expect(document.invoice_number.polygon).to be_empty
      expect(document.invoice_number.bbox).to be_nil
      expect(document.invoice_date.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = File.read(File.join(DATA_DIR, 'invoice/response/doc_to_string.txt')).strip
      response = load_json('invoice/response/complete.json')
      document = Mindee::Invoice.new(response['document']['inference']['prediction'])
      expect(document.orientation).to be_nil
      expect(document.invoice_number.bbox).to eq(document.invoice_number.polygon)
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page 0 prediction' do
      to_string = File.read(File.join(DATA_DIR, 'invoice/response/page0_to_string.txt')).strip
      response = load_json('invoice/response/complete.json')
      page_data = response['document']['inference']['pages'][0]
      document = Mindee::Invoice.new(page_data['prediction'], page_id: page_data['id'])
      expect(document.orientation.degrees).to eq(0)
      expect(document.to_s).to eq(to_string)
    end
  end

  context 'A Receipt' do
    it 'should load an empty document prediction' do
      response = load_json('receipt/response/empty.json')
      document = Mindee::Receipt.new(response['document']['inference']['prediction'])
      expect(document.document_type).to eq('receipt')
      expect(document.date.value).to be_nil
      expect(document.time.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = File.read(File.join(DATA_DIR, 'receipt/response/doc_to_string.txt')).strip
      response = load_json('receipt/response/complete.json')
      document = Mindee::Receipt.new(response['document']['inference']['prediction'])
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page 0 prediction' do
      to_string = File.read(File.join(DATA_DIR, 'receipt/response/page0_to_string.txt')).strip
      response = load_json('receipt/response/complete.json')
      page_data = response['document']['inference']['pages'][0]
      document = Mindee::Receipt.new(page_data['prediction'], page_id: page_data['id'])
      expect(document.orientation.degrees).to eq(0)
      expect(document.to_s).to eq(to_string)
    end
  end

  context 'A Passport' do
    it 'should load an empty document prediction' do
      response = load_json('passport/response/empty.json')
      document = Mindee::Passport.new(response['document']['inference']['prediction'])
      expect(document.document_type).to eq('passport')
      expect(document.expired?).to eq(true)
      expect(document.surname.value).to be_nil
      expect(document.birth_date.value).to be_nil
      expect(document.issuance_date.value).to be_nil
      expect(document.expiry_date.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = File.read(File.join(DATA_DIR, 'passport/response/doc_to_string.txt')).strip
      response = load_json('passport/response/complete.json')
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
      to_string = File.read(File.join(DATA_DIR, 'passport/response/page0_to_string.txt')).strip
      response = load_json('passport/response/complete.json')
      page_data = response['document']['inference']['pages'][0]
      document = Mindee::Passport.new(page_data['prediction'], page_id: page_data['id'])
      expect(document.all_checks).to eq(false)
      expect(document.expired?).to eq(false)
      expect(document.to_s).to eq(to_string)
    end
  end

  context 'A custom document' do
    it 'should load an empty document prediction' do
      response = load_json('custom/response/empty.json')
      prediction = response['document']['inference']['prediction']
      document = Mindee::CustomDocument.new('field_test', prediction)
      expect(document.document_type).to eq('field_test')
      expect(document.fields.length).to eq(10)
    end

    it 'should load a complete document prediction' do
      to_string = File.read(File.join(DATA_DIR, 'custom/response/doc_to_string.txt')).strip
      response = load_json('custom/response/complete.json')
      prediction = response['document']['inference']['prediction']
      document = Mindee::CustomDocument.new('field_test', prediction)
      expect(document.to_s).to eq(to_string)
      expect(document.string_all.contents_str).to eq('Mindee is awesome')
      expect(document.string_all.contents_list).to eq(['Mindee', 'is', 'awesome'])
    end

    it 'should load a complete page 0 prediction' do
      to_string = File.read(File.join(DATA_DIR, 'custom/response/page0_to_string.txt')).strip
      response = load_json('custom/response/complete.json')
      page_data = response['document']['inference']['pages'][0]
      document = Mindee::CustomDocument.new('field_test', page_data['prediction'], page_id: page_data['id'])
      expect(document.to_s).to eq(to_string)
      expect(document.string_all.contents_str(separator: '_')).to eq('Jenny_is_great')
      expect(document.string_all.contents_list).to eq(['Jenny', 'is', 'great'])
    end

    it 'should load a complete page 1 prediction' do
      to_string = File.read(File.join(DATA_DIR, 'custom/response/page1_to_string.txt')).strip
      response = load_json('custom/response/complete.json')
      page_data = response['document']['inference']['pages'][1]
      document = Mindee::CustomDocument.new('field_test', page_data['prediction'], page_id: page_data['id'])
      expect(document.to_s).to eq(to_string)
    end
  end
end
