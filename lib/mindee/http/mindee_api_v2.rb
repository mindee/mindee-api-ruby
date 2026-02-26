# frozen_string_literal: true

require_relative 'api_settings_v2'
require_relative '../input'
require_relative '../errors'
require_relative '../parsing/v2'

module Mindee
  module HTTP
    # API client for version 2.
    class MindeeApiV2
      # @return [ApiSettingsV2]
      attr_reader :settings

      # @param api_key [String, nil]
      def initialize(api_key: nil)
        @settings = ApiSettingsV2.new(api_key: api_key)
      end

      # Sends a file to the inference queue.
      #
      # @param input_source [Input::Source::LocalInputSource, Input::Source::URLInputSource]
      # @param params [Input::InferenceParameters]
      # @return [Mindee::Parsing::V2::JobResponse]
      # @raise [Mindee::Errors::MindeeHttpErrorV2]
      def req_post_enqueue(input_source, params)
        @settings.check_api_key
        response = enqueue(
          input_source,
          params
        )
        Mindee::Parsing::V2::JobResponse.new(process_response(response))
      end

      # Retrieves a queued inference.
      #
      # @param inference_id [String]
      # @return [Mindee::Parsing::V2::InferenceResponse]
      def req_get_inference(inference_id)
        req_get_result(Mindee::Parsing::V2::InferenceResponse, inference_id)
      end

      # Retrieves a result from a given queue.
      # @param response_class [Class<Mindee::Parsing::V2::BaseResponse>]
      # @param resource [String] ID of the inference or URL to the result.
      # @return [Mindee::Parsing::V2::BaseResponse]
      def req_get_result(response_class, resource)
        return req_get_result_url(response_class, resource) if uri?(resource)

        @settings.check_api_key
        response = result_req_get(
          resource,
          response_class
        )
        response_class.new(process_response(response))
      end

      # Retrieves a queued job.
      #
      # @param resource [String] ID of the job or URL to the job.
      # @return [Mindee::Parsing::V2::JobResponse]
      def req_get_job(resource)
        return req_get_job_url(resource) if uri?(resource)

        @settings.check_api_key
        response = inference_job_req_get(
          resource
        )
        Mindee::Parsing::V2::JobResponse.new(process_response(response))
      end

      private

      # Retrieves a queued job.
      #
      # @param result_class [Mindee::V2::Parsing::BaseResponse]
      # @param url [String]
      # @return [Mindee::Parsing::V2::JobResponse]
      def req_get_result_url(result_class, url)
        @settings.check_api_key
        response = poll(url)
        result_class.new(process_response(response))
      end

      # @param resource [String] Resource to check.
      # @return [Boolean]
      def uri?(resource)
        uri = URI.parse(resource)
        throw Mindee::Errors::MindeeError, 'HTTP is not supported.' if uri.scheme == 'http'
        uri.scheme == 'https'
      rescue URI::BadURIError, URI::InvalidURIError
        false
      end

      # Converts an HTTP response to a parsed response object.
      #
      # @param response [Net::HTTPResponse, nil]
      # @return [Hash]
      # @raise Throws if the server returned an error.
      def process_response(response)
        if !response.nil? && response.respond_to?(:body) && ResponseValidation.valid_v2_response?(response)
          return JSON.parse(response.body, object_class: Hash)
        end

        response_body = if response.nil? || !response.respond_to?(:body)
                          '{ "status": -1,
                            "detail": "Empty server response." }'
                        else
                          response.body
                        end
        raise ErrorHandler.generate_v2_error(JSON.parse(response_body).transform_keys(&:to_sym))
      end

      # Polls a queue for either a result or a job.
      # @param url [String] URL, passed as a string.
      # @return [Net::HTTPResponse]
      def poll(url)
        uri = URI(url)
        headers = {
          'Authorization' => @settings.api_key,
          'User-Agent' => @settings.user_agent,
        }
        req = Net::HTTP::Get.new(uri, headers)
        req['Transfer-Encoding'] = 'chunked'

        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, read_timeout: @settings.request_timeout) do |http|
          return http.request(req)
        end
        raise Mindee::Errors::MindeeError, 'Could not resolve server response.'
      end

      # Polls the API for the status of a job.
      #
      # @param job_id [String] ID of the job.
      # @return [Net::HTTPResponse]
      def inference_job_req_get(job_id)
        poll("#{@settings.base_url}/jobs/#{job_id}")
      end

      # Polls the API for the result of an inference.
      #
      # @param queue_id [String] ID of the queue.
      # @return [Net::HTTPResponse]
      def inference_result_req_get(queue_id)
        poll("#{@settings.base_url}/inferences/#{queue_id}")
      end

      # Polls the API for the result of an inference.
      #
      # @param queue_id [String] ID of the queue.
      # @param response_class [Class<Mindee::Parsing::V2::BaseResponse>]
      # @return [Net::HTTPResponse]
      def result_req_get(queue_id, response_class)
        poll("#{@settings.base_url}/products/#{response_class._slug}/results/#{queue_id}")
      end

      # Handle parameters for the enqueue form
      # @param form_data [Array] Array of form fields
      # @param params [Input::InferenceParameters] Inference options.
      def enqueue_form_options(form_data, params)
        # deal with optional features
        form_data.push(['rag', params.rag.to_s]) unless params.rag.nil?
        form_data.push(['raw_text', params.raw_text.to_s]) unless params.raw_text.nil?
        form_data.push(['polygon', params.polygon.to_s]) unless params.polygon.nil?
        form_data.push(['confidence', params.confidence.to_s]) unless params.confidence.nil?
        form_data.push ['file_alias', params.file_alias] if params.file_alias
        form_data.push ['text_context', params.text_context] if params.text_context
        form_data.push ['data_schema', params.data_schema.to_s] if params.data_schema
        unless params.webhook_ids.nil? || params.webhook_ids.empty?
          form_data.push ['webhook_ids', params.webhook_ids.join(',')]
        end
        form_data
      end

      # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::URLInputSource]
      # @param params [Input::BaseParameters] Inference options.
      # @return [Net::HTTPResponse, nil]
      def enqueue(input_source, params)
        uri = URI("#{@settings.base_url}/products/#{params._slug}/enqueue")

        form_data = if input_source.is_a?(Mindee::Input::Source::URLInputSource)
                      [['url', input_source.url]] # : Array[untyped]
                    else
                      file_data, file_metadata = input_source.read_contents(close: params.close_file)
                      [['file', file_data, file_metadata]] # : Array[untyped]
                    end
        form_data.push(['model_id', params.model_id])

        form_data = params.append_form_data(form_data)

        headers = {
          'Authorization' => @settings.api_key,
          'User-Agent' => @settings.user_agent,
        }
        req = Net::HTTP::Post.new(uri, headers)

        req.set_form(form_data, 'multipart/form-data')
        req['Transfer-Encoding'] = 'chunked'

        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, read_timeout: @settings.request_timeout) do |http|
          return http.request(req)
        end
        raise Mindee::Errors::MindeeError, 'Could not resolve server response.'
      end
    end
  end
end
