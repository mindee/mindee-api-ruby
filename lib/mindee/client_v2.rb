# frozen_string_literal: true

require_relative 'input'
require_relative 'http'
require_relative 'product'
require_relative 'parsing/common/api_response'
require_relative 'parsing/common/job'
require_relative 'parsing/common/workflow_response'
require_relative 'logging'

module Mindee
  # Mindee API Client.
  # See: https://developers.mindee.com/docs
  class ClientV2
    # @return [HTTP::MindeeApiV2]
    private attr_reader :mindee_api

    # @param api_key [String]
    def initialize(api_key: '')
      @mindee_api = Mindee::HTTP::MindeeApiV2.new(api_key)
    end

    # Retrieves an inference.
    # @param inference_id [String]
    # @return [Mindee::Parsing::V2::InferenceResponse]
    def get_inference(inference_id)
      @mindee_api.req_get_inference(inference_id)
    end

    # Retrieves an inference.
    # @param job_id [String]
    # @return [Mindee::Parsing::V2::JobResponse]
    def get_job(job_id)
      @mindee_api.req_get_job(job_id)
    end

    # Enqueue a document for async parsing
    #
    # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::URLInputSource]
    #   The source of the input document (local file or URL).
    # @param params [Hash, InferenceParameters]
    # @return [Mindee::Parsing::V2::JobResponse]
    def enqueue_inference(input_source, params)
      normalized_params = normalize_inference_parameters(params)
      logger.debug("Enqueueing document to model '#{normalized_params.model_id}'.")

      @mindee_api.req_post_inference_enqueue(input_source, normalized_params)
    end

    # Enqueue a document for async parsing and automatically try to retrieve it
    #
    # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::URLInputSource]
    #   The source of the input document (local file or URL).
    # @param params [Hash, InferenceParameters] Parameters for the inference.
    # @return [Mindee::Parsing::V2::InferenceResponse]
    def enqueue_and_get_inference(input_source, params)
      normalized_params = normalize_inference_parameters(params)
      normalized_params.validate_async_params
      enqueue_response = enqueue_inference(input_source, normalized_params)

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
        elsif poll_results.job.status == 'Processed'
          return get_inference(poll_results.job.id)
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

    # If needed, converts the parsing options provided as a hash into a proper InferenceParameters object.
    # @param params [Hash, InferenceParameters] Params.
    # @return [InferenceParameters]
    def normalize_inference_parameters(params)
      return params if params.is_a?(Mindee::Input::InferenceParameters)

      InferenceParameters.new(params: params)
    end
  end
end
