# frozen_string_literal: true

require_relative '../input'
require_relative '../http'
require_relative 'product'
require_relative 'parsing/job'
require_relative '../logging'

module Mindee
  module V2
    # Mindee V2 API Client.
    class Client
      # @return [V2::HTTP::MindeeApi]
      private attr_reader :mindee_api

      # @param api_key [String]
      def initialize(api_key: '')
        @mindee_api = Mindee::V2::HTTP::MindeeApi.new(api_key: api_key)
      end

      # Retrieves a result from a given queue or URL to the result.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The return class.
      # @param resource [String] ID of the inference or URL to the result.
      # @return [Mindee::V2::Parsing::BaseResponse]
      def get_result(product, resource)
        @mindee_api.req_get_result(product, resource)
      end

      # Retrieves an inference from a given queue or URL to the job.
      # @param job_id [String] ID of the job.
      # @return [Mindee::V2::Parsing::JobResponse]
      def get_job(job_id)
        @mindee_api.req_get_job(job_id)
      end

      # Enqueue a document for async parsing.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The return class.
      # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::URLInputSource]
      #   The source of the input document (local file or URL).
      # @param params [Hash, Input::BaseParameters] Parameters for the inference.
      # @return [Mindee::V2::Parsing::JobResponse]
      def enqueue(
        product,
        input_source,
        params
      )
        normalized_params = normalize_parameters(product.params_type, params)
        normalized_params.validate_async_params
        logger.debug("Enqueueing document to model '#{normalized_params.model_id}'.")

        @mindee_api.req_post_enqueue(input_source, normalized_params)
      end

      # Enqueues to an asynchronous endpoint and automatically polls for a response.
      #
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The return class.
      # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::URLInputSource]
      #   The source of the input document (local file or URL).
      # @param params [Hash, Input::BaseParameters] Parameters for the inference.
      # @return [Parsing::BaseResponse]
      def enqueue_and_get_result(
        product,
        input_source,
        params
      )
        enqueue_response = enqueue(product, input_source, params)
        normalized_params = normalize_parameters(product.params_type, params)
        normalized_params.validate_async_params

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
            return get_result(product, poll_results.job.result_url)
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

      # Searches for a list of available models for the given API key.
      # @param model_name [String]
      # @param model_type [String]
      # @return [Mindee::V2::Parsing::Search::SearchResponse]
      def search_models(model_name, model_type)
        @mindee_api.search_models(model_name, model_type)
      end

      private

      # If needed, converts the parsing options provided as a hash into a proper BaseParameters subclass object.
      # @param params [Hash, Class<BaseParameters>] Params.
      # @return [BaseParameters]
      def normalize_parameters(param_class, params)
        return param_class.from_hash(params: params) if params.is_a?(Hash)

        params
      end
    end
  end
end
