# frozen_string_literal: true

require_relative 'inputs'
require_relative 'document_config'
require_relative 'endpoint'

module Mindee
  # Handle sending a document to the API.
  class DocumentClient
    def initialize(input_doc, doc_configs, raise_on_error)
      @input_doc = input_doc
      @doc_configs = doc_configs
      @raise_on_error = raise_on_error
    end

    def parse(document_type, include_words: false)
      doc_config = @doc_configs[['mindee', document_type]]
      response = doc_config.predict(@input_doc, include_words)
      puts response
    end
  end

  # Mindee API Client.
  class Client
    def initialize(raise_on_error: true)
      @raise_on_error = raise_on_error
      @doc_configs = {}
    end

    def config_invoice(api_key)
      @doc_configs[['mindee', 'invoice']] = InvoiceConfig.new(api_key)
      self
    end

    def config_receipt(api_key)
      @doc_configs[['mindee', 'receipt']] = ReceiptConfig.new(api_key)
      self
    end

    def config_passport(api_key)
      @doc_configs[['mindee', 'passport']] = PassportConfig.new(api_key)
      self
    end

    def doc_from_path(input_path, cut_pdf: true, n_pdf_pages: 3)
      doc = PathDocument.new(input_path, cut_pdf, n_pdf_pages: n_pdf_pages)
      DocumentClient.new(doc, @doc_configs, @raise_on_error)
    end

    def doc_from_b64string(base64_string, filename, cut_pdf: true, n_pdf_pages: 3)
      doc = Base64Document.new(base64_string, filename, cut_pdf, n_pdf_pages: n_pdf_pages)
      DocumentClient.new(doc, @doc_configs, @raise_on_error)
    end
  end
end
