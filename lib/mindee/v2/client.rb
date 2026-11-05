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
      # @return [V2::HTTP::MindeeApiV2]
      private attr_reader :mindee_api

      # @param api_key [String]
      def initialize(api_key: '')
        @mindee_api = Mindee::V2::HTTP::MindeeApiV2.new(api_key: api_key)
      end

      # Send a file to the asynchronous processing queue for inference.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The return class.
      # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::URLInputSource]
      #   The source of the input document (local file or URL).
      # @param params [Hash, ClientOptions::BaseProductParameters] Parameters for the inference.
      # @return [Mindee::V2::Parsing::JobResponse]
      def enqueue(
        product,
        input_source,
        params
      )
        params_instance = case params
                          when Hash
                            product.params_type.from_hash(params: params)
                          when Mindee::V2::ClientOptions::BaseProductParameters
                            params
                          else
                            raise ArgumentError, "Expected Hash or BaseProductParameters, got #{params.class}"
                          end

        logger.debug("Enqueueing document to model '#{params_instance.model_id}'.")

        @mindee_api.req_post_product_enqueue(input_source, params_instance)
      end

      # Get the status of an inference that was previously enqueued.
      # Can be used for polling.
      # @param url [String] HTTPS URL to the job.
      # @return [Mindee::V2::Parsing::JobResponse]
      def get_job_by_url(url)
        @mindee_api.req_get_job_by_url(url)
      end

      # Get the result of an inference that was previously enqueued.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The return class.
      # @param url [String] HTTPS URL to the result.
      # @return [Mindee::V2::Parsing::BaseResponse]
      def get_result_by_url(product, url)
        @mindee_api.req_get_result_by_url(product, url)
      end

      # Get the result of an inference that was previously enqueued.
      # Prefer using `get_result_by_url` using the result URL returned by the Job.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The return class.
      # @param resource [String] ID of the inference or URL to the result.
      # @return [Mindee::V2::Parsing::BaseResponse]
      def get_result(product, resource)
        @mindee_api.req_get_result_by_id(product, resource)
      end

      # Get the status of an inference that was previously enqueued.
      # Prefer using `get_job_by_url` with the polling URL returned by enqueue.
      # @param job_id [String] ID of the job.
      # @return [Mindee::V2::Parsing::JobResponse]
      def get_job(job_id)
        @mindee_api.req_get_job_by_id(job_id)
      end

      # Send a file to the inference queue and return the results when complete.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The product class.
      # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::URLInputSource]
      #   The source of the input document (local file or URL).
      # @param params [Hash, ClientOptions::BaseProductParameters] Parameters for the inference.
      # @param polling_options [Hash, PollingOptions, nil] Parameters for polling.
      # @param cancellation_token [Mindee::HTTP::CancellationToken, nil] Token for cancellation.
      # @return [Parsing::BaseResponse]
      # rubocop:disable-next Metrics/CyclomaticComplexity
      def enqueue_and_get_result(
        product,
        input_source,
        params,
        polling_options = nil,
        cancellation_token = nil
      )
        params_instance = case params
                          when Hash
                            product.params_type.from_hash(params: params)
                          when Mindee::V2::ClientOptions::BaseProductParameters
                            params
                          else
                            raise ArgumentError, "Expected Hash or BaseProductParameters, got #{params.class}"
                          end

        polling_options_instance = case polling_options
                                   when Mindee::Input::PollingOptions
                                     polling_options
                                   when Hash
                                     Mindee::Input::PollingOptions.from_hash(polling_options: polling_options)
                                   else
                                     Mindee::Input::PollingOptions.new
                                   end

        enqueue_response = enqueue(product, input_source, params_instance)

        if enqueue_response.job.id.nil? || enqueue_response.job.id.empty?
          logger.error("Failed enqueueing:\n#{enqueue_response.raw_http}")
          raise Mindee::Error::MindeeError, 'Enqueueing of the document failed.'
        end

        job_id = enqueue_response.job.id
        logger.debug("Successfully enqueued document with job id: #{job_id}.")

        raise Mindee::Error::MindeeError, 'Enqueueing of the document was canceled.' if cancellation_token&.canceled?

        poll_on_job(product, enqueue_response, polling_options_instance, cancellation_token)
      end

      # Search for resources matching the given criteria.
      # @param params [ClientOptions::BaseSearchParameters] Search parameters.
      # @return [Mindee::V2::Parsing::Search::BaseSearchResponse] A search response containing the matching resources.
      def search(params)
        @mindee_api.req_get_search(params)
      end

      # Returns a list of models matching a criteria for the given API key.
      # @deprecated Use {#search} instead.
      # @param model_name [String, nil] Name filter.
      # @param model_type [String, nil] Model type filter.
      # @return [Mindee::V2::Search::Models::ModelSearchResponse]
      def search_models(model_name, model_type)
        search(Search::Models::ModelSearchParameters.new(name: model_name, model_type: model_type))
      end

      private

      # Polls a job until it is processed or the maximum number of tries is reached.
      # @param product [Class<Mindee::V2::Product::BaseProduct>]
      # @param initial_response [V2::Parsing::JobResponse]
      # @param polling_options [Input::PollingOptions]
      # @param cancellation_token [Mindee::HTTP::CancellationToken, nil] Token for cancellation.
      # @return [Parsing::BaseResponse]
      def poll_on_job(
        product,
        initial_response,
        polling_options,
        cancellation_token
      )
        sleep(polling_options.initial_delay_sec)
        try_counter = 1
        max_retries = polling_options.max_retries
        polling_url = initial_response.job.polling_url

        job_response = get_job_by_url(polling_url)

        while try_counter < max_retries
          if job_response.job.status == 'Failed'
            break
          elsif !job_response.job.result_url.nil?
            return get_result_by_url(product, job_response.job.result_url)
          end

          logger.debug(
            "Poll attempt #{try_counter + 1} of #{max_retries}."
          )

          raise Mindee::Error::MindeeError, 'Enqueueing of the document was canceled.' if cancellation_token&.canceled?

          sleep(polling_options.delay_sec)
          job_response = get_job_by_url(polling_url)
          try_counter += 1
        end

        error = job_response.job.error
        unless error.nil?
          err_to_raise = Mindee::Error::MindeeHTTPErrorV2.new(error)
          # NOTE: purposefully decoupled from the line above, otherwise rubocop thinks `error` is a `message` param.
          raise err_to_raise
        end

        sec_count = polling_options.delay_sec * try_counter
        raise Mindee::Error::MindeeError,
              "Asynchronous parsing request timed out after #{sec_count} seconds"
      end
    end
  end
end
