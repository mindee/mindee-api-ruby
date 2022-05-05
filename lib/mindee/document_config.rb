# frozen_string_literal: true

require 'json'

require_relative 'endpoint'
require_relative 'documents'

module Mindee
  class DocumentConfig
    attr_reader :endpoints

    def initialize(doc_class, document_type, singular_name, plural_name, endpoints)
      @doc_class = doc_class
      @document_type = document_type
      @singular_name = singular_name
      @plural_name = plural_name
      @endpoints = endpoints
    end

    def predict_request(input_doc, include_words)
      response = @endpoints[0].predict_request(input_doc, include_words: include_words)
      JSON.parse(response.body, object_class: Hash)
    end

    def predict(input_doc, include_words)
      response = predict_request(input_doc, include_words)
      @doc_class.new(response)
    end
  end

  class InvoiceConfig < DocumentConfig
    def initialize(api_key)
      endpoints = [InvoiceEndpoint.new(api_key)]
      super(Invoice, 'invoice', 'invoice', 'invoices', endpoints)
    end
  end

  class ReceiptConfig < DocumentConfig
    def initialize(api_key)
      endpoints = [InvoiceEndpoint.new(api_key)]
      super(Receipt, 'receipt', 'receipt', 'receipts', endpoints)
    end
  end

  class PassportConfig < DocumentConfig
    def initialize(api_key)
      endpoints = [InvoiceEndpoint.new(api_key)]
      super(Passport, 'passport', 'passport', 'passports', endpoints)
    end
  end

  class FinancialDocConfig < DocumentConfig
    def initialize(invoice_api_key, receipt_api_key)
      endpoints = [
        InvoiceEndpoint.new(invoice_api_key),
        InvoiceEndpoint.new(receipt_api_key),
      ]
      super(FinancialDocument, 'financial_doc', 'financial_doc', 'financial_doc', endpoints)
    end
  end
end
