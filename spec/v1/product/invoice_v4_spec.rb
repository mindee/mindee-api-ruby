# frozen_string_literal: true

require 'json'
require 'mindee/v1/product'
require 'mindee/v1/parsing'

require_relative '../../data'

DIR_INVOICE_V4 = File.join(V1_DATA_DIR, 'products', 'invoices', 'response_v4').freeze

describe Mindee::V1::Product::Invoice::InvoiceV4 do
  context 'A Invoice V4' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_INVOICE_V4, 'empty.json')
      inference = Mindee::V1::Parsing::Common::Document.new(
        Mindee::V1::Product::Invoice::InvoiceV4,
        response['document']
      ).inference
      expect(inference.product.type).to eq('standard')
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_INVOICE_V4, 'summary_full.rst')
      response = load_json(DIR_INVOICE_V4, 'complete.json')
      document = Mindee::V1::Parsing::Common::Document.new(
        Mindee::V1::Product::Invoice::InvoiceV4,
        response['document']
      )
      expect(document.to_s).to eq(to_string)
    end
  end
end
