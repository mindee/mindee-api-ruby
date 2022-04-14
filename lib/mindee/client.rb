# frozen_string_literal: true

require_relative 'inputs'
require_relative 'document_config'
require_relative 'endpoint'

module Mindee
  class DocumentClient
    def initialize(input_doc, doc_configs, raise_on_error)
      @input_doc = input_doc
      @doc_configs = doc_configs
      @raise_on_error = raise_on_error
    end

    def parse(document_type, include_words: false)
      doc_config = @doc_configs[['mindee', document_type]]
      puts doc_config.endpoints[0].predict_request(@input_doc, include_words: include_words)
    end
  end

  # Mindee API Client.
  class Client
    def initialize(raise_on_error: true)
      @raise_on_error = raise_on_error
      @doc_configs = {}
    end

    def config_invoice(api_key)
      endpoint = InvoiceEndpoint.new(api_key)
      @doc_configs[['mindee', 'invoice']] = DocumentConfig.new('invoice', 'invoice', 'invoices', [endpoint])
      self
    end

    def doc_from_path(input_path, cut_pdf: true, n_pdf_pages: 3)
      doc = Mindee::PathDocument.new(input_path, cut_pdf, n_pdf_pages: n_pdf_pages)
      DocumentClient.new(doc, @doc_configs, @raise_on_error)
    end
  end
end
