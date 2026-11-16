# frozen_string_literal: true

require_relative '../input'
require_relative '../http'
require_relative 'product'
require_relative 'parsing/job'
require_relative '../logging'

module Mindee
  module V2
    # Mindee V2 API Client.
    # rubocop:disable-next Metrics/ClassLength
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
        params_instance = resolve_product_parameters(product, params)
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
      # @return [Mindee::V2::Parsing::BaseInferenceResponse]
      def get_result_by_url(product, url)
        @mindee_api.req_get_result_by_url(product, url)
      end

      # Get the result of an inference that was previously enqueued.
      # Prefer using `get_result_by_url` using the result URL returned by the Job.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The return class.
      # @param resource [String] ID of the inference or URL to the result.
      # @return [Mindee::V2::Parsing::BaseInferenceResponse]
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
      # @return [Parsing::BaseInferenceResponse]
      def enqueue_and_get_result(
        product,
        input_source,
        params,
        polling_options = nil,
        cancellation_token = nil
      )
        params_instance = resolve_product_parameters(product, params)
        polling_options_instance = resolve_polling_options(polling_options)

        enqueue_response = enqueue(product, input_source, params_instance)

        if enqueue_response.job.id.nil? || enqueue_response.job.id.empty?
          logger.error("Failed enqueueing:\n#{enqueue_response.raw_http}")
          raise Mindee::Error::MindeeError, 'Enqueueing of the document failed.'
        end

        job_id = enqueue_response.job.id
        logger.debug("Successfully enqueued document with job id: #{job_id}.")

        raise Mindee::Error::MindeeError, 'Enqueueing of the document was canceled.' if cancellation_token&.canceled?

        poll_for_product_result(
          product,
          enqueue_response,
          polling_options_instance,
          false,
          cancellation_token
        )
      end

      # Not recommended for general use, prefer {#upload_and_get_rag_document_poll}.
      # You will need to poll until the document is ready for use.
      # Add a document to the RAG database.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The product class.
      # @param input_source [Mindee::Input::Source::LocalInputSource] The file to upload.
      # @param params [Hash, ClientOptions::BaseRagDocumentUploadParameters] Upload parameters.
      # @return [Mindee::V2::Parsing::BaseRagAnnotationResponse]
      def upload_rag_document(
        product,
        input_source,
        params
      )
        params_instance = resolve_rag_upload_parameters(product, params)
        logger.info('Adding a document to the RAG database')
        @mindee_api.req_post_rag_document(product, params_instance, input_source)
      end

      # Add a document to the RAG database and return the initial annotation.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The product class.
      # @param input_source [Mindee::Input::Source::LocalInputSource] The file to upload.
      # @param params [Hash, ClientOptions::BaseRagDocumentUploadParameters] Upload parameters.
      # @param polling_options [Hash, Input::PollingOptions, nil] Parameters for polling.
      # @param cancellation_token [Mindee::HTTP::CancellationToken, nil] Token for cancellation.
      # @return [Mindee::V2::Parsing::BaseRagAnnotationResponse]
      def upload_and_get_rag_document(
        product,
        input_source,
        params,
        polling_options = nil,
        cancellation_token = nil
      )
        params_instance = resolve_rag_upload_parameters(product, params)
        initial_response = upload_rag_document(product, input_source, params_instance)

        poll_for_rag_document(
          product,
          initial_response,
          resolve_polling_options(polling_options),
          cancellation_token
        )
      end

      # Not recommended for general use, prefer {#get_ready_rag_document_poll}.
      # You will need to poll until the document is ready for use.
      # Get a document's info and annotations from the RAG database.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The product class.
      # @param document_id [String] The document's ID.
      # @return [Mindee::V2::Parsing::BaseRagAnnotationResponse]
      def get_rag_document(product, document_id)
        logger.info("Getting RAG document ID: #{document_id}")
        @mindee_api.req_get_rag_annotation(product, document_id)
      end

      # Get a document's info and annotations from the RAG database.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The product class.
      # @param document_id [String] The document's ID.
      # @param polling_options [Hash, Input::PollingOptions, nil] Parameters for polling.
      # @param cancellation_token [Mindee::HTTP::CancellationToken, nil] Token for cancellation.
      # @return [Mindee::V2::Parsing::BaseRagAnnotationResponse]
      def get_ready_rag_document(
        product,
        document_id,
        polling_options = nil,
        cancellation_token = nil
      )
        initial_response = get_rag_document(product, document_id)
        return initial_response unless initial_response.status == 'Processing'

        poll_for_rag_document(
          product,
          initial_response,
          resolve_polling_options(polling_options),
          cancellation_token
        )
      end

      # Not recommended for general use, prefer {#update_and_get_rag_annotation}.
      # You will need to poll until the document is ready for use.
      # Update a document's annotations in the RAG database.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The product class.
      # @param params [Hash, ClientOptions::BaseAnnotationParameters] Annotation parameters.
      # @return [Mindee::V2::Parsing::BaseRagAnnotationResponse]
      def update_rag_annotation(product, params)
        params_instance = resolve_rag_annotation_parameters(product, params)
        logger.info("Updating RAG document ID: #{params_instance.document_id}")
        @mindee_api.req_patch_rag_annotation(product, params_instance)
      end

      # Update a document's annotations in the RAG database.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The product class.
      # @param params [Hash, ClientOptions::BaseAnnotationParameters] Annotation parameters.
      # @param polling_options [Hash, Input::PollingOptions, nil] Parameters for polling.
      # @param cancellation_token [Mindee::HTTP::CancellationToken, nil] Token for cancellation.
      # @return [Mindee::V2::Parsing::BaseRagAnnotationResponse]
      def update_and_get_rag_annotation(
        product,
        params,
        polling_options = nil,
        cancellation_token = nil
      )
        params_instance = resolve_rag_annotation_parameters(product, params)
        initial_response = update_rag_annotation(product, params_instance)
        return initial_response unless initial_response.status == 'Processing'

        poll_for_rag_document(
          product,
          initial_response,
          resolve_polling_options(polling_options),
          cancellation_token
        )
      end

      # Delete a document from the RAG database.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The product class.
      # @param document_id [String] The document's ID.
      # @return [Boolean]
      def delete_rag_document(product, document_id)
        logger.info("Deleting RAG document ID: #{document_id}")
        @mindee_api.req_delete_rag_document(product, document_id)
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

      # Normalizes product parameters from an instance or hash.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The product class.
      # @param parameters [Hash, ClientOptions::BaseProductParameters] Parameters for the inference.
      # @return [ClientOptions::BaseProductParameters]
      def resolve_product_parameters(product, parameters)
        case parameters
        when Hash
          product.parameters_class.from_hash(params: parameters)
        when Mindee::V2::ClientOptions::BaseProductParameters
          parameters
        else
          raise ArgumentError, "Expected Hash or BaseProductParameters, got #{parameters.class}"
        end
      end

      # Normalizes RAG upload parameters from an instance or hash.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The product class.
      # @param parameters [Hash, ClientOptions::BaseRagDocumentUploadParameters] Parameters for the upload.
      # @return [ClientOptions::BaseRagDocumentUploadParameters]
      def resolve_rag_upload_parameters(product, parameters)
        case parameters
        when Hash
          product.rag_document_upload_class.from_hash(params: parameters)
        when Mindee::V2::ClientOptions::BaseRagDocumentUploadParameters
          parameters
        else
          raise ArgumentError, "Expected Hash or BaseRagDocumentUploadParameters, got #{parameters.class}"
        end
      end

      # Normalizes RAG annotation parameters from an instance or hash.
      # @param product [Class<Mindee::V2::Product::BaseProduct>] The product class.
      # @param parameters [Hash, ClientOptions::BaseAnnotationParameters] Parameters for the annotation.
      # @return [ClientOptions::BaseAnnotationParameters]
      def resolve_rag_annotation_parameters(product, parameters)
        case parameters
        when Hash
          product.annotation_parameters_class.from_hash(params: parameters)
        when Mindee::V2::ClientOptions::BaseAnnotationParameters
          parameters
        else
          raise ArgumentError, "Expected Hash or BaseAnnotationParameters, got #{parameters.class}"
        end
      end

      # Normalizes polling options from an instance, hash, or nil.
      # @param polling_options [Hash, Input::PollingOptions, nil]
      # @return [Input::PollingOptions]
      def resolve_polling_options(polling_options)
        case polling_options
        when Mindee::Input::PollingOptions
          polling_options
        when Hash
          Mindee::Input::PollingOptions.from_hash(polling_options: polling_options)
        else
          Mindee::Input::PollingOptions.new
        end
      end

      # Checks if all webhooks associated with a job have finished processing.
      # @param job_response [Mindee::V2::Parsing::JobResponse]
      # @return [Boolean]
      def check_webhooks_done?(job_response)
        are_webhooks_done = job_response.job.webhooks.nil? ||
                            job_response.job.webhooks.all? { |w| w.status != 'Processing' }

        if are_webhooks_done
          logger.debug('All webhooks are completed.')
          return true
        end

        logger.debug('Not all webhooks are completed.')
        false
      end

      # Wait and retry logic for polling operations.
      # @param try_counter [Integer] Current retry attempt index.
      # @param max_retries [Integer] Maximum number of retries.
      # @param polling_options [Input::PollingOptions] Options for polling.
      # @param cancellation_token [Mindee::HTTP::CancellationToken, nil] Token for cancellation.
      def throttle_polling_attempt(
        try_counter,
        max_retries,
        polling_options,
        cancellation_token = nil
      )
        if try_counter >= max_retries
          logger.debug('Not waiting, max retries reached.')
          return
        end

        raise Mindee::Error::MindeeError, 'Polling was canceled.' if cancellation_token&.canceled?

        logger.debug("Waiting #{polling_options.delay_sec} seconds before next attempt...")
        sleep(polling_options.delay_sec)
      end

      # Polls a job until it is processed or the maximum number of tries is reached.
      # @param initial_response [Mindee::V2::Parsing::JobResponse]
      # @param polling_options [Input::PollingOptions]
      # @param cancellation_token [Mindee::HTTP::CancellationToken, nil] Token for cancellation.
      # @return [Parsing::JobResponse]
      def poll_on_job(
        initial_response,
        polling_options,
        wait_for_webhooks = false,
        cancellation_token = nil
      )
        logger.debug(
          "Waiting #{polling_options.initial_delay_sec} seconds before attempting to retrieve the result..."
        )
        sleep(polling_options.initial_delay_sec)

        try_counter = 0
        max_retries = polling_options.max_retries
        polling_url = initial_response.job.polling_url

        while try_counter < max_retries
          raise Mindee::Error::MindeeError, 'Polling was canceled.' if cancellation_token&.canceled?

          logger.debug(
            "Poll attempt #{try_counter + 1} of #{max_retries}"
          )

          job_response = get_job_by_url(polling_url)

          if job_response.job.status == 'Processed'
            logger.debug(
              "Job ID #{job_response.job.id} completed processing at: #{job_response.job.completed_at}"
            )

            return job_response if !wait_for_webhooks || check_webhooks_done?(job_response)
          end

          if job_response.job.status == 'Failed'
            if job_response.job.error
              err_to_raise = Mindee::Error::MindeeHTTPErrorV2.new(job_response.job.error)
              raise err_to_raise, "Parsing failed for job #{job_response.job.id}: #{err_to_raise.message}"
            end

            raise Mindee::Error::MindeeError,
                  "Parsing failed for job #{job_response.job.id}: No error detail available."
          end

          try_counter += 1
          throttle_polling_attempt(try_counter, max_retries, polling_options, cancellation_token)
        end

        raise Mindee::Error::MindeeError, "Couldn't retrieve the result after #{try_counter} tries."
      end

      # Poll until the inference results are retrieved or the max number of attempts is reached.
      # @param product [Class<Mindee::V2::Product::BaseProduct>]
      # @param enqueue_response [V2::Parsing::JobResponse]
      # @param polling_options [Input::PollingOptions]
      # @param wait_for_webhooks [Boolean]
      # @param cancellation_token [Mindee::HTTP::CancellationToken, nil]
      # @return [Mindee::V2::Parsing::BaseInferenceResponse]
      def poll_for_product_result(
        product,
        enqueue_response,
        polling_options,
        wait_for_webhooks = false,
        cancellation_token = nil
      )
        job_response = poll_on_job(
          enqueue_response,
          polling_options,
          wait_for_webhooks,
          cancellation_token
        )

        if job_response.job.result_url.nil? || job_response.job.result_url.strip.empty?
          raise Mindee::Error::MindeeError,
                'The result URL is undefined. This is a server error, try again later or contact support.'
        end

        get_result_by_url(product, job_response.job.result_url)
      end

      # Poll until the RAG document is finished processing or the max number of attempts is reached.
      # @param product [Class<Mindee::V2::Product::BaseProduct>]
      # @param initial_response [Mindee::V2::Parsing::BaseRagAnnotationResponse]
      # @param polling_options [Input::PollingOptions]
      # @param cancellation_token [Mindee::HTTP::CancellationToken, nil]
      # @return [Mindee::V2::Parsing::BaseRagAnnotationResponse]
      # @raise [Mindee::Error::MindeeError] Thrown when max_retries is reached and the annotation isn't ready.
      def poll_for_rag_document(
        product,
        initial_response,
        polling_options,
        cancellation_token = nil
      )
        logger.info("Polling for RAG document ID: #{initial_response.id}")

        logger.debug(
          "Waiting #{polling_options.initial_delay_sec} seconds before attempting to retrieve the result..."
        )
        sleep(polling_options.initial_delay_sec)

        try_counter = 0
        max_retries = polling_options.max_retries
        document_id = initial_response.id

        while try_counter < max_retries
          raise Mindee::Error::MindeeError, 'Polling was canceled.' if cancellation_token&.canceled?

          logger.debug(
            "Poll attempt #{try_counter + 1} of #{max_retries}"
          )

          response = @mindee_api.req_get_rag_annotation(product, document_id)
          try_counter += 1

          case response.status
          when 'Processing'
            throttle_polling_attempt(try_counter, max_retries, polling_options, cancellation_token)
          when 'Failed'
            raise Mindee::Error::MindeeError, 'RAG failed without an error payload.'
          else
            return response
          end
        end

        raise Mindee::Error::MindeeError, "RAG polling not complete after #{try_counter} attempts."
      end
    end
  end
end
