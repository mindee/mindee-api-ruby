# frozen_string_literal: true

require_relative 'input'
require_relative 'http'
require_relative 'product'
require_relative 'parsing/common/api_response'

module Mindee
  # Mindee API Client.
  # See: https://developers.mindee.com/docs/
  class Client
    # @param api_key [String]
    def initialize(api_key: '')
      @api_key = api_key
    end

    # Call prediction API on a document and parse the results.
    #
    # @param input_source [Mindee::Input::LocalInputSource, Mindee::Input::UrlInputSource]
    #
    # @param endpoint [HTTP::Endpoint] Endpoint of the API
    #
    # @param all_words [Boolean] Whether to include the full text for each page.
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
    # @return [Mindee::Parsing::Common::ApiResponse]
    def parse(
      input_source,
      endpoint,
      all_words: false,
      close_file: true,
      page_options: nil,
      cropper: false
    )
      if input_source.is_a?(Mindee::Input::LocalInputSource) && !page_options.nil? && input_source.pdf?
        input_source.process_pdf(page_options)
      end
      prediction = endpoint.predict(input_source, all_words, close_file, cropper)
      Mindee::Parsing::Common::ApiResponse.new(endpoint.product_class, prediction)
    end

    # Enqueue a document for async parsing
    #
    # @param input_source [Mindee::Input::LocalInputSource, Mindee::Input::UrlInputSource]
    #
    # @param endpoint [HTTP::Endpoint] Endpoint of the API
    #
    # @param all_words [Boolean] Whether to extract all the words on each page.
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
    # @return [Mindee::Parsing::Common::ApiResponse]
    def enqueue(
      input_source,
      endpoint,
      all_words: false,
      close_file: true,
      page_options: nil,
      cropper: false
    )
      if input_source.is_a?(Mindee::Input::LocalInputSource) && !page_options.nil? && input_source.pdf?
        input_source.process_pdf(page_options)
      end
      Mindee::Parsing::Common::ApiResponse.new(endpoint.product_class,
                                               endpoint.predict_async(input_source, all_words, close_file, cropper))
    end

    # Parses a queued document
    #
    # @param endpoint [HTTP::Endpoint] Endpoint of the API
    #
    # @param job_id [String] Id of the job (queue) to poll from
    #
    # @return [Mindee::Parsing::Common::ApiResponse]
    def parse_queued(
      job_id,
      endpoint
    )
      Mindee::Parsing::Common::ApiResponse.new(endpoint.product_class, endpoint.parse_async(job_id))
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
    # @return [Mindee::BytesInputSource]
    def doc_from_bytes(input_bytes, filename)
      Input::BytesInputSource.new(input_bytes, filename)
    end

    # Load a document from a base64 encoded string.
    # @param base64_string [String] Input to parse as base64 string
    # @param filename [String] The name of the file (without the path)
    # @return [Mindee::Base64InputSource]
    def doc_from_b64string(base64_string, filename)
      Input::Base64InputSource.new(base64_string, filename)
    end

    # Load a document from a normal Ruby `File`.
    # @param input_file [File] Input file handle
    # @param filename [String] The name of the file (without the path)
    # @return [Mindee::FileInputSource]
    def doc_from_file(input_file, filename)
      Input::FileInputSource.new(input_file, filename)
    end

    # Load a document from a secure remote source (HTTPS).
    # @param url [String] Url of the file
    # @return [Mindee::UrlInputSource]
    def doc_from_url(url)
      Input::UrlInputSource.new(url)
    end

    # Creates an endpoint with the given values. Raises an error if the endpoint is invalid.
    # @param product_class [Mindee::Product] class of the product
    #
    # @param endpoint_name [String] For custom endpoints, the "API name" field in the "Settings" page of the
    #  API Builder. Do not set for standard (off the shelf) endpoints.
    #
    # @param account_name [String] For custom endpoints, your account or organization username on the API Builder.
    #  This is normally not required unless you have a custom endpoint which has the same name as a
    #  standard (off the shelf) endpoint.
    #  Do not set for standard (off the shelf) endpoints.
    # @return [Mindee::HTTP::Endpoint]
    def create_endpoint(product_class, endpoint_name: '', account_name: '', version: '')
      if (endpoint_name.nil? || endpoint_name.empty?) && product_class == Mindee::Product::Custom::CustomV1
        raise 'Missing argument endpoint_name when using custom class'
      end

      endpoint_name = fix_endpoint_name(product_class, endpoint_name)
      account_name = fix_account_name(account_name)
      version = fix_version(product_class, version)
      HTTP::Endpoint.new(product_class, account_name, endpoint_name, version, api_key: @api_key)
    end

    private

    def fix_endpoint_name(product_class, endpoint_name)
      return product_class.endpoint_name if endpoint_name.nil? || endpoint_name.empty?

      endpoint_name
    end

    def fix_account_name(account_name)
      return 'mindee' if account_name.nil? || account_name.empty?

      account_name
    end

    def fix_version(product_class, version)
      return version unless version.nil? || version.empty?
      return '1' if product_class.endpoint_version.nil? || product_class.endpoint_version.empty?

      product_class.endpoint_version
    end
  end
end
