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
      def initialize(api_key = nil)
        @settings = ApiSettingsV2.new(api_key: api_key)
      end

      # Sends a file to the inference queue.
      #
      # @param input_source [Input::Source::BaseSource]
      # @param params [Input::InferenceParameters]
      # @return [Mindee::Parsing::V2::JobResponse]
      # @raise [Mindee::Errors::MindeeHttpErrorV2]
      def req_post_inference_enqueue(input_source, params)
        @settings.check_api_key
        response = enqueue(
          input_source,
          params
        )
        Parsing::V2::JobResponse.new(process_response(response))
      end

      # Retrieves a queued inference.
      #
      # @param inference_id [String]
      # @return [Mindee::Parsing::V2::InferenceResponse]
      def req_get_inference(inference_id)
        @settings.check_api_key
        response = inference_result_req_get(
          inference_id
        )
        Parsing::V2::InferenceResponse.new(process_response(response))
      end

      # Retrieves a queued job.
      #
      # @param job_id [String]
      # @return [Mindee::Parsing::V2::JobResponse]
      def req_get_job(job_id)
        @settings.check_api_key
        response = inference_result_req_get(
          job_id
        )
        Parsing::V2::JobResponse.new(process_response(response))
      end

      private

      # Converts an HTTP response to a parsed response object.
      #
      # @param response [Net::HTTP::Response, nil]
      # @return [Hash<String | Symbol, untyped>]
      # @raise Throws if the server returned an error.
      def process_response(response)
        if !response.nil? && response.respond_to?(:body) && ResponseValidation.valid_v2_response?(response)
          return JSON.parse(response.body, object_class: Hash)
        end

        response_body = if response.nil? || !response.respond_to?(:body)
                          { 'status' => -1,
                            'detail' => 'Empty server response.' }
                        else
                          response.body
                        end
        raise ErrorHandler.generate_v2_error(response_body)
      end

      # Polls a queue for either a result or a job.
      # @param url [String] URL, passed as a string.
      # @return [Net::HTTP::Response]
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
      # @return [Net::HTTP::Response]
      def inference_job_req_get(job_id)
        poll("#{@url_root}/jobs/#{job_id}")
      end

      # Polls the API for the result of an inference.
      #
      # @param queue_id [String] ID of the queue.
      # @return [Net::HTTP::Response]
      def inference_result_req_get(queue_id)
        poll("#{@url_root}/inferences/#{queue_id}")
      end

      # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::URLInputSource]
      # @param params [Input::InferenceParameters] Parse options.
      # @return [Net::HTTPResponse, nil]
      def enqueue(input_source, params)
        uri = URI("#{@settings.url_root}/inferences/enqueue")

        req_params = { model_id: params[:model_id] }
        req_params[:rag] = 'true' if params.rag
        req_params[:file_alias] = params.full_text if params.full_text
        req_params[:webhook_ids] = params.webhook_ids.join(',') if params.webhook_ids
        uri.query = URI.encode_www_form(req_params)

        headers = {
          'Authorization' => @settings.api_key,
          'User-Agent' => @settings.user_agent,
        }
        req = Net::HTTP::Post.new(uri, headers)
        form_data = if input_source.is_a?(Mindee::Input::Source::URLInputSource)
                      [['url', input_source.url]] # : Array[untyped]
                    else
                      ['file', input_source.read_contents(close: params.close_file)] # : Array[untyped]
                    end

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
