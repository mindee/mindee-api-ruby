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
      found = []
      @doc_configs.each_key do |conf|
        found.push(conf) if conf[1] == document_type
      end
      raise "Document type not configured: #{document_type}" if found.empty?

      config_key = found[0]
      doc_config = @doc_configs[config_key]
      doc_config.predict(@input_doc, include_words)
    end
  end

  # Mindee API Client.
  class Client
    def initialize(raise_on_error: true)
      @raise_on_error = raise_on_error
      @doc_configs = {}
    end

    def config_invoice(api_key: '')
      @doc_configs[['mindee', 'invoice']] = InvoiceConfig.new(api_key)
      self
    end

    def config_receipt(api_key: '')
      @doc_configs[['mindee', 'receipt']] = ReceiptConfig.new(api_key)
      self
    end

    def config_passport(api_key: '')
      @doc_configs[['mindee', 'passport']] = PassportConfig.new(api_key)
      self
    end

    def config_financial_doc(invoice_api_key: '', receipt_api_key: '')
      @doc_configs[['mindee', 'financial_doc']] = FinancialDocConfig.new(
        invoice_api_key, receipt_api_key
      )
      self
    end

    def config_custom_doc(
      account_name,
      document_type,
      singular_name,
      plural_name,
      api_key: '',
      version: '1'
    )
      @doc_configs[[account_name, document_type]] = CustomDocConfig.new(
        document_type,
        account_name,
        singular_name,
        plural_name,
        version,
        api_key
      )
      self
    end

    def doc_from_path(input_path, cut_pdf: true, n_pdf_pages: 3)
      doc = PathDocument.new(input_path, cut_pdf, n_pdf_pages: n_pdf_pages)
      DocumentClient.new(doc, @doc_configs, @raise_on_error)
    end

    def doc_from_bytes(input_bytes, filename, cut_pdf: true, n_pdf_pages: 3)
      doc = BytesDocument.new(input_bytes, filename, cut_pdf, n_pdf_pages: n_pdf_pages)
      DocumentClient.new(doc, @doc_configs, @raise_on_error)
    end

    def doc_from_b64string(base64_string, filename, cut_pdf: true, n_pdf_pages: 3)
      doc = Base64Document.new(base64_string, filename, cut_pdf, n_pdf_pages: n_pdf_pages)
      DocumentClient.new(doc, @doc_configs, @raise_on_error)
    end

    def doc_from_file(input_file, filename, cut_pdf: true, n_pdf_pages: 3)
      doc = FileDocument.new(input_file, filename, cut_pdf, n_pdf_pages: n_pdf_pages)
      DocumentClient.new(doc, @doc_configs, @raise_on_error)
    end
  end
end
