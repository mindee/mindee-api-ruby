# frozen_string_literal: true

require_relative 'input'
require_relative 'http'
require_relative 'product'
require_relative 'parsing/common/api_response'
require_relative 'parsing/common/job'
require_relative 'parsing/common/workflow_response'
require_relative 'logging'

# Default owner for products.
OTS_OWNER = 'mindee'

module Mindee
  # Class for page options in parse calls.
  #
  # @!attribute page_indexes [Array[Integer]] Zero-based list of page indexes.
  # @!attribute operation [:KEEP_ONLY, :REMOVE] Operation to apply on the document, given the specified page indexes:
  #   * `:KEEP_ONLY` - keep only the specified pages, and remove all others.
  #   * `:REMOVE` - remove the specified pages, and keep all others.
  # @!attribute on_min_pages [Integer, nil] Apply the operation only if the document has at least this many pages.
  class PageOptions
    attr_accessor :page_indexes, :operation, :on_min_pages

    def initialize(params: {})
      params ||= {}
      params = params.transform_keys(&:to_sym)
      @page_indexes = params.fetch(
        :page_indexes,
        [] # : Array[Integer]
      )
      @operation    = params.fetch(:operation, :KEEP_ONLY)
      @on_min_pages = params.fetch(:on_min_pages, nil)
    end
  end

  # Class for configuration options in parse calls.
  #
  # @!attribute all_words [bool] Whether to include the full text for each page.
  #   This performs a full OCR operation on the server and will increase response time.
  # @!attribute full_text [bool] Whether to include the full OCR text response in compatible APIs.
  #   This performs a full OCR operation on the server and may increase response time.
  # @!attribute close_file [bool] Whether to `close()` the file after parsing it.
  #   Set to false if you need to access the file after this operation.
  # @!attribute page_options [PageOptions, Hash, nil] Page cutting/merge options:
  #   * `:page_indexes` Zero-based list of page indexes.
  #   * `:operation` Operation to apply on the document, given the specified page indexes:
  #       * `:KEEP_ONLY` - keep only the specified pages, and remove all others.
  #       * `:REMOVE` - remove the specified pages, and keep all others.
  #   * `:on_min_pages` Apply the operation only if the document has at least this many pages.
  # @!attribute cropper [bool] Whether to include cropper results for each page.
  #   This performs a cropping operation on the server and will increase response time.
  # @!attribute initial_delay_sec [Numeric] Initial delay before polling. Defaults to 2.
  # @!attribute delay_sec [Numeric] Delay between polling attempts. Defaults to 1.5.
  # @!attribute max_retries [Integer] Maximum number of retries. Defaults to 80.
  class ParseOptions
    attr_accessor :all_words, :full_text, :close_file, :page_options, :cropper,
                  :initial_delay_sec, :delay_sec, :max_retries

    def initialize(params: {})
      params = params.transform_keys(&:to_sym)
      @all_words = params.fetch(:all_words, false)
      @full_text = params.fetch(:full_text, false)
      @close_file = params.fetch(:close_file, true)
      raw_page_options = params.fetch(:page_options, nil)
      raw_page_options = PageOptions.new(params: raw_page_options) unless raw_page_options.is_a?(PageOptions)
      @page_options = raw_page_options
      @cropper = params.fetch(:cropper, false)
      @initial_delay_sec = params.fetch(:initial_delay_sec, 2)
      @delay_sec = params.fetch(:delay_sec, 1.5)
      @max_retries = params.fetch(:max_retries, 80)
    end
  end

  # Class for configuration options in workflow executions.
  #
  # @!attribute document_alias [String, nil] Alias to give to the document.
  # @!attribute priority [Symbol, nil] Priority to give to the document.
  # @!attribute full_text [bool] Whether to include the full OCR text response in compatible APIs.
  #   This performs a full OCR operation on the server and may increase response time.
  # @!attribute public_url [String, nil] A unique, encrypted URL for accessing the document validation interface without
  #   requiring authentication.
  # @!attribute page_options [PageOptions, Hash, nil] Page cutting/merge options:
  #   * `:page_indexes` Zero-based list of page indexes.
  #   * `:operation` Operation to apply on the document, given the specified page indexes:
  #       * `:KEEP_ONLY` - keep only the specified pages, and remove all others.
  #       * `:REMOVE` - remove the specified pages, and keep all others.
  #   * `:on_min_pages` Apply the operation only if the document has at least this many pages.
  class WorkflowOptions
    attr_accessor :document_alias, :priority, :full_text, :public_url, :page_options

    def initialize(params: {})
      params = params.transform_keys(&:to_sym)
      @document_alias = params.fetch(:document_alias, nil)
      @priority = params.fetch(:priority, nil)
      @full_text = params.fetch(:full_text, false)
      @public_url = params.fetch(:public_url, nil)
      raw_page_options = params.fetch(:page_options, nil)
      raw_page_options = PageOptions.new(params: raw_page_options) unless raw_page_options.is_a?(PageOptions)
      @page_options = raw_page_options
    end
  end

  # Mindee API Client.
  # See: https://developers.mindee.com/docs
  class Client
    # @param api_key [String]
    def initialize(api_key: '')
      @api_key = api_key
    end

    # Enqueue a document for parsing and automatically try to retrieve it if needed.
    #
    # Accepts options either as a Hash or as a ParseOptions struct.
    #
    # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::UrlInputSource]
    # @param product_class [Mindee::Inference] The class of the product.
    # @param endpoint [Mindee::HTTP::Endpoint, nil] Endpoint of the API.
    # @param options [Hash] A hash of options to configure the parsing behavior. Possible keys:
    #   * `:all_words` [bool] Whether to extract all the words on each page.
    #       This performs a full OCR operation on the server and will increase response time.
    #   * `:full_text` [bool] Whether to include the full OCR text response in compatible APIs.
    #       This performs a full OCR operation on the server and may increase response time.
    #   * `:close_file` [bool] Whether to `close()` the file after parsing it.
    #       Set to false if you need to access the file after this operation.
    #   * `:page_options` [Hash, nil] Page cutting/merge options:
    #       - `:page_indexes` [Array<Integer>] Zero-based list of page indexes.
    #       - `:operation` [Symbol] Operation to apply on the document, given the `page_indexes` specified:
    #           - `:KEEP_ONLY` - keep only the specified pages, and remove all others.
    #           - `:REMOVE` - remove the specified pages, and keep all others.
    #       - `:on_min_pages` [Integer] Apply the operation only if the document has at least this many pages.
    #   * `:cropper` [bool, nil] Whether to include cropper results for each page.
    #       This performs a cropping operation on the server and will increase response time.
    #   * `:initial_delay_sec` [Numeric] Initial delay before polling. Defaults to 2.
    #   * `:delay_sec` [Numeric] Delay between polling attempts. Defaults to 1.5.
    #   * `:max_retries` [Integer] Maximum number of retries. Defaults to 80.
    # @param enqueue [bool] Whether to enqueue the file.
    # @return [Mindee::Parsing::Common::ApiResponse]
    def parse(input_source, product_class, endpoint: nil, options: {}, enqueue: true)
      opts = normalize_parse_options(options)
      process_pdf_if_required(input_source, opts) if input_source.is_a?(Input::Source::LocalInputSource)
      endpoint ||= initialize_endpoint(product_class)

      if enqueue && product_class.has_async
        enqueue_and_parse(input_source, product_class, endpoint, opts)
      else
        parse_sync(input_source, product_class, endpoint, opts)
      end
    end

    # Call prediction API on a document and parse the results.
    #
    # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::UrlInputSource]
    # @param product_class [Mindee::Inference] class of the product
    # @param endpoint [Mindee::HTTP::Endpoint, nil] Endpoint of the API.
    # @param options [Hash] A hash of options to configure the parsing behavior. Possible keys:
    #   * `:all_words` [bool] Whether to extract all the words on each page.
    #       This performs a full OCR operation on the server and will increase response time.
    #   * `:full_text` [bool] Whether to include the full OCR text response in compatible APIs.
    #       This performs a full OCR operation on the server and may increase response time.
    #   * `:close_file` [bool] Whether to `close()` the file after parsing it.
    #       Set to false if you need to access the file after this operation.
    #   * `:page_options` [Hash, nil] Page cutting/merge options:
    #       - `:page_indexes` [Array<Integer>] Zero-based list of page indexes.
    #       - `:operation` [Symbol] Operation to apply on the document, given the `page_indexes` specified:
    #           - `:KEEP_ONLY` - keep only the specified pages, and remove all others.
    #           - `:REMOVE` - remove the specified pages, and keep all others.
    #       - `:on_min_pages` [Integer] Apply the operation only if the document has at least this many pages.
    #   * `:cropper` [bool, nil] Whether to include cropper results for each page.
    #       This performs a cropping operation on the server and will increase response time.
    # @return [Mindee::Parsing::Common::ApiResponse]
    def parse_sync(input_source, product_class, endpoint, options)
      logger.debug("Parsing document as '#{endpoint.url_root}'")

      prediction, raw_http = endpoint.predict(
        input_source,
        options.all_words,
        options.full_text,
        options.close_file,
        options.cropper
      )

      Mindee::Parsing::Common::ApiResponse.new(product_class, prediction, raw_http)
    end

    # Enqueue a document for async parsing
    #
    # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::UrlInputSource]
    #   The source of the input document (local file or URL).
    # @param product_class [Mindee::Inference] The class of the product.
    # @param options [Hash] A hash of options to configure the enqueue behavior. Possible keys:
    #   * `:endpoint` [HTTP::Endpoint, nil] Endpoint of the API.
    #       Doesn't need to be set in the case of OTS APIs.
    #   * `:all_words` [bool] Whether to extract all the words on each page.
    #       This performs a full OCR operation on the server and will increase response time.
    #   * `:full_text` [bool] Whether to include the full OCR text response in compatible APIs.
    #       This performs a full OCR operation on the server and may increase response time.
    #   * `:close_file` [bool] Whether to `close()` the file after parsing it.
    #       Set to false if you need to access the file after this operation.
    #   * `:page_options` [Hash, nil] Page cutting/merge options:
    #       - `:page_indexes` [Array<Integer>] Zero-based list of page indexes.
    #       - `:operation` [Symbol] Operation to apply on the document, given the `page_indexes` specified:
    #           - `:KEEP_ONLY` - keep only the specified pages, and remove all others.
    #           - `:REMOVE` - remove the specified pages, and keep all others.
    #       - `:on_min_pages` [Integer] Apply the operation only if the document has at least this many pages.
    #   * `:cropper` [bool] Whether to include cropper results for each page.
    #       This performs a cropping operation on the server and will increase response time.
    # @param endpoint [Mindee::HTTP::Endpoint] Endpoint of the API.
    # @return [Mindee::Parsing::Common::ApiResponse]
    def enqueue(input_source, product_class, endpoint: nil, options: {})
      opts = normalize_parse_options(options)
      endpoint ||= initialize_endpoint(product_class)
      logger.debug("Enqueueing document as '#{endpoint.url_root}'")

      prediction, raw_http = endpoint.predict_async(
        input_source,
        opts.all_words,
        opts.full_text,
        opts.close_file,
        opts.cropper
      )
      Mindee::Parsing::Common::ApiResponse.new(product_class, prediction, raw_http)
    end

    # Parses a queued document
    #
    # @param job_id [String] ID of the job (queue) to poll from
    # @param product_class [Mindee::Inference] class of the product
    # @param endpoint [HTTP::Endpoint, nil] Endpoint of the API
    # Doesn't need to be set in the case of OTS APIs.
    #
    # @return [Mindee::Parsing::Common::ApiResponse]
    def parse_queued(job_id, product_class, endpoint: nil)
      endpoint = initialize_endpoint(product_class) if endpoint.nil?
      logger.debug("Fetching queued document as '#{endpoint.url_root}'")
      prediction, raw_http = endpoint.parse_async(job_id)
      Mindee::Parsing::Common::ApiResponse.new(product_class, prediction, raw_http)
    end

    # Enqueue a document for async parsing and automatically try to retrieve it
    #
    # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::UrlInputSource]
    #   The source of the input document (local file or URL).
    # @param product_class [Mindee::Inference] The class of the product.
    # @param options [Hash] A hash of options to configure the parsing behavior. Possible keys:
    #   * `:endpoint` [HTTP::Endpoint, nil] Endpoint of the API.
    #       Doesn't need to be set in the case of OTS APIs.
    #   * `:all_words` [bool] Whether to extract all the words on each page.
    #       This performs a full OCR operation on the server and will increase response time.
    #   * `:full_text` [bool] Whether to include the full OCR text response in compatible APIs.
    #       This performs a full OCR operation on the server and may increase response time.
    #   * `:close_file` [bool] Whether to `close()` the file after parsing it.
    #       Set to false if you need to access the file after this operation.
    #   * `:page_options` [Hash, nil] Page cutting/merge options:
    #       - `:page_indexes` [Array<Integer>] Zero-based list of page indexes.
    #       - `:operation` [Symbol] Operation to apply on the document, given the `page_indexes` specified:
    #           - `:KEEP_ONLY` - keep only the specified pages, and remove all others.
    #           - `:REMOVE` - remove the specified pages, and keep all others.
    #       - `:on_min_pages` [Integer] Apply the operation only if the document has at least this many pages.
    #   * `:cropper` [bool, nil] Whether to include cropper results for each page.
    #       This performs a cropping operation on the server and will increase response time.
    #   * `:initial_delay_sec` [Numeric] Initial delay before polling. Defaults to 2.
    #   * `:delay_sec` [Numeric] Delay between polling attempts. Defaults to 1.5.
    #   * `:max_retries` [Integer] Maximum number of retries. Defaults to 80.
    # @param endpoint [Mindee::HTTP::Endpoint] Endpoint of the API.
    # @return [Mindee::Parsing::Common::ApiResponse]
    def enqueue_and_parse(input_source, product_class, endpoint, options)
      validate_async_params(options.initial_delay_sec, options.delay_sec, options.max_retries)
      enqueue_res = enqueue(input_source, product_class, endpoint: endpoint, options: options)
      job = enqueue_res.job or raise Errors::MindeeAPIError, 'Expected job to be present'
      job_id = job.id

      sleep(options.initial_delay_sec)
      polling_attempts = 1
      logger.debug("Successfully enqueued document with job id: '#{job_id}'")
      queue_res = parse_queued(job_id, product_class, endpoint: endpoint)
      queue_res_job = queue_res.job or raise Errors::MindeeAPIError, 'Expected job to be present'
      valid_statuses = [
        Mindee::Parsing::Common::JobStatus::WAITING,
        Mindee::Parsing::Common::JobStatus::PROCESSING,
      ]
      # @type var valid_statuses: Array[(:waiting | :processing | :completed | :failed)]
      while valid_statuses.include?(queue_res_job.status) && polling_attempts < options.max_retries
        logger.debug("Polling server for parsing result with job id: '#{job_id}'. Attempt #{polling_attempts}")
        sleep(options.delay_sec)
        queue_res = parse_queued(job_id, product_class, endpoint: endpoint)
        queue_res_job = queue_res.job or raise Errors::MindeeAPIError, 'Expected job to be present'
        polling_attempts += 1
      end

      if queue_res_job.status != Mindee::Parsing::Common::JobStatus::COMPLETED
        elapsed = options.initial_delay_sec + (polling_attempts * options.delay_sec.to_f)
        raise Errors::MindeeAPIError,
              "Asynchronous parsing request timed out after #{elapsed} seconds (#{polling_attempts} tries)"
      end

      queue_res
    end

    # Same idea applies to execute_workflow:
    #
    # Sends a document to a workflow.
    #
    # Accepts options either as a Hash or as a WorkflowOptions struct.
    #
    # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::UrlInputSource]
    # @param workflow_id [String]
    # @param options [Hash, WorkflowOptions] Options to configure workflow behavior.  Possible keys:
    #   * `document_alias` [String, nil] Alias to give to the document.
    #   * `priority` [Symbol, nil] Priority to give to the document.
    #   * `full_text` [bool] Whether to include the full OCR text response in compatible APIs.
    #
    #   * `public_url` [String, nil] A unique, encrypted URL for accessing the document validation interface without
    # requiring authentication.
    #   * `page_options` [Hash, nil] Page cutting/merge options:
    #     * `:page_indexes` Zero-based list of page indexes.
    #       * `:operation` Operation to apply on the document, given the `page_indexes specified:
    #          * `:KEEP_ONLY` - keep only the specified pages, and remove all others.
    #          * `:REMOVE` - remove the specified pages, and keep all others.
    #      * `:on_min_pages` Apply the operation only if document has at least this many pa
    # @return [Mindee::Parsing::Common::WorkflowResponse]
    def execute_workflow(input_source, workflow_id, options: {})
      opts = options.is_a?(WorkflowOptions) ? options : WorkflowOptions.new(params: options)
      if opts.respond_to?(:page_options) && input_source.is_a?(Input::Source::LocalInputSource)
        process_pdf_if_required(input_source,
                                opts)
      end

      workflow_endpoint = Mindee::HTTP::WorkflowEndpoint.new(workflow_id, api_key: @api_key)
      logger.debug("Sending document to workflow '#{workflow_id}'")

      prediction, raw_http = workflow_endpoint.execute_workflow(
        input_source,
        opts.full_text,
        opts.document_alias,
        opts.priority,
        opts.public_url
      )

      Mindee::Parsing::Common::WorkflowResponse.new(Product::Universal::Universal, prediction, raw_http)
    end

    # Load a prediction.
    #
    # @param product_class [Mindee::Inference] class of the product
    # @param local_response [Mindee::Input::LocalResponse]
    # @return [Mindee::Parsing::Common::ApiResponse]
    def load_prediction(product_class, local_response)
      raise Errors::MindeeAPIError, 'Expected LocalResponse to not be nil.' if local_response.nil?

      response_hash = local_response.as_hash || {}
      raise Errors::MindeeAPIError, 'Expected LocalResponse#as_hash to return a hash.' if response_hash.nil?

      Mindee::Parsing::Common::ApiResponse.new(product_class, response_hash, response_hash.to_json)
    rescue KeyError, Errors::MindeeAPIError
      raise Errors::MindeeInputError, 'No prediction found in local response.'
    end

    # Load a document from an absolute path, as a string.
    # @param input_path [String] Path of file to open
    # @param fix_pdf [bool] Attempts to fix broken pdf if true
    # @return [Mindee::Input::Source::PathInputSource]
    def source_from_path(input_path, fix_pdf: false)
      Input::Source::PathInputSource.new(input_path, fix_pdf: fix_pdf)
    end

    # Load a document from raw bytes.
    # @param input_bytes [String] Encoding::BINARY byte input
    # @param filename [String] The name of the file (without the path)
    # @param fix_pdf [bool] Attempts to fix broken pdf if true
    # @return [Mindee::Input::Source::BytesInputSource]
    def source_from_bytes(input_bytes, filename, fix_pdf: false)
      Input::Source::BytesInputSource.new(input_bytes, filename, fix_pdf: fix_pdf)
    end

    # Load a document from a base64 encoded string.
    # @param base64_string [String] Input to parse as base64 string
    # @param filename [String] The name of the file (without the path)
    # @param fix_pdf [bool] Attempts to fix broken pdf if true
    # @return [Mindee::Input::Source::Base64InputSource]
    def source_from_b64string(base64_string, filename, fix_pdf: false)
      Input::Source::Base64InputSource.new(base64_string, filename, fix_pdf: fix_pdf)
    end

    # Load a document from a normal Ruby `File`.
    # @param input_file [File] Input file handle
    # @param filename [String] The name of the file (without the path)
    # @param fix_pdf [bool] Attempts to fix broken pdf if true
    # @return [Mindee::Input::Source::FileInputSource]
    def source_from_file(input_file, filename, fix_pdf: false)
      Input::Source::FileInputSource.new(input_file, filename, fix_pdf: fix_pdf)
    end

    # Load a document from a secure remote source (HTTPS).
    # @param url [String] Url of the file
    # @return [Mindee::Input::Source::UrlInputSource]
    def source_from_url(url)
      Input::Source::UrlInputSource.new(url)
    end

    # Creates a custom endpoint with the given values.
    # Do not set for standard (off the shelf) endpoints.
    #
    # @param endpoint_name [String] For custom endpoints, the "API name" field in the "Settings" page of the
    #  API Builder. Do not set for standard (off the shelf) endpoints.
    #
    # @param account_name [String] For custom endpoints, your account or organization username on the API Builder.
    #  This is normally not required unless you have a custom endpoint which has the same name as a
    #  standard (off the shelf) endpoint.
    # @param version [String] For custom endpoints, version of the product
    # @return [Mindee::HTTP::Endpoint]
    def create_endpoint(endpoint_name: '', account_name: '', version: '')
      initialize_endpoint(
        Mindee::Product::Universal::Universal,
        endpoint_name: endpoint_name,
        account_name: account_name,
        version: version
      )
    end

    # Validates the parameters for async auto-polling
    # @param initial_delay_sec [Numeric] initial delay before polling
    # @param delay_sec [Numeric] delay between polling attempts
    # @param max_retries [Integer, nil] maximum amount of retries.
    def validate_async_params(initial_delay_sec, delay_sec, max_retries)
      min_delay_sec = 1
      min_initial_delay_sec = 1
      min_retries = 2

      if delay_sec < min_delay_sec
        raise ArgumentError,
              "Cannot set auto-poll delay to less than #{min_delay_sec} second(s)"
      end
      if initial_delay_sec < min_initial_delay_sec
        raise ArgumentError,
              "Cannot set initial parsing delay to less than #{min_initial_delay_sec} second(s)"
      end
      raise ArgumentError, "Cannot set auto-poll retries to less than #{min_retries}" if max_retries < min_retries
    end

    # Creates an endpoint with the given values. Raises an error if the endpoint is invalid.
    # @param product_class [Mindee::Parsing::Common::Inference] class of the product
    #
    # @param endpoint_name [String] For custom endpoints, the "API name" field in the "Settings" page of the
    #  API Builder. Do not set for standard (off the shelf) endpoints.
    #
    # @param account_name [String] For custom endpoints, your account or organization username on the API Builder.
    #  This is normally not required unless you have a custom endpoint which has the same name as a
    #  standard (off the shelf) endpoint.
    # @param version [String] For custom endpoints, version of the product.
    # @return [Mindee::HTTP::Endpoint]
    def initialize_endpoint(product_class, endpoint_name: '', account_name: '', version: '')
      if (endpoint_name.nil? || endpoint_name.empty?) && product_class == Mindee::Product::Universal::Universal
        raise Mindee::Errors::MindeeConfigurationError, 'Missing argument endpoint_name when using custom class'
      end

      endpoint_name = fix_endpoint_name(product_class, endpoint_name)
      account_name = fix_account_name(account_name)
      version = fix_version(product_class, version)

      HTTP::Endpoint.new(account_name, endpoint_name, version, api_key: @api_key)
    end

    def fix_endpoint_name(product_class, endpoint_name)
      endpoint_name.nil? || endpoint_name.empty? ? product_class.endpoint_name : endpoint_name
    end

    def fix_account_name(account_name)
      if account_name.nil? || account_name.empty?
        logger.info("No account name provided, #{OTS_OWNER} will be used by default.")
        return OTS_OWNER
      end

      account_name
    end

    def fix_version(product_class, version)
      return version unless version.nil? || version.empty?

      if product_class.endpoint_version.nil? || product_class.endpoint_version.empty?
        logger.debug('No version provided for a custom build, will attempt to poll version 1 by default.')
        return '1'
      end
      product_class.endpoint_version
    end

    # If needed, converts the parsing options provided as a hash into a proper ParseOptions object.
    # @param options [Hash, ParseOptions] Options.
    # @return [ParseOptions]
    def normalize_parse_options(options)
      return options if options.is_a?(ParseOptions)

      ParseOptions.new(params: options)
    end

    # Processes a PDF if parameters were provided.
    # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::UrlInputSource]
    # @param opts [ParseOptions]
    def process_pdf_if_required(input_source, opts)
      return unless input_source.is_a?(Mindee::Input::Source::LocalInputSource) &&
                    opts.page_options &&
                    input_source.pdf?

      input_source.process_pdf(opts.page_options)
    end

    private :parse_sync, :validate_async_params, :initialize_endpoint, :fix_endpoint_name, :fix_version,
            :fix_account_name, :process_pdf_if_required, :normalize_parse_options
  end
end
