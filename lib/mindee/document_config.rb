# frozen_string_literal: true

require 'json'

require_relative 'endpoint'
require_relative 'documents'
require_relative 'response'

module Mindee
  # Specific client for sending a document to the API.
  class DocumentConfig
    # Array of possible Mindee::Endpoint to be used.
    # @return [Array<Mindee::Endpoint>]
    attr_reader :endpoints

    # @param doc_class [Class<Mindee::Document>]
    # @param document_type [String]
    # @param endpoints [Array<Mindee::Endpoint>]
    def initialize(doc_class, document_type, singular_name, plural_name, endpoints)
      @doc_class = doc_class
      @document_type = document_type
      @singular_name = singular_name
      @plural_name = plural_name
      @endpoints = endpoints
    end

    # Parse a prediction API result.
    # @param response [Hash]
    # @return [Mindee::DocumentResponse]
    def build_predict_result(response)
      document = @doc_class.new(response['document']['inference']['prediction'], nil)
      pages = []
      response['document']['inference']['pages'].each do |page|
        pages.push(@doc_class.new(page['prediction'], page['id']))
      end
      DocumentResponse.new(response, @document_type, document, pages)
    end

    # Call the prediction API.
    # @param input_doc [Mindee::InputDocument]
    # @param include_words [Boolean]
    # @return [Mindee::DocumentResponse]
    def predict(input_doc, include_words)
      check_api_keys
      response = predict_request(input_doc, include_words)
      build_predict_result(response)
    end

    private

    # @param input_doc [Mindee::InputDocument]
    # @param include_words [Boolean]
    # @return [Hash]
    def predict_request(input_doc, include_words)
      response = @endpoints[0].predict_request(input_doc, include_words: include_words)
      JSON.parse(response.body, object_class: Hash)
    end

    def check_api_keys
      @endpoints.each do |endpoint|
        next unless endpoint.api_key.nil? || endpoint.api_key.empty?

        raise "Missing API key for '#{@document_type}', " \
              "check your Client Configuration.\n" \
              'You can set this using the ' \
              "'#{endpoint.envvar_key_name}' environment variable."
      end
    end
  end

  # Client for Invoice documents
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

  # Client for Receipt documents
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

  # Client for Passport documents
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

  # Client for Financial documents
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

    private

    def predict_request(input_doc, include_words)
      endpoint = input_doc.pdf? ? @endpoints[0] : @endpoints[1]
      response = endpoint.predict_request(input_doc, include_words: include_words)
      JSON.parse(response.body, object_class: Hash)
    end
  end

  # Client for Custom (constructed) documents
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

    def build_predict_result(response)
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
