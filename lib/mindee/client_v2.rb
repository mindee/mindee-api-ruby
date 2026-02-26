# frozen_string_literal: true

require_relative 'input'
require_relative 'http'
require_relative 'product'
require_relative 'parsing/common/api_response'
require_relative 'parsing/common/job'
require_relative 'parsing/common/workflow_response'
require_relative 'logging'

module Mindee
  # Mindee V2 API Client.
  class ClientV2
    # @return [HTTP::MindeeApiV2]
    private attr_reader :mindee_api

    # @param api_key [String]
    def initialize(api_key: '')
      @mindee_api = Mindee::HTTP::MindeeApiV2.new(api_key: api_key)
    end

    # Retrieves an inference.
    # @param inference_id [String]
    # @return [Mindee::Parsing::V2::InferenceResponse]
    def get_inference(inference_id)
      @mindee_api.req_get_inference(inference_id)
    end

    # Retrieves a result from a given queue or URL to the result.
    # @param resource [String] ID of the inference or URL to the result.
    # @param response_class [Class<Mindee::Parsing::V2::BaseResponse>]
    # @return [Mindee::Parsing::V2::BaseResponse]
    def get_result(response_class, resource)
      @mindee_api.req_get_result(response_class, resource)
    end

    # Retrieves an inference from a given queue or URL to the job.
    # @param resource [String] ID of the job or URL to the job.
    # @return [Mindee::Parsing::V2::JobResponse]
    def get_job(resource)
      @mindee_api.req_get_job(resource)
    end

    # Enqueue a document for async parsing.
    # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::URLInputSource]
    #   The source of the input document (local file or URL).
    # @param params [Hash, InferenceParameters]
    # @return [Mindee::Parsing::V2::JobResponse]
    def enqueue_inference(input_source, params, disable_redundant_warnings: false)
      unless disable_redundant_warnings
        warn '[DEPRECATION] `enqueue_inference` is deprecated; use `enqueue` instead.', uplevel: 1
      end
      normalized_params = normalize_parameters(Input::InferenceParameters, params)
      enqueue(input_source, normalized_params)
    end

    # Enqueue a document for async parsing.
    # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::URLInputSource]
    #   The source of the input document (local file or URL).
    # @param params [BaseParameters]
    # @return [Mindee::Parsing::V2::JobResponse]
    def enqueue(input_source, params)
      logger.debug("Enqueueing document to model '#{params.model_id}'.")

      @mindee_api.req_post_enqueue(input_source, params)
    end

    # Enqueues to an asynchronous endpoint and automatically polls for a response.
    #
    # @param response_type [Mindee::V2::BaseResponse] The return class.
    # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::URLInputSource]
    #   The source of the input document (local file or URL).
    # @param params [Hash, InferenceParameters] Parameters for the inference.
    # @return [Mindee::Parsing::Common::ApiResponse]
    def enqueue_and_get_result(
      response_type,
      input_source,
      params
    )
      normalized_params = normalize_parameters(response_type._params_type, params)
      normalized_params.validate_async_params
      enqueue_response = enqueue(input_source, normalized_params)

      if enqueue_response.job.id.nil? || enqueue_response.job.id.empty?
        logger.error("Failed enqueueing:\n#{enqueue_response.raw_http}")
        raise Mindee::Errors::MindeeError, 'Enqueueing of the document failed.'
      end

      job_id = enqueue_response.job.id
      logger.debug("Successfully enqueued document with job id: #{job_id}.")

      sleep(normalized_params.polling_options.initial_delay_sec)
      retry_counter = 1
      poll_results = get_job(job_id)

      while retry_counter < normalized_params.polling_options.max_retries
        if poll_results.job.status == 'Failed'
          break
        elsif !poll_results.job.result_url.nil?
          return get_result(response_type, poll_results.job.result_url)
        end

        logger.debug(
          "Successfully enqueued inference with job id: #{job_id}.\n" \
          "Attempt n°#{retry_counter}/#{normalized_params.polling_options.max_retries}.\n" \
          "Job status: #{poll_results.job.status}."
        )

        sleep(normalized_params.polling_options.delay_sec)
        poll_results = get_job(job_id)
        retry_counter += 1
      end

      error = poll_results.job.error
      unless error.nil?
        err_to_raise = Mindee::Errors::MindeeHTTPErrorV2.new(error)
        # NOTE: purposefully decoupled from the line above, otherwise rubocop thinks `error` is a `message` param.
        raise err_to_raise
      end

      sec_count = normalized_params.polling_options.delay_sec * retry_counter
      raise Mindee::Errors::MindeeError,
            "Asynchronous parsing request timed out after #{sec_count} seconds"
    end

    # Enqueue a document for async parsing and automatically try to retrieve it.
    # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::URLInputSource]
    #   The source of the input document (local file or URL).
    # @param params [Hash, InferenceParameters] Parameters for the inference.
    # @return [Mindee::Parsing::V2::InferenceResponse]
    def enqueue_and_get_inference(input_source, params)
      warn '[DEPRECATION] `enqueue_and_get_inference` is deprecated; use `enqueue_and_get_result` instead.'

      response = enqueue_and_get_result(Mindee::Parsing::V2::InferenceResponse, input_source, params)
      unless response.is_a?(Mindee::Parsing::V2::InferenceResponse)
        raise TypeError, "Invalid response type \"#{response.class}\""
      end

      response
    end

    # If needed, converts the parsing options provided as a hash into a proper InferenceParameters object.
    # @param params [Hash, Class<BaseParameters>] Params.
    # @return [BaseParameters]
    def normalize_parameters(param_class, params)
      return param_class.from_hash(params: params) if params.is_a?(Hash)

      params
    end
  end
end
