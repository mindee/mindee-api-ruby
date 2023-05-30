# frozen_string_literal: true

require_relative 'input'
require_relative 'document_config'
require_relative 'http/endpoint'
require_relative 'parsing/prediction'
require_relative 'parsing/api_response'


module Mindee
  # Mindee API Client.
  # See: https://developers.mindee.com/docs/
  class Client
    # @param api_key [String]
    def initialize(api_key: '')
      @doc_configs = {}
      @api_key = api_key
      init_default_endpoints
    end

    # Call prediction API on a document and parse the results.
    #
    # @param input_doc [Mindee::DocumentClient]
    #
    # @param prediction_class [Mindee::Prediction::Prediction]
    #
    # @param endpoint_name [String] For custom endpoints, the "API name" field in the "Settings" page of the
    #  API Builder. Do not set for standard (off the shelf) endpoints.
    #
    # @param account_name [String] For custom endpoints, your account or organization username on the API Builder.
    #  This is normally not required unless you have a custom endpoint which has the same name as a
    #  standard (off the shelf) endpoint.
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
    # @return [Mindee::ApiResponse]
    def parse(
      input_doc,
      prediction_class,
      endpoint_name: '',
      account_name: '',
      include_words: false,
      close_file: true,
      page_options: nil,
      cropper: false
    )
      @doc_config = find_doc_config(prediction_class, endpoint_name, account_name)
      input_doc.process_pdf(page_options) if !page_options.nil? && input_doc.pdf?
      Mindee::ApiResponse.new(prediction_class, @doc_config.predict(input_doc, include_words, close_file, cropper))
    end

    # @return [Mindee::ApiResponse]
    def enqueue(
      input_doc,
      prediction_class,
      endpoint_name: '',
      account_name: '',
      include_words: false,
      page_options: nil,
      cropper: false
    )
      @doc_config = find_doc_config(prediction_class, endpoint_name, account_name)
      input_doc.process_pdf(page_options) if !page_options.nil? && input_doc.pdf?
      Mindee::ApiResponse.new(prediction_class, @doc_config.predict_async(input_doc, include_words, cropper))
    end

    # @return [Mindee::ApiResponse]
    def parse_queued(
      prediction_class,
      job_id,
      endpoint_name: '',
      account_name: '',
      include_words: false,
      page_options: nil,
      cropper: false
    )
      @doc_config = find_doc_config(prediction_class, endpoint_name, account_name)
      Mindee::ApiResponse.new(prediction_class, @doc_config.parse_async(job_id))
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
        HTTP::CustomEndpoint.new(account_name, endpoint_name, version, @api_key)
      )
      self
    end


    # @param document_class [Mindee::Prediction::Prediction]
    # @param endpoint_name [String]
    # @return [String]
    def determine_endpoint_name(document_class, endpoint_name)
      return document_class.name if document_class.name != Prediction::CustomV1.name

      raise "endpoint_name is required when using #{document_class.name} class" if endpoint_name.empty?

      endpoint_name
    end


    # @param document_class [Mindee::Prediction::Prediction]
    # @param endpoint_name [String]
    # @param account_name [String]
    # @return [Mindee::PathInputSource]
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

    # Load a document from an absolute path, as a string.
    # @param input_path [String] Path of file to open
    # @return [Mindee::PathInputSource]
    def doc_from_path(input_path)
      Input::PathInputSource.new(input_path)
    end

    # Load a document from raw bytes.
    # @param input_bytes [String] Encoding::BINARY byte input
    # @param filename [String] The name of the file (without the path)
    # @return [Mindee::DocumentClient]
    def doc_from_bytes(input_bytes, filename)
      doc = Input::BytesInputSource.new(input_bytes, filename)
      DocumentClient.new(doc, @doc_configs)
    end

    # Load a document from a base64 encoded string.
    # @param base64_string [String] Input to parse as base64 string
    # @param filename [String] The name of the file (without the path)
    # @return [Mindee::DocumentClient]
    def doc_from_b64string(base64_string, filename)
      doc = Input::Base64InputSource.new(base64_string, filename)
      DocumentClient.new(doc, @doc_configs)
    end

    # Load a document from a normal Ruby `File`.
    # @param input_file [File] Input file handle
    # @param filename [String] The name of the file (without the path)
    # @return [Mindee::DocumentClient]
    def doc_from_file(input_file, filename)
      doc = Input::FileInputSource.new(input_file, filename)
      DocumentClient.new(doc, @doc_configs)
    end

    private

    def standard_document_config(prediction_class, endpoint_name, version)
      DocumentConfig.new(
        prediction_class,
        HTTP::StandardEndpoint.new(endpoint_name, version, @api_key)
      )
    end

    def init_default_endpoints
      @doc_configs[['mindee', Prediction::ProofOfAddressV1.name]] = standard_document_config(
        Prediction::ProofOfAddressV1, 'proof_of_address', '1'
      )
      @doc_configs[['mindee', Prediction::FinancialDocumentV1.name]] = standard_document_config(
        Prediction::FinancialDocumentV1, 'financial_document', '1'
      )
      @doc_configs[['mindee', Prediction::InvoiceV4.name]] = standard_document_config(
        Prediction::InvoiceV4, 'invoices', '4'
      )
      @doc_configs[['mindee', Prediction::ReceiptV4.name]] = standard_document_config(
        Prediction::ReceiptV4, 'expense_receipts', '4'
      )
      @doc_configs[['mindee', Prediction::ReceiptV5.name]] = standard_document_config(
        Prediction::ReceiptV5, 'expense_receipts', '5'
      )
      @doc_configs[['mindee', Prediction::PassportV1.name]] = standard_document_config(
        Prediction::PassportV1, 'passport', '1'
      )
      @doc_configs[['mindee', Prediction::EU::LicensePlateV1.name]] = standard_document_config(
        Prediction::EU::LicensePlateV1, 'license_plates', '1'
      )
      @doc_configs[['mindee', Prediction::ShippingContainerV1.name]] = standard_document_config(
        Prediction::ShippingContainerV1, 'shipping_containers', '1'
      )
      @doc_configs[['mindee', Prediction::US::BankCheckV1.name]] = standard_document_config(
        Prediction::US::BankCheckV1, 'bank_check', '1'
      )
      @doc_configs[['mindee', Prediction::FR::BankAccountDetailsV1.name]] = standard_document_config(
        Prediction::FR::BankAccountDetailsV1, 'bank_account_details', '1'
      )
      @doc_configs[['mindee', Prediction::FR::CarteVitaleV1.name]] = standard_document_config(
        Prediction::FR::CarteVitaleV1, 'carte_vitale', '1'
      )
      @doc_configs[['mindee', Prediction::FR::IdCardV1.name]] = standard_document_config(
        Prediction::FR::IdCardV1, 'idcard_fr', '1'
      )
      @doc_configs[['mindee', Prediction::InvoiceSplitterV1.name]] = standard_document_config(
        Prediction::InvoiceSplitterV1, 'invoice_splitter', '1'
      )
      self
    end
  end
end
