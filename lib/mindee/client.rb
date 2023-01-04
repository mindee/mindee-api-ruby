# frozen_string_literal: true

require_relative 'input'
require_relative 'document_config'
require_relative 'http/endpoint'
require_relative 'parsing/prediction'

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
    #
    # @param document_class [Mindee::Prediction::Prediction]
    #
    # @param endpoint_name [String] For custom endpoints, the "API name" field in the "Settings" page of the
    #  API Builder. Do not set for standard (off the shelf) endpoints.
    #
    # @param account_name [String] For custom endpoints, your account or organization username on the API Builder.
    #  This is normally not required unless you have a custom endpoint which has the
    #  same name as standard (off the shelf) endpoint.
    #  Do not set for standard (off the shelf) endpoints.
    #
    # @param include_words [Boolean] Whether to include the full text for each page.
    #  This performs a full OCR operation on the server and will increase response time.
    #
    # @param close_file [Boolean] Whether to `close()` the file after parsing it.
    #  Set to false if you need to access the file after this operation.
    #
    # @param page_options [Hash, nil] Page cutting/merge options:
    #
    #  * `:page_indexes` Zero-based list of page indexes.
    #  * `:operation` Operation to apply on the document, given the `page_indexes specified:
    #      * `:KEEP_ONLY` - keep only the specified pages, and remove all others.
    #      * `:REMOVE` - remove the specified pages, and keep all others.
    #  * `:on_min_pages` Apply the operation only if document has at least this many pages.
    #
    # @param cropper [Boolean] Whether to include cropper results for each page.
    #  This performs a cropping operation on the server and will increase response time.
    #
    # @return [Mindee::DocumentResponse]
    def parse(
      document_class,
      endpoint_name: '',
      account_name: '',
      include_words: false,
      close_file: true,
      page_options: nil,
      cropper: false
    )
      doc_config = find_doc_config(document_class, endpoint_name, account_name)
      @input_doc.process_pdf(page_options) if !page_options.nil? && @input_doc.pdf?
      doc_config.predict(@input_doc, include_words, close_file, cropper)
    end

    private

    # @param document_class [Mindee::Prediction::Prediction]
    # @param endpoint_name [String]
    def determine_endpoint_name(document_class, endpoint_name)
      return document_class.name if document_class.name != Prediction::CustomV1.name

      raise "endpoint_name is required when using #{document_class.name} class" if endpoint_name.empty?

      endpoint_name
    end

    # @param document_class [Mindee::Prediction::Prediction]
    # @param endpoint_name [String]
    # @param account_name [String]
    def find_doc_config(document_class, endpoint_name, account_name)
      endpoint_name = determine_endpoint_name(document_class, endpoint_name)

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

      @doc_configs[config_key]
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
      @doc_configs[[account_name, endpoint_name]] = DocumentConfig.new(
        Prediction::CustomV1,
        endpoint_name,
        [HTTP::CustomEndpoint.new(account_name, endpoint_name, version, @api_key)]
      )
      self
    end

    # Load a document from an absolute path, as a string.
    # @param input_path [String] Path of file to open
    # @return [Mindee::DocumentClient]
    def doc_from_path(input_path)
      doc = Input::PathDocument.new(input_path)
      DocumentClient.new(doc, @doc_configs)
    end

    # Load a document from raw bytes.
    # @param input_bytes [String] Encoding::BINARY byte input
    # @param filename [String] The name of the file (without the path)
    # @return [Mindee::DocumentClient]
    def doc_from_bytes(input_bytes, filename)
      doc = Input::BytesDocument.new(input_bytes, filename)
      DocumentClient.new(doc, @doc_configs)
    end

    # Load a document from a base64 encoded string.
    # @param base64_string [String] Input to parse as base64 string
    # @param filename [String] The name of the file (without the path)
    # @return [Mindee::DocumentClient]
    def doc_from_b64string(base64_string, filename)
      doc = Input::Base64Document.new(base64_string, filename)
      DocumentClient.new(doc, @doc_configs)
    end

    # Load a document from a normal Ruby `File`.
    # @param input_file [File] Input file handle
    # @param filename [String] The name of the file (without the path)
    # @return [Mindee::DocumentClient]
    def doc_from_file(input_file, filename)
      doc = Input::FileDocument.new(input_file, filename)
      DocumentClient.new(doc, @doc_configs)
    end

    private

    def init_default_endpoints
      @doc_configs[['mindee', Prediction::InvoiceV4.name]] = DocumentConfig.new(
        Prediction::InvoiceV4,
        'invoice',
        [HTTP::StandardEndpoint.new('invoices', '4', api_key: @api_key)]
      )
      @doc_configs[['mindee', Prediction::ReceiptV4.name]] = DocumentConfig.new(
        Prediction::ReceiptV4,
        'receipt',
        [HTTP::StandardEndpoint.new('expense_receipts', '4', api_key: @api_key)]
      )
      @doc_configs[['mindee', Prediction::PassportV1.name]] = DocumentConfig.new(
        Prediction::PassportV1,
        'passport',
        [HTTP::StandardEndpoint.new('passport', '1', api_key: @api_key)]
      )
      @doc_configs[['mindee', Prediction::EU::LicensePlateV1.name]] = DocumentConfig.new(
        Prediction::EU::LicensePlateV1,
        'license_plate',
        [HTTP::StandardEndpoint.new('license_plates', '1', api_key: @api_key)]
      )
      self
    end
  end
end
