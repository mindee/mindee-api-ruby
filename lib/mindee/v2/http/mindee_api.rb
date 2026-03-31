# frozen_string_literal: true

require_relative '../../input'
require_relative '../../http'
require_relative '../../errors'

module Mindee
  module V2
    module HTTP
      # API client for version 2.
      class MindeeApi
        # @return [ApiSettings]
        attr_reader :settings

        # @param api_key [String, nil]
        def initialize(api_key: nil)
          @settings = ApiSettings.new(api_key: api_key)
        end

        # Sends a file to the queue.
        #
        # @param input_source [Input::Source::LocalInputSource, Input::Source::URLInputSource]
        # @param params [Input::BaseParameters]
        # @return [Mindee::V2::Parsing::JobResponse]
        # @raise [Mindee::Errors::MindeeHttpErrorV2]
        def req_post_enqueue(input_source, params)
          @settings.check_api_key
          response = enqueue(
            input_source,
            params
          )
          Mindee::V2::Parsing::JobResponse.new(process_response(response))
        end

        # Retrieves a result from a given queue.
        # @param product [Class<Mindee::V2::Product::BaseProduct>] The return class.
        # @param resource [String] ID of the inference or URL to the result.
        # @return [Mindee::V2::Parsing::BaseResponse]
        def req_get_result(product, resource)
          return req_get_result_url(product.response_type, resource) if uri?(resource)

          @settings.check_api_key
          response = result_req_get(
            resource,
            product
          )
          product.response_type.new(process_response(response))
        end

        # Retrieves a queued job.
        #
        # @param job_id [String] ID of the job or URL to the job.
        # @return [Mindee::V2::Parsing::JobResponse]
        def req_get_job(job_id)
          @settings.check_api_key
          response = poll("#{@settings.base_url}/v2/jobs/#{job_id}")
          Mindee::V2::Parsing::JobResponse.new(process_response(response))
        end

        # Retrieves a list of models.
        # @param model_name [String, nil]
        # @param model_type [String, nil]
        # @return [Mindee::V2::Parsing::Search::SearchResponse]
        def search_models(model_name, model_type)
          Mindee::V2::Parsing::Search::SearchResponse.new(process_response(req_get_search_models(model_name,
                                                                                                 model_type)))
        end

        private

        # Retrieves a list of models.
        # @param model_name [String, nil]
        # @param model_type [String, nil]
        # @return [Net::HTTPResponse]
        def req_get_search_models(model_name, model_type)
          url = "#{@settings.base_url}/v2/search/models"
          uri = URI(url)

          query_params = {}
          query_params[:name] = model_name if model_name
          query_params[:model_type] = model_type if model_type
          uri.query = URI.encode_www_form(query_params) unless query_params.empty?

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

        # @param resource [String] Resource to check.
        # @return [Boolean]
        def uri?(resource)
          uri = URI.parse(resource)
          throw Mindee::Errors::MindeeError, 'HTTP is not supported.' if uri.scheme == 'http'
          uri.scheme == 'https'
        rescue URI::BadURIError, URI::InvalidURIError
          false
        end

        # Retrieves a queued job.
        #
        # @param url [String]
        # @return [Mindee::V2::Parsing::JobResponse]
        def req_get_job_url(url)
          @settings.check_api_key
          response = poll(url)
          Mindee::V2::Parsing::JobResponse.new(process_response(response))
        end

        # Retrieves a queued job.
        #
        # @param result_class [Class<Mindee::V2::Parsing::BaseResponse>]
        # @param url [String]
        # @return [Mindee::V2::Parsing::BaseResponse]
        def req_get_result_url(result_class, url)
          @settings.check_api_key
          response = poll(url)
          result_class.new(process_response(response))
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
          req['Transfer-Encoding'] = 'chunked'

          Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, read_timeout: @settings.request_timeout) do |http|
            return http.request(req)
          end
          raise Mindee::Errors::MindeeError, 'Could not resolve server response.'
        end

        # Polls the API for the result of an inference.
        #
        # @param queue_id [String] ID of the queue.
        # @param product [Class<Mindee::V2::Product::BaseProduct>] The return class.
        # @return [Net::HTTPResponse]
        def result_req_get(queue_id, product)
          poll("#{@settings.base_url}/v2/products/#{product.slug}/results/#{queue_id}")
        end

        # Handle parameters for the enqueue form
        # @param form_data [Array] Array of form fields
        # @param params [V2::Product::Extraction::Params::ExtractionParameters] Inference options.
        def enqueue_form_options(form_data, params)
          form_data.push(['rag', params.rag.to_s]) unless params.rag.nil?
          form_data.push(['raw_text', params.raw_text.to_s]) unless params.raw_text.nil?
          form_data.push(['polygon', params.polygon.to_s]) unless params.polygon.nil?
          form_data.push(['confidence', params.confidence.to_s]) unless params.confidence.nil?
          form_data.push ['text_context', params.text_context] if params.text_context
          form_data.push ['data_schema', params.data_schema.to_s] if params.data_schema
          unless params.webhook_ids.nil? || params.webhook_ids.empty?
            params.webhook_ids.each do |webhook_id|
              form_data.push ['webhook_ids[]', webhook_id]
            end
          end
          form_data
        end

        # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::URLInputSource]
        # @param params [Input::BaseParameters] Inference options.
        # @return [Net::HTTPResponse, nil]
        def enqueue(input_source, params)
          uri = URI("#{@settings.base_url}/v2/products/#{params.slug}/enqueue")

          form_data = if input_source.is_a?(Mindee::Input::Source::URLInputSource)
                        [['url', input_source.url]] # : Array[Array[untyped]]
                      else
                        file_data, file_metadata = input_source.read_contents(close: params.close_file)
                        [['file', file_data, file_metadata]] # : Array[Array[untyped]]
                      end
          form_data.push(['model_id', params.model_id])
          form_data.push ['file_alias', params.file_alias] if params.file_alias
          if params.is_a?(V2::Product::Extraction::Params::ExtractionParameters)
            form_data = enqueue_form_options(form_data, params)
          end

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
end
