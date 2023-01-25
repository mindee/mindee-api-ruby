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

  context 'A FinancialDocumentV1' do
    context 'when processing an invoice' do
      it 'should load an empty document prediction' do
        response = load_json(DIR_FINANCIAL_DOCUMENT_V1, 'empty.json')
        document = Mindee::Document.new(Mindee::Prediction::FinancialDocumentV1, response['document'])
        expect(document.inference.product.type).to eq('standard')
        prediction = document.inference.prediction
        expect(prediction.invoice_number.value).to be_nil
        expect(prediction.invoice_number.polygon).to be_empty
        expect(prediction.invoice_number.bounding_box).to be_nil
        expect(prediction.date.value).to be_nil
        expect(prediction.date.page_id).to eq(0)
      end

      it 'should load a complete document prediction' do
        to_string = read_file(DIR_FINANCIAL_DOCUMENT_V1, 'summary_full_invoice.rst')
        response = load_json(DIR_FINANCIAL_DOCUMENT_V1, 'complete_invoice.json')
        document = Mindee::Document.new(Mindee::Prediction::FinancialDocumentV1, response['document'])
        prediction = document.inference.prediction
        expect(prediction.invoice_number.bounding_box.top_left.x).to eq(prediction.invoice_number.polygon[0][0])
        expect(prediction.date.value).to eq('2019-02-11')
        expect(prediction.due_date.value).to eq('2019-02-26')
        expect(prediction.due_date.page_id).to eq(0)
        expect(document.to_s).to eq(to_string)
      end

      it 'should load a complete page 0 prediction' do
        to_string = read_file(DIR_FINANCIAL_DOCUMENT_V1, 'summary_page0_invoice.rst')
        response = load_json(DIR_FINANCIAL_DOCUMENT_V1, 'complete_invoice.json')
        document = Mindee::Document.new(Mindee::Prediction::FinancialDocumentV1, response['document'])
        page = document.inference.pages[0]
        expect(page.orientation.value).to eq(0)
        expect(page.prediction.due_date.page_id).to eq(0)
        expect(page.to_s).to eq(to_string)
      end
    end

    context 'when processing a receipt' do
      it 'should load an empty document prediction' do
        response = load_json(DIR_FINANCIAL_DOCUMENT_V1, 'empty.json')
        inference = Mindee::Document.new(Mindee::Prediction::FinancialDocumentV1, response['document']).inference
        expect(inference.product.type).to eq('standard')
        expect(inference.prediction.date.value).to be_nil
        expect(inference.prediction.date.page_id).to eq(0)
        expect(inference.prediction.time.value).to be_nil
      end

      it 'should load a complete document prediction' do
        to_string = read_file(DIR_FINANCIAL_DOCUMENT_V1, 'summary_full_receipt.rst')
        response = load_json(DIR_FINANCIAL_DOCUMENT_V1, 'complete_receipt.json')
        document = Mindee::Document.new(Mindee::Prediction::FinancialDocumentV1, response['document'])
        expect(document.inference.prediction.date.page_id).to eq(0)
        expect(document.inference.prediction.date.value).to eq('2014-07-07')
        expect(document.to_s).to eq(to_string)
      end

      it 'should load a complete page 0 prediction' do
        to_string = read_file(DIR_FINANCIAL_DOCUMENT_V1, 'summary_page0_receipt.rst')
        response = load_json(DIR_FINANCIAL_DOCUMENT_V1, 'complete_receipt.json')
        document = Mindee::Document.new(Mindee::Prediction::FinancialDocumentV1, response['document'])
        page = document.inference.pages[0]
        expect(page.orientation.value).to eq(0)
        expect(page.prediction.date.page_id).to eq(0)
        expect(page.to_s).to eq(to_string)
      end
    end
  end
  context 'An Invoice V4' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_INVOICE_V4, 'empty.json')
      document = Mindee::Document.new(Mindee::Prediction::InvoiceV4, response['document'])
      expect(document.inference.product.type).to eq('standard')
      prediction = document.inference.prediction
      expect(prediction.invoice_number.value).to be_nil
      expect(prediction.invoice_number.polygon).to be_empty
      expect(prediction.invoice_number.bounding_box).to be_nil
      expect(prediction.date.value).to be_nil
      expect(prediction.date.page_id).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_INVOICE_V4, 'summary_full.rst')
      response = load_json(DIR_INVOICE_V4, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::InvoiceV4, response['document'])
      prediction = document.inference.prediction
      expect(prediction.invoice_number.bounding_box.top_left.x).to eq(prediction.invoice_number.polygon[0][0])
      expect(prediction.date.value).to eq('2020-02-17')
      expect(prediction.due_date.value).to eq('2020-02-17')
      expect(prediction.due_date.page_id).to eq(0)
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_INVOICE_V4, 'summary_page0.rst')
      response = load_json(DIR_INVOICE_V4, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::InvoiceV4, response['document'])
      page = document.inference.pages[0]
      expect(page.orientation.value).to eq(0)
      expect(page.prediction.due_date.page_id).to eq(0)
      expect(page.to_s).to eq(to_string)
    end
  end

  context 'A Receipt V4' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_RECEIPT_V4, 'empty.json')
      inference = Mindee::Document.new(Mindee::Prediction::ReceiptV4, response['document']).inference
      expect(inference.product.type).to eq('standard')
      expect(inference.prediction.date.value).to be_nil
      expect(inference.prediction.date.page_id).to be_nil
      expect(inference.prediction.time.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_RECEIPT_V4, 'summary_full.rst')
      response = load_json(DIR_RECEIPT_V4, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::ReceiptV4, response['document'])
      expect(document.inference.prediction.date.page_id).to eq(0)
      expect(document.inference.prediction.date.value).to eq('2014-07-07')
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_RECEIPT_V4, 'summary_page0.rst')
      response = load_json(DIR_RECEIPT_V4, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::ReceiptV4, response['document'])
      page = document.inference.pages[0]
      expect(page.orientation.value).to eq(0)
      expect(page.prediction.date.page_id).to eq(0)
      expect(page.to_s).to eq(to_string)
    end
  end

  context 'A Passport V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_PASSPORT_V1, 'empty.json')
      inference = Mindee::Document.new(Mindee::Prediction::PassportV1, response['document']).inference
      expect(inference.product.type).to eq('standard')
      expect(inference.prediction.expired?).to eq(true)
      expect(inference.prediction.surname.value).to be_nil
      expect(inference.prediction.birth_date.value).to be_nil
      expect(inference.prediction.issuance_date.value).to be_nil
      expect(inference.prediction.expiry_date.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_PASSPORT_V1, 'summary_full.rst')
      response = load_json(DIR_PASSPORT_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::PassportV1, response['document'])
      prediction = document.inference.prediction
      expect(prediction.all_checks).to eq(false)

      expect(prediction.checklist[:mrz_valid]).to eq(true)
      expect(prediction.mrz.confidence).to eq(1.0)

      expect(prediction.checklist[:mrz_valid_birth_date]).to eq(true)
      expect(prediction.birth_date.confidence).to eq(1.0)

      expect(prediction.checklist[:mrz_valid_expiry_date]).to eq(false)
      expect(prediction.expiry_date.confidence).to eq(0.98)

      expect(prediction.checklist[:mrz_valid_id_number]).to eq(true)
      expect(prediction.id_number.confidence).to eq(1.0)

      expect(prediction.checklist[:mrz_valid_surname]).to eq(true)
      expect(prediction.surname.confidence).to eq(1.0)

      expect(prediction.checklist[:mrz_valid_country]).to eq(true)
      expect(prediction.country.confidence).to eq(1.0)

      expect(prediction.expired?).to eq(false)
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page prediction' do
      to_string = read_file(DIR_PASSPORT_V1, 'summary_page0.rst')
      response = load_json(DIR_PASSPORT_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::PassportV1, response['document'])
      page = document.inference.pages[0]
      expect(page.prediction.all_checks).to eq(false)
      expect(page.prediction.expired?).to eq(false)
      expect(page.to_s).to eq(to_string)
    end
  end

  context 'A License Plate V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_EU_LICENSE_PLATE_V1, 'empty.json')
      inference = Mindee::Document.new(Mindee::Prediction::EU::LicensePlateV1, response['document']).inference
      expect(inference.product.type).to eq('standard')
      expect(inference.prediction.license_plates.size).to eq(2)
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_EU_LICENSE_PLATE_V1, 'summary_full.rst')
      response = load_json(DIR_EU_LICENSE_PLATE_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::EU::LicensePlateV1, response['document'])
      inference = document.inference
      expect(inference.prediction.license_plates.size).to eq(2)
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_EU_LICENSE_PLATE_V1, 'summary_page0.rst')
      response = load_json(DIR_EU_LICENSE_PLATE_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::EU::LicensePlateV1, response['document'])
      page = document.inference.pages[0]
      expect(page.prediction.license_plates.size).to eq(2)
      expect(page.to_s).to eq(to_string)
    end
  end

  context 'A Shipping Container V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_SHIPPING_CONTAINER_V1, 'empty.json')
      inference = Mindee::Document.new(Mindee::Prediction::ShippingContainerV1, response['document']).inference
      expect(inference.product.type).to eq('standard')
      expect(inference.prediction.owner.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_SHIPPING_CONTAINER_V1, 'summary_full.rst')
      response = load_json(DIR_SHIPPING_CONTAINER_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::ShippingContainerV1, response['document'])
      inference = document.inference
      expect(inference.prediction.owner.value).to eq('MMAU')
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_SHIPPING_CONTAINER_V1, 'summary_page0.rst')
      response = load_json(DIR_SHIPPING_CONTAINER_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::ShippingContainerV1, response['document'])
      page = document.inference.pages[0]
      expect(page.prediction.owner.value).to eq('MMAU')
      expect(page.to_s).to eq(to_string)
    end
  end

  context 'A US Bank Check V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_US_BANK_CHECK_V1, 'empty.json')
      inference = Mindee::Document.new(Mindee::Prediction::US::BankCheckV1, response['document']).inference
      expect(inference.product.type).to eq('standard')
      expect(inference.prediction.account_number.value).to be_nil
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_US_BANK_CHECK_V1, 'summary_full.rst')
      response = load_json(DIR_US_BANK_CHECK_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::US::BankCheckV1, response['document'])
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
      document = Mindee::Document.new(Mindee::Prediction::US::BankCheckV1, response['document'])
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

  context 'A custom document V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_CUSTOM_V1, 'empty.json')
      inference = Mindee::Document.new(Mindee::Prediction::CustomV1, response['document']).inference
      expect(inference.product.type).to eq('constructed')
      expect(inference.prediction.fields.length).to eq(10)
      expect(inference.prediction.classifications.length).to eq(1)
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_CUSTOM_V1, 'summary_full.rst')
      response = load_json(DIR_CUSTOM_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Prediction::CustomV1, response['document'])
      expect(document.to_s).to eq(to_string)
      prediction = document.inference.prediction

      prediction.fields.each do |field_name, field_data|
        expect(field_name).to be_kind_of(Symbol)
        expect(field_data.values).to be_kind_of(Array)
        expect(field_data.contents_str).to be_kind_of(String)
      end

      expect(prediction.fields[:string_all].values.size).to eq(3)
      expect(prediction.fields['string_all']).to be_nil
      expect(prediction.fields[:string_all].contents_str).to eq('Mindee is awesome')
      expect(prediction.fields[:string_all].contents_list).to eq(['Mindee', 'is', 'awesome'])

      expect(prediction.classifications[:doc_type].value).to eq('type_b')
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_CUSTOM_V1, 'summary_page0.rst')
      response = load_json(DIR_CUSTOM_V1, 'complete.json')
      inference = Mindee::Document.new(Mindee::Prediction::CustomV1, response['document']).inference
      expect(inference.pages[0].prediction.fields[:string_all].contents_str(separator: '_')).to eq('Jenny_is_great')
      expect(inference.pages[0].prediction.fields[:string_all].contents_list).to eq(['Jenny', 'is', 'great'])
      expect(inference.pages[0].to_s).to eq(to_string)
    end

    it 'should load a complete page 1 prediction' do
      to_string = read_file(DIR_CUSTOM_V1, 'summary_page1.rst')
      response = load_json(DIR_CUSTOM_V1, 'complete.json')
      inference = Mindee::Document.new(Mindee::Prediction::CustomV1, response['document']).inference
      expect(inference.pages[1].to_s).to eq(to_string)
    end
  end
end
