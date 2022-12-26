# frozen_string_literal: true

require_relative 'input'
require_relative 'document_config'
require_relative 'api/endpoint'

module Mindee
  # General client for sending a document to the API.
  class DocumentClient
    # @param input_doc [Mindee::InputDocument]
    # @param doc_configs [Hash]
    def initialize(input_doc, doc_configs)
      @input_doc = input_doc
      @doc_configs = doc_configs
    end

    # Call prediction API on the document and parse the results.
    # @param document_class [Class]
    # @param endpoint_name [String] For custom endpoints, the "API name" field in the "Settings" page of the
    #  API Builder. Do not set for standard (off the shelf) endpoints.
    # @param account_name [String] For custom endpoints, your account or organization username on the API Builder.
    #  This is normally not required unless you have a custom endpoint which has the
    #  same name as standard (off the shelf) endpoint.
    #  Do not set for standard (off the shelf) endpoints.
    # @param include_words [Boolean] Whether to include the full text for each page.
    #  This performs a full OCR operation on the server and will increase response time.
    # @param close_file [Boolean] Whether to ``close()`` the file after parsing it.
    #  Set to ``false`` if you need to access the file after this operation.
    # @param page_options [PageOptions]
    # @param cropper [Boolean] Whether to include cropper results for each page.
    #  This performs a cropping operation on the server and will increase response time.
    # @return [Mindee::DocumentResponse]
    def parse(
      document_class,
      endpoint_name: '',
      account_name: '',
      include_words: false,
      close_file: true,
      page_options: {},
      cropper: false
    )
      if document_class.name != CustomV1.name
        endpoint_name = document_class.name
      elsif endpoint_name.empty?
        raise "endpoint_name is required when using #{document_class.name} class"
      end

      found = []
      @doc_configs.each_key do |conf|
        found.push(conf) if conf[1] == endpoint_name
      end
      raise "Endpoint not configured: #{endpoint_name}" if found.empty?

      if !account_name.empty?
        config_key = [account_name, endpoint_name]
      elsif found.length == 1
        config_key = found[0]
      else
        usernames = found.map { |conf| conf[0] }
        raise "Duplicate configuration detected.\n" \
              "You specified the document '#{endpoint_name}' in your custom config.\n" \
              "To avoid confusion, please add the 'account_name' attribute to " \
              "the parse method, one of #{usernames}."
      end

      doc_config = @doc_configs[config_key]
      doc_config.predict(@input_doc, include_words, close_file, cropper)
    end
  end

  # Mindee API Client.
  # See: https://developers.mindee.com/docs/
  class Client
    # @param raise_on_error [Boolean]
    def initialize(api_key: nil, raise_on_error: true)
      @raise_on_error = raise_on_error
      @doc_configs = {}
      @api_key = api_key
      init_default_endpoints
    end

    # Configure a custom document using the 'Mindee API Builder'.
    # @param account_name [String] Your organization's username on the API Builder
    # @param endpoint_name [String] The "API name" field in the "Settings" page of the API Builder
    # @param version [String] Specify the version of the model to use. If not set, use the latest version of the model.
    # @return [Mindee::Client]
    def add_endpoint(
      account_name,
      endpoint_name,
      version: '1'
    )
      @doc_configs[[account_name, endpoint_name]] = CustomDocConfig.new(
        account_name,
        endpoint_name,
        version,
        @api_key,
        @raise_on_error
      )
      self
    end

    # Load a document from an absolute path, as a string.
    # @param input_path [String] Path of file to open
    # @param cut_pages [Boolean] Automatically reconstruct a multi-page document.
    # @param max_pages [Integer] Number (between 1 and 3 incl.) of pages to reconstruct a document.
    # @return [Mindee::DocumentClient]
    def doc_from_path(input_path, cut_pages: true, max_pages: MAX_DOC_PAGES)
      doc = PathDocument.new(input_path, cut_pages, max_pages: max_pages)
      DocumentClient.new(doc, @doc_configs)
    end

    # Load a document from raw bytes.
    # @param input_bytes [String] Encoding::BINARY byte input
    # @param filename [String] The name of the file (without the path)
    # @param cut_pages [Boolean] Automatically reconstruct a multi-page document.
    # @param max_pages [Integer] Number (between 1 and 3 incl.) of pages to reconstruct a document.
    # @return [Mindee::DocumentClient]
    def doc_from_bytes(input_bytes, filename, cut_pages: true, max_pages: MAX_DOC_PAGES)
      doc = BytesDocument.new(input_bytes, filename, cut_pages, max_pages: max_pages)
      DocumentClient.new(doc, @doc_configs)
    end

    # Load a document from a base64 encoded string.
    # @param base64_string [String] Input to parse as base64 string
    # @param filename [String] The name of the file (without the path)
    # @param cut_pages [Boolean] Automatically reconstruct a multi-page document.
    # @param max_pages [Integer] Number (between 1 and 3 incl.) of pages to reconstruct a document.
    # @return [Mindee::DocumentClient]
    def doc_from_b64string(base64_string, filename, cut_pages: true, max_pages: MAX_DOC_PAGES)
      doc = Base64Document.new(base64_string, filename, cut_pages, max_pages: max_pages)
      DocumentClient.new(doc, @doc_configs)
    end

    # Load a document from a normal Ruby `File`.
    # @param input_file [File] Input file handle
    # @param filename [String] The name of the file (without the path)
    # @param cut_pages [Boolean] Automatically reconstruct a multi-page document.
    # @param max_pages [Integer] Number (between 1 and 3 incl.) of pages to reconstruct a document.
    # @return [Mindee::DocumentClient]
    def doc_from_file(input_file, filename, cut_pages: true, max_pages: MAX_DOC_PAGES)
      doc = FileDocument.new(input_file, filename, cut_pages, max_pages: max_pages)
      DocumentClient.new(doc, @doc_configs)
    end

    private

    def init_default_endpoints
      @doc_configs[['mindee', InvoiceV3.name]] = DocumentConfig.new(
        InvoiceV3,
        'invoice',
        [InvoiceEndpoint.new(@api_key)],
        @raise_on_error
      )
      @doc_configs[['mindee', ReceiptV3.name]] = DocumentConfig.new(
        ReceiptV3,
        'receipt',
        [ReceiptEndpoint.new(@api_key)],
        @raise_on_error
      )
      @doc_configs[['mindee', PassportV1.name]] = DocumentConfig.new(
        PassportV1,
        'passport',
        [PassportEndpoint.new(@api_key)],
        @raise_on_error
      )
      @doc_configs[['mindee', FinancialDocument.name]] = FinancialDocConfig.new(
        @api_key,
        @raise_on_error
      )
      self
    end
  end
end
