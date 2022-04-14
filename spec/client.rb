# frozen_string_literal: true

require 'mindee/client'

DATA_DIR = File.join(__dir__, 'data').freeze

describe Mindee::Client do
  context 'With a valid client' do
    mindee_client = Mindee::Client.new

    it 'should be configurable' do
      mindee_client.config_invoice('invalid-api-key')
                   .config_receipt('invalid-api-key')
                   .config_passport('invalid-api-key')
    end

    it 'should open PDF files' do
      mindee_client.doc_from_path("#{DATA_DIR}/invoices/invoice.pdf")
      mindee_client.doc_from_path("#{DATA_DIR}/invoices/invoice_10p.pdf")
    end
  end
end
