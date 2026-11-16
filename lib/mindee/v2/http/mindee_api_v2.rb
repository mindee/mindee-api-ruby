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
        # @param input_source [Input::Source::LocalInputSource, Input::Source::URLInputSource] Local or remote file
        #   as an input.
        # @param params [ClientOptions::BaseProductParameters] Parameters relating to the enqueueing options.
        # @return [Mindee::V2::Parsing::JobResponse]
        # @raise [Mindee::Error::MindeeHttpErrorV2]
        def req_post_product_enqueue(input_source, params)
          @settings.check_api_key
          uri = URI("#{@settings.base_url}/v2/products/#{params.slug}/enqueue")

          form_data = {} # : Hash[String, untyped]
          if input_source.is_a?(Mindee::Input::Source::URLInputSource)
            form_data['url'] = input_source.url
          else
            file_data, file_metadata = input_source.read_contents(close: params.close_file)
            form_data['file'] = [file_data, file_metadata]
          end
          form_data.merge!(params.request_parameters)

          response = send_post_request(uri, form_data)
          Mindee::V2::Parsing::JobResponse.new(process_response(response))
        end

        # Get the result of an inference that was previously enqueued.
        # Raises an error if the server's response contains an error.
        #
        # @param product [Class<Mindee::V2::Product::BaseProduct>]
        # @param inference_id [String] The inference ID for the result.
        # @return [Mindee::V2::Parsing::BaseInferenceResponse]
        def req_get_result_by_id(product, inference_id)
          req_get_result_by_url(product, "#{@settings.base_url}/v2/products/#{product.slug}/results/#{inference_id}")
        end

        # Get the status of an inference that was previously enqueued.
        # Raises an error if the server's response contains an error.
        #
        # @param job_id [String] The Job ID as returned by the enqueue request.
        # @return [Mindee::V2::Parsing::JobResponse]
        def req_get_job_by_id(job_id)
          req_get_job_by_url("#{@settings.base_url}/v2/jobs/#{job_id}")
        end

        # Get the status of an inference that was previously enqueued.
        # Raises an error if the server's response contains an error.
        #
        # @param url [String] The polling URL as returned by a Job's polling_url property.
        # @return [Mindee::V2::Parsing::JobResponse]
        def req_get_job_by_url(url)
          validate_https_url!(url)
          @settings.check_api_key
          response = send_get_request(URI(url))
          Mindee::V2::Parsing::JobResponse.new(process_response(response))
        end

        # Get the result of an inference that was previously enqueued.
        # Raises an error if the server's response contains an error.
        #
        # @param product [Class<Mindee::V2::Product::BaseProduct>]
        # @param url [String] The URL as returned by a Job's result_url property.
        # @return [Mindee::V2::Parsing::BaseInferenceResponse]
        def req_get_result_by_url(product, url)
          validate_https_url!(url)
          @settings.check_api_key
          response = send_get_request(URI(url))
          product.response_class.new(process_response(response))
        end

        # Retrieves a list of resources with the given criteria.
        #
        # @param params [ClientOptions::BaseSearchParameters] Search parameters.
        # @return [Mindee::V2::Parsing::Search::BaseSearchResponse]
        def req_get_search(params)
          @settings.check_api_key
          uri = URI("#{@settings.base_url}/v2/search/#{params.slug}")

          query_params = params.request_parameters
          uri.query = URI.encode_www_form(query_params) unless query_params.empty?

          response = send_get_request(uri)
          params.response_class.new(process_response(response))
        end

        # Get a document's info and annotations from the RAG database.
        #
        # @param product [Class<Mindee::V2::Product::BaseProduct>] The product definition to use.
        # @param document_id [String] The document ID to get.
        # @return [Mindee::V2::Parsing::BaseRagAnnotationResponse]
        def req_get_rag_annotation(product, document_id)
          @settings.check_api_key
          uri = URI("#{@settings.base_url}/v2/products/#{product.slug}/rag-documents/#{document_id}")
          response = send_get_request(uri)
          product.annotation_response_class.new(process_response(response))
        end

        # Add a document to the RAG database.
        #
        # @param product [Class<Mindee::V2::Product::BaseProduct>] The product definition to use.
        # @param parameters [ClientOptions::BaseRagDocumentUploadParameters] The parameters to use.
        # @param input_source [Input::Source::LocalInputSource] The file to upload.
        # @return [Mindee::V2::Parsing::BaseRagAnnotationResponse]
        def req_post_rag_document(product, parameters, input_source)
          @settings.check_api_key
          uri = URI("#{@settings.base_url}/v2/products/#{product.slug}/rag-documents")

          form_data = {} # : Hash[String, untyped]
          file_data, file_metadata = input_source.read_contents
          form_data['file'] = [file_data, file_metadata]
          form_data.merge!(parameters.request_parameters)

          response = send_post_request(uri, form_data)
          product.annotation_response_class.new(process_response(response))
        end

        # Update a document's annotations in the RAG database.
        #
        # @param product [Class<Mindee::V2::Product::BaseProduct>] The product definition to use.
        # @param parameters [ClientOptions::BaseAnnotationParameters] The parameters to use.
        # @return [Mindee::V2::Parsing::BaseRagAnnotationResponse]
        def req_patch_rag_annotation(product, parameters)
          @settings.check_api_key
          uri = URI("#{@settings.base_url}/v2/products/#{product.slug}/rag-documents/#{parameters.document_id}")

          headers = {
            'Authorization' => @settings.api_key,
            'User-Agent' => @settings.user_agent,
            'Content-Type' => 'application/json',
          }
          req = Net::HTTP::Patch.new(uri, headers)
          req.body = parameters.request_parameters.to_json

          response = Net::HTTP.start(uri.hostname, uri.port,
                                     use_ssl: true,
                                     open_timeout: @settings.request_timeout,
                                     read_timeout: @settings.request_timeout) do |http|
            http.request(req)
          end
          product.annotation_response_class.new(process_response(response))
        end

        # Deletes a document from the RAG database.
        #
        # @param product [Class<Mindee::V2::Product::BaseProduct>] The product definition to use.
        # @param document_id [String] The document's ID.
        # @return [Boolean] true if the document was deleted successfully, false otherwise.
        # rubocop:disable-next Naming/PredicateMethod
        def req_delete_rag_document(product, document_id)
          @settings.check_api_key
          uri = URI("#{@settings.base_url}/v2/products/#{product.slug}/rag-documents/#{document_id}")

          headers = {
            'Authorization' => @settings.api_key,
            'User-Agent' => @settings.user_agent,
          }
          req = Net::HTTP::Delete.new(uri, headers)

          response = Net::HTTP.start(uri.hostname, uri.port,
                                     use_ssl: true,
                                     open_timeout: @settings.request_timeout,
                                     read_timeout: @settings.request_timeout) do |http|
            http.request(req)
          end
          !response.nil? && response.respond_to?(:code) && response.code.to_i >= 200 && response.code.to_i < 400
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

        # Send a GET request.
        # @param uri [URI::Generic] URL, passed as a URI instance or String.
        # @return [Net::HTTPResponse]
        def send_get_request(uri)
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

        # Send a POST request.
        # @param uri [URI::Generic] URL, passed as a URI instance or String.
        # @param form_data [Hash[String, untyped]] Form data to send.
        # @return [Net::HTTPResponse]
        def send_post_request(uri, form_data)
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
      end
    end
  end
end
