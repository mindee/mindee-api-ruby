# frozen_string_literal: true

require 'net/http'
require_relative '../version'

module Mindee
  module HTTP
    API_KEY_ENV_NAME = 'MINDEE_API_KEY'
    API_KEY_DEFAULT = nil

    BASE_URL_ENV_NAME = 'MINDEE_BASE_URL'
    BASE_URL_DEFAULT = 'https://api.mindee.net/v1'

    REQUEST_TIMEOUT_ENV_NAME = 'MINDEE_REQUEST_TIMEOUT'
    TIMEOUT_DEFAULT = 120

    USER_AGENT = "mindee-api-ruby@v#{Mindee::VERSION} ruby-v#{RUBY_VERSION} #{Mindee::PLATFORM}"

    # Generic API endpoint for a product.
    class Endpoint
      # @return [String]
      attr_reader :api_key
      # @return [Integer]
      attr_reader :request_timeout

      def initialize(owner, url_name, version, api_key: '')
        @owner = owner
        @url_name = url_name
        @version = version
        @request_timeout = ENV.fetch(REQUEST_TIMEOUT_ENV_NAME, TIMEOUT_DEFAULT).to_i
        @api_key = api_key.nil? || api_key.empty? ? ENV.fetch(API_KEY_ENV_NAME, API_KEY_DEFAULT) : api_key
        @url_root = "#{BASE_URL_DEFAULT}/products/#{@owner}/#{@url_name}/v#{@version}"
      end

      # @param input_source [Mindee::Input::LocalInputSource, Mindee::Input::UrlInputSource]
      # @param all_words [Boolean]
      # @param close_file [Boolean]
      # @param cropper [Boolean]
      # @return [Net::HTTPResponse]
      def predict_req_post(input_source, all_words: false, close_file: true, cropper: false)
        uri = URI("#{@url_root}/predict")

        params = {}
        params[:cropper] = 'true' if cropper
        uri.query = URI.encode_www_form(params)

        headers = {
          'Authorization' => "Token #{@api_key}",
          'User-Agent' => USER_AGENT,
        }
        req = Net::HTTP::Post.new(uri, headers)
        form_data = if input_source.is_a?(Mindee::Input::UrlInputSource)
                      {
                        'document' => input_source.url,
                      }
                    else
                      {
                        'document' => input_source.read_document(close: close_file),
                      }
                    end
        form_data.push ['include_mvision', 'true'] if all_words

        req.set_form(form_data, 'multipart/form-data')

        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, read_timeout: @request_timeout) do |http|
          http.request(req)
        end
      end

      # @param input_source [Mindee::Input::LocalInputSource, Mindee::Input::UrlInputSource]
      # @param all_words [Boolean]
      # @param close_file [Boolean]
      # @param cropper [Boolean]
      # @return [Net::HTTPResponse]
      def predict_async_req_post(input_source, all_words, close_file, cropper)
        uri = URI("#{@url_root}/predict_async")

        params = {}
        params[:cropper] = 'true' if cropper
        uri.query = URI.encode_www_form(params)

        headers = {
          'Authorization' => "Token #{@api_key}",
          'User-Agent' => USER_AGENT,
        }
        req = Net::HTTP::Post.new(uri, headers)
        form_data = if input_source.is_a?(Mindee::Input::UrlInputSource)
                      {
                        'document' => input_source.url,
                      }
                    else
                      {
                        'document' => input_source.read_document(close: close_file),
                      }
                    end
        form_data.push ['include_mvision', 'true'] if all_words

        req.set_form(form_data, 'multipart/form-data')

        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, read_timeout: @request_timeout) do |http|
          http.request(req)
        end
      end

      # @param job_id [String]
      # @return [Net::HTTPResponse]
      def document_queue_req_get(job_id)
        uri = URI("#{@url_root}/documents/queue/#{job_id}")

        headers = {
          'Authorization' => "Token #{@api_key}",
          'User-Agent' => USER_AGENT,
        }

        req = Net::HTTP::Get.new(uri, headers)

        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, read_timeout: @request_timeout) do |http|
          http.request(req)
        end

        if response.code.to_i > 299 && response.code.to_i < 400
          req = Net::HTTP::Get.new(response['location'], headers)
          response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, read_timeout: @request_timeout) do |http|
            http.request(req)
          end
        end
        response
      end
    end

    # Custom (constructed) API endpoint
    class CustomEndpoint < Endpoint
      def initialize(account_name, endpoint_name, version, api_key)
        super(account_name, endpoint_name, version, api_key: api_key)
      end
    end
  end
end
