# frozen_string_literal: true

require 'json'
require 'mindee'

require_relative '../data'

StringField = Mindee::Parsing::Standard.const_get(:StringField)
PositionField = Mindee::Parsing::Standard.const_get(:PositionField)
UniversalListField = Mindee::Parsing::Universal.const_get(:UniversalListField)
UniversalObjectField = Mindee::Parsing::Universal.const_get(:UniversalObjectField)
Universal = Mindee::Product::Universal.const_get(:Universal)
UniversalPage = Mindee::Product::Universal.const_get(:UniversalPage)
Document = Mindee::Parsing::Common.const_get(:Document)

describe 'International ID v1 document' do
  let(:international_id_v1_complete_doc) do
    parsed_file = JSON.parse(File.read(File.join(DATA_DIR,
                                                 'products',
                                                 'generated',
                                                 'response_v1',
                                                 'complete_international_id_v1.json')))
    Document.new(Universal,
                 parsed_file['document'])
  end

  let(:international_id_v1_empty_doc) do
    parsed_file = JSON.parse(File.read(File.join(DATA_DIR,
                                                 'products', 'generated', 'response_v1',
                                                 'empty_international_id_v1.json')))
    Document.new(Universal,
                 parsed_file['document'])
  end

  let(:international_id_v1_complete_doc_string) do
    File.read(File.join(DATA_DIR,
                        'products', 'generated', 'response_v1', 'summary_full_international_id_v1.rst'))
  end

  let(:international_id_v1_empty_doc_string) do
    File.read(File.join(DATA_DIR,
                        'products', 'generated', 'response_v1', 'summary_empty_international_id_v1.rst'))
  end

  describe 'Empty document' do
    it 'ensures all fields are empty' do
      prediction = international_id_v1_empty_doc.inference.prediction
      expect(prediction.fields['document_type'].value).to be_nil
      expect(prediction.fields['document_number'].value).to be_nil
      expect(prediction.fields['document_number']).to be_an_instance_of(StringField)
      expect(prediction.fields['document_number'].value).to be_nil

      expect(prediction.fields['country_of_issue']).to be_an_instance_of(StringField)
      expect(prediction.fields['country_of_issue'].value).to be_nil

      expect(prediction.fields['surnames']).to be_an_instance_of(UniversalListField)
      expect(prediction.fields['surnames'].values.length).to eq(0)

      expect(prediction.fields['given_names']).to be_an_instance_of(UniversalListField)
      expect(prediction.fields['given_names'].values.length).to eq(0)

      expect(prediction.fields['sex']).to be_an_instance_of(StringField)
      expect(prediction.fields['sex'].value).to be_nil

      expect(prediction.fields['birth_date']).to be_an_instance_of(StringField)
      expect(prediction.fields['birth_date'].value).to be_nil

      expect(prediction.fields['birth_place']).to be_an_instance_of(StringField)
      expect(prediction.fields['birth_place'].value).to be_nil

      expect(prediction.fields['nationality']).to be_an_instance_of(StringField)
      expect(prediction.fields['nationality'].value).to be_nil

      expect(prediction.fields['issue_date']).to be_an_instance_of(StringField)
      expect(prediction.fields['issue_date'].value).to be_nil

      expect(prediction.fields['expiry_date']).to be_an_instance_of(StringField)
      expect(prediction.fields['expiry_date'].value).to be_nil

      expect(prediction.fields['address']).to be_an_instance_of(StringField)
      expect(prediction.fields['address'].value).to be_nil

      expect(prediction.fields['mrz1']).to be_an_instance_of(StringField)
      expect(prediction.fields['mrz1'].value).to be_nil

      expect(prediction.fields['mrz2']).to be_an_instance_of(StringField)
      expect(prediction.fields['mrz2'].value).to be_nil

      expect(prediction.fields['mrz3']).to be_an_instance_of(StringField)
      expect(prediction.fields['mrz3'].value).to be_nil

      expect(international_id_v1_empty_doc.to_s.strip).to eq(international_id_v1_empty_doc_string.strip)
    end
  end

  describe 'Complete document' do
    it 'ensures all fields are populated correctly' do
      prediction = international_id_v1_complete_doc.inference.prediction
      expect(prediction.fields['document_type'].value).to eq('NATIONAL_ID_CARD')
      expect(prediction.fields['document_number'].value).to eq('99999999R')

      expect(
        prediction.fields['document_type']
      ).to be_an_instance_of(StringField)
      expect(
        prediction.fields[
          'document_type'
        ].value
      ).to eq('NATIONAL_ID_CARD')

      expect(
        prediction.fields['document_number']
      ).to be_an_instance_of(StringField)
      expect(
        prediction.fields[
          'document_number'
        ].value
      ).to eq('99999999R')

      expect(
        prediction.fields[
          'country_of_issue'
        ]
      ).to be_an_instance_of(StringField)
      expect(
        prediction.fields[
          'country_of_issue'
        ].value
      ).to eq('ESP')

      expect(
        prediction.fields['surnames']
      ).to be_an_instance_of(UniversalListField)
      expect(
        prediction.fields['surnames']
                  .values[0]
                  .value
      ).to eq('ESPAÑOLA')
      expect(
        prediction.fields['surnames']
                  .values[1]
                  .value
      ).to eq('ESPAÑOLA')

      expect(
        prediction.fields['given_names']
      ).to be_an_instance_of(UniversalListField)
      expect(
        prediction.fields['given_names']
                  .values[0]
                  .value
      ).to eq('CARMEN')

      expect(
        prediction.fields['sex']
      ).to be_an_instance_of(StringField)
      expect(
        prediction.fields['sex'].value
      ).to eq('F')

      expect(
        prediction.fields['birth_date']
      ).to be_an_instance_of(StringField)
      expect(
        prediction.fields['birth_date'].value
      ).to eq('1980-01-01')

      expect(
        prediction.fields['birth_place']
      ).to be_an_instance_of(StringField)
      expect(
        prediction.fields[
          'birth_place'
        ].value
      ).to eq('MADRID')

      expect(
        prediction.fields['nationality']
      ).to be_an_instance_of(StringField)
      expect(
        prediction.fields[
          'nationality'
        ].value
      ).to eq('ESP')

      expect(
        prediction.fields['issue_date']
      ).to be_an_instance_of(StringField)
      expect(
        prediction.fields['issue_date'].value
      ).to eq('2015-01-01')

      expect(
        prediction.fields['expiry_date']
      ).to be_an_instance_of(StringField)
      expect(
        prediction.fields[
          'expiry_date'
        ].value
      ).to eq('2025-01-01')

      expect(
        prediction.fields['address']
      ).to be_an_instance_of(StringField)
      expect(
        prediction.fields['address'].value
      ).to eq('AVDA DE MADRID S-N MADRID MADRID')

      expect(
        prediction.fields['mrz1']
      ).to be_an_instance_of(StringField)
      expect(
        prediction.fields['mrz1'].value
      ).to eq('IDESPBAA000589599999999R<<<<<<')
      expect(
        prediction.fields['mrz2']
      ).to be_an_instance_of(StringField)
      expect(
        prediction.fields['mrz2'].value
      ).to eq('8001014F2501017ESP<<<<<<<<<<<7')
      expect(
        prediction.fields['mrz3']
      ).to be_an_instance_of(StringField)
      expect(
        prediction.fields['mrz3'].value
      ).to eq('ESPANOLA<ESPANOLA<<CARMEN<<<<<<')

      expect(international_id_v1_complete_doc.to_s.strip).to eq(international_id_v1_complete_doc_string.strip)
    end
  end
end

describe 'Invoice V4 document' do
  let(:invoice_v4_complete_doc) do
    parsed_file = JSON.parse(File.read(File.join(DATA_DIR,
                                                 'products',
                                                 'generated',
                                                 'response_v1',
                                                 'complete_invoice_v4.json')))
    Document.new(Universal,
                 parsed_file['document'])
  end
  let(:invoice_v4_page0_doc) do
    parsed_file = JSON.parse(File.read(File.join(DATA_DIR,
                                                 'products',
                                                 'generated',
                                                 'response_v1',
                                                 'complete_invoice_v4.json')))
    UniversalPage.new(parsed_file['document']['inference']['pages'][0])
  end

  let(:invoice_v4_empty_doc) do
    parsed_file = JSON.parse(File.read(File.join(DATA_DIR,
                                                 'products', 'generated', 'response_v1',
                                                 'empty_invoice_v4.json')))
    Document.new(Universal,
                 parsed_file['document'])
  end

  let(:invoice_v4_complete_doc_string) do
    File.read(File.join(DATA_DIR,
                        'products', 'generated', 'response_v1', 'summary_full_invoice_v4.rst'))
  end
  let(:invoice_v4_page0_doc_string) do
    File.read(File.join(DATA_DIR,
                        'products', 'generated', 'response_v1', 'summary_page0_invoice_v4.rst'))
  end

  let(:invoice_v4_empty_doc_string) do
    File.read(File.join(DATA_DIR,
                        'products', 'generated', 'response_v1', 'summary_empty_invoice_v4.rst'))
  end
  describe 'Empty universal Invoice' do
    it 'ensures all fields are empty' do
      expect(
        invoice_v4_empty_doc.inference.prediction.fields['customer_address']
      ).to be_an_instance_of(StringField)
      expect(
        invoice_v4_empty_doc.inference.prediction.fields['customer_address'].value
      ).to be_nil
      expect(
        invoice_v4_empty_doc.inference.prediction.fields[
          'customer_company_registrations'
        ]
      ).to be_an_instance_of(UniversalListField)
      expect(
        invoice_v4_empty_doc.inference.prediction.fields[
          'customer_company_registrations'
        ].values.length
      ).to eq(0)

      expect(
        invoice_v4_empty_doc.inference.prediction.fields['customer_name']
      ).to be_an_instance_of(StringField)
      expect(
        invoice_v4_empty_doc.inference.prediction.fields['customer_name'].value
      ).to be_nil

      expect(
        invoice_v4_empty_doc.inference.prediction.fields['date']
      ).to be_an_instance_of(StringField)
      expect(invoice_v4_empty_doc.inference.prediction.fields['date'].value).to be_nil

      expect(
        invoice_v4_empty_doc.inference.prediction.fields['document_type']
      ).to be_an_instance_of(StringField)
      expect(
        invoice_v4_empty_doc.inference.prediction.fields['document_type'].value
      ).to eq('INVOICE')

      expect(
        invoice_v4_empty_doc.inference.prediction.fields['due_date']
      ).to be_an_instance_of(StringField)
      expect(invoice_v4_empty_doc.inference.prediction.fields['due_date'].value).to be_nil

      expect(
        invoice_v4_empty_doc.inference.prediction.fields['invoice_number']
      ).to be_an_instance_of(StringField)
      expect(
        invoice_v4_empty_doc.inference.prediction.fields['invoice_number'].value
      ).to be_nil

      expect(
        invoice_v4_empty_doc.inference.prediction.fields['line_items']
      ).to be_an_instance_of(UniversalListField)
      expect(invoice_v4_empty_doc.inference.prediction.fields['line_items'].values.length).to eq(0)

      expect(
        invoice_v4_empty_doc.inference.prediction.fields['locale']
      ).to be_an_instance_of(UniversalObjectField)
      expect(invoice_v4_empty_doc.inference.prediction.fields['locale'].currency).to be_nil
      expect(invoice_v4_empty_doc.inference.prediction.fields['locale'].language).to be_nil

      expect(
        invoice_v4_empty_doc.inference.prediction.fields['reference_numbers']
      ).to be_an_instance_of(UniversalListField)
      expect(
        invoice_v4_empty_doc.inference.prediction.fields['reference_numbers'].values.length
      ).to eq(0)

      expect(
        invoice_v4_empty_doc.inference.prediction.fields['supplier_address']
      ).to be_an_instance_of(StringField)
      expect(
        invoice_v4_empty_doc.inference.prediction.fields['supplier_address'].value
      ).to be_nil
      expect(
        invoice_v4_empty_doc.inference.prediction.fields[
          'supplier_company_registrations'
        ]
      ).to be_an_instance_of(UniversalListField)
      expect(
        invoice_v4_empty_doc.inference.prediction.fields[
          'supplier_company_registrations'].values.length
      ).to eq(0)

      expect(
        invoice_v4_empty_doc.inference.prediction.fields['supplier_name']
      ).to be_an_instance_of(StringField)
      expect(
        invoice_v4_empty_doc.inference.prediction.fields['supplier_name'].value
      ).to be_nil

      expect(
        invoice_v4_empty_doc.inference.prediction.fields['supplier_payment_details']
      ).to be_an_instance_of(UniversalListField)
      expect(
        invoice_v4_empty_doc.inference.prediction.fields[
          'supplier_payment_details'
        ].values.length
      ).to eq(0)

      expect(
        invoice_v4_empty_doc.inference.prediction.fields['taxes']
      ).to be_an_instance_of(UniversalListField)
      expect(invoice_v4_empty_doc.inference.prediction.fields['taxes'].values.length).to eq(0)

      expect(
        invoice_v4_empty_doc.inference.prediction.fields['total_amount']
      ).to be_an_instance_of(StringField)
      expect(
        invoice_v4_empty_doc.inference.prediction.fields['total_amount'].value
      ).to be_nil

      expect(
        invoice_v4_empty_doc.inference.prediction.fields['total_net']
      ).to be_an_instance_of(StringField)

      expect(invoice_v4_empty_doc.to_s.strip).to eq(invoice_v4_empty_doc_string.strip)
    end
  end

  describe 'Complete universal Invoice' do
    it 'ensures all fields are populated correctly' do
      prediction = invoice_v4_complete_doc.inference.prediction
      expect(prediction.fields['customer_address']).to be_an_instance_of(StringField)
      expect(prediction.fields['customer_address'].value).to eq('1954 Bloon Street West Toronto, ON, M6P 3K9 Canada')

      expect(prediction.fields['customer_company_registrations']).to be_an_instance_of(UniversalListField)
      expect(prediction.fields['customer_company_registrations'].values.length).to eq(0)

      expect(prediction.fields['customer_name']).to be_an_instance_of(StringField)
      expect(prediction.fields['customer_name'].value).to eq('JIRO DOI')

      expect(prediction.fields['date']).to be_an_instance_of(StringField)
      expect(prediction.fields['date'].value).to eq('2020-02-17')

      expect(prediction.fields['document_type']).to be_an_instance_of(StringField)
      expect(prediction.fields['document_type'].value).to eq('INVOICE')

      expect(prediction.fields['due_date']).to be_an_instance_of(StringField)
      expect(prediction.fields['due_date'].value).to eq('2020-02-17')

      expect(prediction.fields['invoice_number']).to be_an_instance_of(StringField)
      expect(prediction.fields['invoice_number'].value).to eq('0042004801351')

      expect(prediction.fields['line_items']).to be_an_instance_of(UniversalListField)
      expect(prediction.fields['line_items'].values[0]).to be_an_instance_of(UniversalObjectField)
      expect(prediction.fields['line_items'].values[0].description).to eq('S)BOIE 5X500 FEUILLES A4')
      expect(prediction.fields['line_items'].values[0].product_code).to be_nil
      expect(prediction.fields['line_items'].values[0].quantity).to be_nil
      expect(prediction.fields['line_items'].values[6].quantity).to eq('1.0')
      expect(prediction.fields['line_items'].values[0].tax_amount).to be_nil
      expect(prediction.fields['line_items'].values[0].tax_rate).to be_nil
      expect(prediction.fields['line_items'].values[0].total_amount).to eq('2.63')
      expect(prediction.fields['line_items'].values[0].unit_price).to be_nil
      expect(prediction.fields['line_items'].values[6].unit_price).to eq('65.0')

      expect(prediction.fields['locale']).to be_an_instance_of(UniversalObjectField)
      expect(prediction.fields['locale'].currency).to eq('EUR')
      expect(prediction.fields['locale'].language).to eq('fr')

      expect(prediction.fields['reference_numbers']).to be_an_instance_of(UniversalListField)
      expect(prediction.fields['reference_numbers'].values[0].value).to eq('AD29094')

      expect(prediction.fields['supplier_address']).to be_an_instance_of(StringField)
      expect(prediction.fields['supplier_address'].value).to eq('156 University Ave, Toronto ON, Canada M5H 2H7')
      expect(prediction.fields['supplier_company_registrations']).to be_an_instance_of(UniversalListField)
      expect(prediction.fields['supplier_company_registrations'].values.length).to eq(0)

      expect(prediction.fields['supplier_name']).to be_an_instance_of(StringField)
      expect(prediction.fields['supplier_name'].value).to eq('TURNPIKE DESIGNS CO.')

      expect(prediction.fields['supplier_payment_details']).to be_an_instance_of(UniversalListField)
      expect(prediction.fields['supplier_payment_details'].values[0].iban).to eq('FR7640254025476501124705368')

      expect(prediction.fields['taxes']).to be_an_instance_of(UniversalListField)
      expect(prediction.fields['taxes'].values[0].polygon).to be_an_instance_of(PositionField)
      expect(
        prediction.fields['taxes'].values[0].polygon.value.map do |point|
          [point.x, point.y]
        end
      ).to eq([[0.292, 0.749], [0.543, 0.749], [0.543, 0.763], [0.292, 0.763]])
      expect(prediction.fields['taxes'].values[0].rate).to eq('20.0')
      expect(prediction.fields['taxes'].values[0].value).to eq('97.98')

      expect(prediction.fields['total_amount']).to be_an_instance_of(StringField)
      expect(prediction.fields['total_amount'].value).to eq('587.95')

      expect(prediction.fields['total_net']).to be_an_instance_of(StringField)
      expect(prediction.fields['total_net'].value).to eq('489.97')
      expect(invoice_v4_complete_doc.to_s.strip).to eq(invoice_v4_complete_doc_string.strip)
    end
    it 'ensures the first page is loaded properly' do
      prediction = invoice_v4_page0_doc.prediction
      expect(prediction.fields['customer_address']).to be_an_instance_of(StringField)
      expect(prediction.fields['customer_address'].value).to be_nil
      expect(prediction.fields['customer_company_registrations']).to be_an_instance_of(UniversalListField)
      expect(prediction.fields['customer_company_registrations'].values.length).to eq(0)

      expect(prediction.fields['customer_name']).to be_an_instance_of(StringField)
      expect(prediction.fields['customer_name'].value).to be_nil

      expect(prediction.fields['date']).to be_an_instance_of(StringField)
      expect(prediction.fields['date'].value).to eq('2020-02-17')

      expect(prediction.fields['document_type']).to be_an_instance_of(StringField)
      expect(prediction.fields['document_type'].value).to eq('INVOICE')

      expect(prediction.fields['due_date']).to be_an_instance_of(StringField)
      expect(prediction.fields['due_date'].value).to eq('2020-02-17')

      expect(prediction.fields['invoice_number']).to be_an_instance_of(StringField)
      expect(prediction.fields['invoice_number'].value).to eq('0042004801351')

      expect(prediction.fields['line_items']).to be_an_instance_of(UniversalListField)
      expect(prediction.fields['line_items'].values[0]).to be_an_instance_of(UniversalObjectField)
      expect(prediction.fields['line_items'].values[0].description).to eq('S)BOIE 5X500 FEUILLES A4')
      expect(prediction.fields['line_items'].values[0].product_code).to be_nil
      expect(prediction.fields['line_items'].values[0].quantity).to be_nil
      expect(prediction.fields['line_items'].values[0].tax_amount).to be_nil
      expect(prediction.fields['line_items'].values[0].tax_rate).to be_nil
      expect(prediction.fields['line_items'].values[0].total_amount).to eq('2.63')
      expect(prediction.fields['line_items'].values[0].unit_price).to be_nil

      expect(prediction.fields['locale']).to be_an_instance_of(UniversalObjectField)
      expect(prediction.fields['locale'].currency).to eq('EUR')
      expect(prediction.fields['locale'].language).to eq('fr')

      expect(prediction.fields['reference_numbers']).to be_an_instance_of(UniversalListField)
      expect(prediction.fields['reference_numbers'].values.length).to eq(0)

      expect(prediction.fields['supplier_address']).to be_an_instance_of(StringField)
      expect(prediction.fields['supplier_address'].value).to be_nil
      expect(prediction.fields['supplier_company_registrations']).to be_an_instance_of(UniversalListField)
      expect(prediction.fields['supplier_company_registrations'].values.length).to eq(0)

      expect(prediction.fields['supplier_name']).to be_an_instance_of(StringField)
      expect(prediction.fields['supplier_name'].value).to be_nil

      expect(prediction.fields['supplier_payment_details']).to be_an_instance_of(UniversalListField)
      expect(prediction.fields['supplier_payment_details'].values[0].iban).to eq('FR7640254025476501124705368')

      expect(prediction.fields['taxes']).to be_an_instance_of(UniversalListField)
      expect(prediction.fields['taxes'].values[0].polygon).to be_an_instance_of(PositionField)
      expect(prediction.fields['taxes'].values[0].polygon.value.map do |point|
               [point.x, point.y]
             end).to eq([[0.292, 0.749], [0.543, 0.749], [0.543, 0.763], [0.292, 0.763]])
      expect(prediction.fields['taxes'].values[0].rate).to eq('20.0')
      expect(prediction.fields['taxes'].values[0].value).to eq('97.98')

      expect(prediction.fields['total_amount']).to be_an_instance_of(StringField)
      expect(prediction.fields['total_amount'].value).to eq('587.95')

      expect(prediction.fields['total_net']).to be_an_instance_of(StringField)
      expect(prediction.fields['total_net'].value).to eq('489.97')

      expect(invoice_v4_page0_doc.to_s.strip).to eq(invoice_v4_page0_doc_string.strip)
    end
  end
end
