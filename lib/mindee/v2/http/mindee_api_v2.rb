# frozen_string_literal: true

require_relative '../../input'
require_relative '../../http'
require_relative '../../error'

module Mindee
  module V2
    module HTTP
      # API client for version 2.
      class MindeeApiV2
        # @return [ApiV2Settings]
        attr_reader :settings

        # @param api_key [String, nil]
        def initialize(api_key: nil)
          @settings = ApiV2Settings.new(api_key: api_key)
        end

        # Send a file to the asynchronous processing queue for inference processing.
        #
        # @param input_source [Input::Source::LocalInputSource, Input::Source::URLInputSource]
        # @param params [ClientOptions::BaseProductParameters]
        # @return [Mindee::V2::Parsing::JobResponse]
        # @raise [Mindee::Error::MindeeHttpErrorV2]
        def req_post_product_enqueue(input_source, params)
          @settings.check_api_key
          response = enqueue(
            input_source,
            params
          )
          Mindee::V2::Parsing::JobResponse.new(process_response(response))
        end

        # Retrieves a result from a given queue.
        # @param product [Class<Mindee::V2::Product::BaseProduct>]
        # @param inference_id [String] ID of the inference or URL to the result.
        # @return [Mindee::V2::Parsing::BaseResponse]
        def req_get_result_by_id(product, inference_id)
          req_get_result_by_url(product, "#{@settings.base_url}/v2/products/#{product.slug}/results/#{inference_id}")
        end

        # Retrieves a queued job.
        #
        # @param job_id [String] ID of the job or URL to the job.
        # @return [Mindee::V2::Parsing::JobResponse]
        def req_get_job_by_id(job_id)
          req_get_job_by_url("#{@settings.base_url}/v2/jobs/#{job_id}")
        end

        # Retrieves a queued job from its polling URL.
        #
        # @param url [String] HTTPS URL to the job.
        # @return [Mindee::V2::Parsing::JobResponse]
        def req_get_job_by_url(url)
          validate_https_url!(url)
          @settings.check_api_key
          response = poll(url)
          Mindee::V2::Parsing::JobResponse.new(process_response(response))
        end

        # Retrieves a result from its URL.
        #
        # @param product [Class<Mindee::V2::Product::BaseProduct>]
        # @param url [String] HTTPS URL to the result.
        # @return [Mindee::V2::Parsing::BaseResponse]
        def req_get_result_by_url(product, url)
          validate_https_url!(url)
          @settings.check_api_key
          response = poll(url)
          product.response_type.new(process_response(response))
        end

        # Retrieves a list of resources with the given criteria.
        # @param params [ClientOptions::BaseSearchParameters] Search parameters.
        # @return [Mindee::V2::Parsing::Search::BaseSearchResponse] A search response containing the matching
        #   resources.
        def req_get_search(params)
          @settings.check_api_key
          uri = URI("#{@settings.base_url}/v2/search/#{params.slug}")

          query_params = params.request_parameters
          uri.query = URI.encode_www_form(query_params) unless query_params.empty?

          headers = {
            'Authorization' => @settings.api_key,
            'User-Agent' => @settings.user_agent,
          }
          req = Net::HTTP::Get.new(uri, headers)

          response = Net::HTTP.start(uri.hostname, uri.port,
                                     use_ssl: true,
                                     open_timeout: @settings.request_timeout,
                                     read_timeout: @settings.request_timeout) do |http|
            http.request(req)
          end
          params.response_class.new(process_response(response))
        end

        private

        # Validates that a URL uses HTTPS and includes a host.
        #
        # @param url [String]
        # @return [void]
        def validate_https_url!(url)
          uri = URI.parse(url)
          raise Mindee::Error::MindeeError, "Invalid URL: #{url}" unless uri.scheme == 'https' && !uri.host.to_s.empty?
        rescue URI::BadURIError, URI::InvalidURIError
          raise Mindee::Error::MindeeError, "Invalid URL: #{url}"
        end

        # Converts an HTTP response to a parsed response object.
        #
        # @param response [Net::HTTPResponse, nil]
        # @return [Hash]
        # @raise Throws if the server returned an error.
        def process_response(response)
          if !response.nil? && response.respond_to?(:body) &&
             Mindee::HTTP::ResponseValidation.valid_v2_response?(response)
            return JSON.parse(response.body, object_class: Hash)
          end

          response_body = if response.nil? || !response.respond_to?(:body)
                            '{ "status": -1,
                            "detail": "Empty server response." }'
                          else
                            response.body
                          end
          raise Mindee::HTTP::ErrorHandler.generate_v2_error(JSON.parse(response_body).transform_keys(&:to_sym))
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

          Net::HTTP.start(uri.hostname, uri.port,
                          use_ssl: true,
                          open_timeout: @settings.request_timeout,
                          read_timeout: @settings.request_timeout) do |http|
            return http.request(req)
          end
          raise Mindee::Error::MindeeError, 'Could not resolve server response.'
        end

        # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::URLInputSource]
        # @param params [ClientOptions::BaseProductParameters] Inference options.
        # @return [Net::HTTPResponse, nil]
        def enqueue(input_source, params)
          uri = URI("#{@settings.base_url}/v2/products/#{params.slug}/enqueue")

          form_data = {} # : Hash[String, untyped]
          if input_source.is_a?(Mindee::Input::Source::URLInputSource)
            form_data['url'] = input_source.url
          else
            file_data, file_metadata = input_source.read_contents(close: params.close_file)
            form_data['file'] = [file_data, file_metadata]
          end
          form_data.merge!(params.request_parameters)

          # Convert hash to the array format required by Net::HTTP multipart
          form_data_list = form_data.map do |k, v|
            v.is_a?(Array) ? [k.to_s, *v] : [k.to_s, v]
          end

          headers = {
            'Authorization' => @settings.api_key,
            'User-Agent' => @settings.user_agent,
          }
          req = Net::HTTP::Post.new(uri, headers)

          req.set_form(form_data_list, 'multipart/form-data')
          req['Transfer-Encoding'] = 'chunked'

          Net::HTTP.start(uri.hostname, uri.port,
                          use_ssl: true,
                          open_timeout: @settings.request_timeout,
                          read_timeout: @settings.request_timeout) do |http|
            return http.request(req)
          end
          raise Mindee::Error::MindeeError, 'Could not resolve server response.'
        end
      end
    end
  end
end
