# frozen_string_literal: true

require_relative 'inputs'
require_relative 'document_config'
require_relative 'endpoint'

module Mindee
  # General client for sending a document to the API.
  class DocumentClient
    # @param input_doc [Mindee::InputDocument]
    # @param doc_configs [Hash]
    # @param raise_on_error [Boolean]
    def initialize(input_doc, doc_configs, raise_on_error)
      @input_doc = input_doc
      @doc_configs = doc_configs
      @raise_on_error = raise_on_error
    end

    # Call prediction API on the document and parse the results.
    # @param document_type [String] Document type to parse
    # @param username [String] API username, the endpoint owner
    # @param include_words [Boolean] Include all the words of the document in the response
    # @return [Mindee::DocumentResponse]
    def parse(document_type, username: '', include_words: false)
      found = []
      @doc_configs.each_key do |conf|
        found.push(conf) if conf[1] == document_type
      end
      raise "Document type not configured: #{document_type}" if found.empty?

      if !username.empty?
        config_key = [username, document_type]
      elsif found.length == 1
        config_key = found[0]
      else
        usernames = found.map { |conf| conf[0] }
        raise "Duplicate configuration detected.\n" \
              "You specified a document_type '#{document_type}' in your custom config.\n" \
              "To avoid confusion, please add the 'account_name' attribute to " \
              "the parse method, one of #{usernames}."
      end

      doc_config = @doc_configs[config_key]
      doc_config.predict(@input_doc, include_words)
    end
  end

  # Mindee API Client.
  # See: https://developers.mindee.com/docs/
  class Client
    def initialize(raise_on_error: true)
      @raise_on_error = raise_on_error
      @doc_configs = {}
    end

    # Configure a 'Mindee Invoice' document.
    # @param api_key [String] Invoice API key
    # @return [Mindee::Client]
    def config_invoice(api_key: '')
      @doc_configs[['mindee', 'invoice']] = InvoiceConfig.new(api_key)
      self
    end

    # Configure a 'Mindee Expense Receipts' document.
    # @param api_key [String] Passport API key
    # @return [Mindee::Client]
    def config_receipt(api_key: '')
      @doc_configs[['mindee', 'receipt']] = ReceiptConfig.new(api_key)
      self
    end

    # Configure a 'Mindee Passport' document.
    # @param api_key [String] Your API key for the endpoint
    # @return [Mindee::Client]
    def config_passport(api_key: '')
      @doc_configs[['mindee', 'passport']] = PassportConfig.new(api_key)
      self
    end

    # Configure a 'Mindee Financial document'. Uses 'Invoice' and 'Expense Receipt' internally.
    # @param receipt_api_key [String] Expense Receipt API key
    # @param invoice_api_key [String] Invoice API key
    # @return [Mindee::Client]
    def config_financial_doc(invoice_api_key: '', receipt_api_key: '')
      @doc_configs[['mindee', 'financial_doc']] = FinancialDocConfig.new(
        invoice_api_key, receipt_api_key
      )
      self
    end

    # Configure a custom document using the 'Mindee API Builder'.
    # @param account_name [String] Your organization's username on the API Builder
    # @param document_type [String] The "document type" field in the "Settings" page of the API Builder
    # @param api_key [String] Your API key for the endpoint
    # @param version [String] Specify the version of the model to use. If not set, use the latest version of the model.
    # @return [Mindee::Client]
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

    # Load a document from an absolute path, as a string.
    # @param input_path [String] Path of file to open
    # @param cut_pdf [Boolean] Automatically reconstruct a PDF with more than 4 pages
    # @param n_pdf_pages [Integer] Number (between 1 and 3 incl.) of pages to reconstruct a PDF with.
    # @return [Mindee::DocumentClient]
    def doc_from_path(input_path, cut_pdf: true, n_pdf_pages: 3)
      doc = PathDocument.new(input_path, cut_pdf, n_pdf_pages: n_pdf_pages)
      DocumentClient.new(doc, @doc_configs, @raise_on_error)
    end

    # Load a document from raw bytes.
    # @param input_bytes [String] Encoding::BINARY byte input
    # @param filename [String] The name of the file (without the path)
    # @param cut_pdf [Boolean] Automatically reconstruct a PDF with more than 4 pages
    # @param n_pdf_pages [Integer] Number (between 1 and 3 incl.) of pages to reconstruct a PDF with.
    # @return [Mindee::DocumentClient]
    def doc_from_bytes(input_bytes, filename, cut_pdf: true, n_pdf_pages: 3)
      doc = BytesDocument.new(input_bytes, filename, cut_pdf, n_pdf_pages: n_pdf_pages)
      DocumentClient.new(doc, @doc_configs, @raise_on_error)
    end

    # Load a document from a base64 encoded string.
    # @param base64_string [String] Input to parse as base64 string
    # @param filename [String] The name of the file (without the path)
    # @param cut_pdf [Boolean] Automatically reconstruct a PDF with more than 4 pages
    # @param n_pdf_pages [Integer] Number (between 1 and 3 incl.) of pages to reconstruct a PDF with.
    # @return [Mindee::DocumentClient]
    def doc_from_b64string(base64_string, filename, cut_pdf: true, n_pdf_pages: 3)
      doc = Base64Document.new(base64_string, filename, cut_pdf, n_pdf_pages: n_pdf_pages)
      DocumentClient.new(doc, @doc_configs, @raise_on_error)
    end

    # Load a document from a normal Ruby `File`.
    # @param input_file [File] Input file handle
    # @param filename [String] The name of the file (without the path)
    # @param cut_pdf [Boolean] Automatically reconstruct a PDF with more than 4 pages
    # @param n_pdf_pages [Integer] Number (between 1 and 3 incl.) of pages to reconstruct a PDF with.
    # @return [Mindee::DocumentClient]
    def doc_from_file(input_file, filename, cut_pdf: true, n_pdf_pages: 3)
      doc = FileDocument.new(input_file, filename, cut_pdf, n_pdf_pages: n_pdf_pages)
      DocumentClient.new(doc, @doc_configs, @raise_on_error)
    end
  end
end
