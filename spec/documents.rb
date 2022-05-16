# frozen_string_literal: true

require 'json'

require 'mindee/documents'

DATA_DIR = File.join(__dir__, 'data').freeze

describe Mindee::Invoice do
  def load_json(file_path)
    file_data = File.read(File.join(DATA_DIR, file_path))
    JSON.parse(file_data)
  end

  context 'An Invoice' do
    it 'should load an empty document prediction' do
      response = load_json('invoice/response/invoice_all_na.json')
      document = Mindee::Invoice.new(response['document']['inference']['prediction'], nil)
      expect(document.document_type).to eq('invoice')
      expect(document.invoice_number.value).to be_nil
      expect(document.invoice_number.polygon).to be_empty
      expect(document.invoice_number.bbox).to be_nil
      expect(document.invoice_date.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = File.read(File.join(DATA_DIR, 'invoice/response/doc_to_string.txt')).strip
      response = load_json('invoice/response/invoice.json')
      document = Mindee::Invoice.new(response['document']['inference']['prediction'], nil)
      expect(document.orientation).to be_nil
      expect(document.invoice_number.bbox).to eq(document.invoice_number.polygon)
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page prediction' do
      to_string = File.read(File.join(DATA_DIR, 'invoice/response/page0_to_string.txt')).strip
      response = load_json('invoice/response/invoice.json')
      page_data = response['document']['inference']['pages'][0]
      document = Mindee::Invoice.new(page_data['prediction'], page_data['id'])
      expect(document.orientation.degrees).to eq(0)
      expect(document.to_s).to eq(to_string)
    end
  end

  context 'A Receipt' do
    to_string = File.read(File.join(DATA_DIR, 'receipt/response/to_string.txt')).strip

    it 'should load an empty document prediction' do
      response = load_json('receipt/response/receipt_all_na.json')
      document = Mindee::Receipt.new(response['document']['inference']['prediction'], nil)
      expect(document.document_type).to eq('receipt')
      expect(document.date.value).to be_nil
      expect(document.time.value).to be_nil
    end

    it 'should load a complete document prediction' do
      response = load_json('receipt/response/receipt.json')
      document = Mindee::Receipt.new(response['document']['inference']['prediction'], nil)
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page prediction' do
      response = load_json('receipt/response/receipt.json')
      page_data = response['document']['inference']['pages'][0]
      document = Mindee::Receipt.new(page_data['prediction'], page_data['id'])
      expect(document.orientation.degrees).to eq(0)
      expect(document.to_s).to eq(to_string)
    end
  end

  context 'A Passport' do
    to_string = File.read(File.join(DATA_DIR, 'passport/response/to_string.txt')).strip

    it 'should load an empty document prediction' do
      response = load_json('passport/response/passport_all_na.json')
      document = Mindee::Passport.new(response['document']['inference']['prediction'], nil)
      expect(document.document_type).to eq('passport')
      expect(document.expired?).to eq(true)
      expect(document.surname.value).to be_nil
      expect(document.birth_date.value).to be_nil
      expect(document.issuance_date.value).to be_nil
      expect(document.expiry_date.value).to be_nil
    end

    it 'should load a complete document prediction' do
      response = load_json('passport/response/passport.json')
      document = Mindee::Passport.new(response['document']['inference']['prediction'], nil)
      expect(document.all_checks).to eq(false)
      expect(document.id_number.confidence).to eq(1.0)
      expect(document.birth_date.confidence).to eq(1.0)
      expect(document.expiry_date.confidence).to eq(0.98)
      expect(document.expired?).to eq(false)
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page prediction' do
      response = load_json('passport/response/passport.json')
      page_data = response['document']['inference']['pages'][0]
      document = Mindee::Passport.new(page_data['prediction'], page_data['id'])
      expect(document.all_checks).to eq(false)
      expect(document.expired?).to eq(false)
      expect(document.to_s).to eq(to_string)
    end
  end

  context 'A custom document' do
    it 'should load a blank document prediction' do
      document = Mindee::CustomDocument.new('hello_world', {}, nil)
      expect(document.fields).to eq({})
    end

    it 'should load a blank page prediction' do
      document = Mindee::CustomDocument.new('hello_world', {}, 0)
      expect(document.fields).to eq({})
    end
  end
end
