# frozen_string_literal: true

require 'json'

require_relative 'endpoint'
require_relative 'documents'
require_relative 'response'

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

    def build_result(response)
      document = @doc_class.new(response['document']['inference']['prediction'], nil)
      pages = []
      response['document']['inference']['pages'].each do |page|
        pages.push(@doc_class.new(page['prediction'], page['id']))
      end
      DocumentResponse.new(response, @document_type, document, pages)
    end

    def predict(input_doc, include_words)
      check_api_keys
      response = predict_request(input_doc, include_words)
      build_result(response)
    end

    private

    def check_api_keys
      @endpoints.each do |endpoint|
        if endpoint.api_key.nil? || endpoint.api_key.empty?
          raise "Missing API key for '#{@document_type}', " \
                "check your Client Configuration.\n"
        end
      end
    end
  end

  class InvoiceConfig < DocumentConfig
    def initialize(api_key)
      endpoints = [InvoiceEndpoint.new(api_key)]
      super(
        Invoice,
        'invoice',
        'invoice',
        'invoices',
        endpoints
      )
    end
  end

  class ReceiptConfig < DocumentConfig
    def initialize(api_key)
      endpoints = [ReceiptEndpoint.new(api_key)]
      super(
        Receipt,
        'receipt',
        'receipt',
        'receipts',
        endpoints
      )
    end
  end

  class PassportConfig < DocumentConfig
    def initialize(api_key)
      endpoints = [PassportEndpoint.new(api_key)]
      super(
        Passport,
        'passport',
        'passport',
        'passports',
        endpoints
      )
    end
  end

  class FinancialDocConfig < DocumentConfig
    def initialize(invoice_api_key, receipt_api_key)
      endpoints = [
        InvoiceEndpoint.new(invoice_api_key),
        ReceiptEndpoint.new(receipt_api_key),
      ]
      super(
        FinancialDocument,
        'financial_doc',
        'financial_doc',
        'financial_doc',
        endpoints,
      )
    end

    def predict_request(input_doc, include_words)
      endpoint = input_doc.pdf? ? @endpoints[0] : @endpoints[1]
      response = endpoint.predict_request(input_doc, include_words: include_words)
      JSON.parse(response.body, object_class: Hash)
    end
  end

  class CustomDocConfig < DocumentConfig
    def initialize(document_type, account_name, singular_name, plural_name, version, api_key)
      endpoints = [CustomEndpoint.new(document_type, account_name, version, api_key)]
      super(
        CustomDocument,
        document_type,
        singular_name,
        plural_name,
        endpoints
      )
    end

    def build_result(response)
      document = CustomDocument.new(
        @document_type,
        response['document']['inference']['prediction'],
        nil
      )
      pages = []
      response['document']['inference']['pages'].each do |page|
        pages.push(CustomDocument.new(@document_type, page['prediction'], page['id']))
      end
      DocumentResponse.new(response, @document_type, document, pages)
    end
  end
end
