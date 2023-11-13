# frozen_string_literal: true

require 'json'
require 'net/http'
require_relative 'error'
require_relative '../version'

module Mindee
  module HTTP
    # API key's default environment key name.
    API_KEY_ENV_NAME = 'MINDEE_API_KEY'
    # API key's default value.
    API_KEY_DEFAULT = nil

    # Base URL default environment key name.
    BASE_URL_ENV_NAME = 'MINDEE_BASE_URL'
    # Base URL's default value.
    BASE_URL_DEFAULT = 'https://api.mindee.net/v1'

    # HTTP request timeout default environment key name.
    REQUEST_TIMEOUT_ENV_NAME = 'MINDEE_REQUEST_TIMEOUT'
    # HTTP request timeout default value.
    TIMEOUT_DEFAULT = 120

    # Default value for the user agent.
    USER_AGENT = "mindee-api-ruby@v#{Mindee::VERSION} ruby-v#{RUBY_VERSION} #{Mindee::PLATFORM}"

    # Generic API endpoint for a product.
    class Endpoint
      # @return [String]
      attr_reader :api_key
      # @return [Integer]
      attr_reader :request_timeout
      # @return [String]
      attr_reader :url_root

      def initialize(owner, url_name, version, api_key: '')
        @owner = owner
        @url_name = url_name
        @version = version
        @request_timeout = ENV.fetch(REQUEST_TIMEOUT_ENV_NAME, TIMEOUT_DEFAULT).to_i
        @api_key = api_key.nil? || api_key.empty? ? ENV.fetch(API_KEY_ENV_NAME, API_KEY_DEFAULT) : api_key
        update_url_root(BASE_URL_DEFAULT)
      end

      # Call the prediction API.
      # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::UrlInputSource]
      # @param all_words [Boolean]
      # @param close_file [Boolean]
      # @param cropper [Boolean]
      # @return [Hash]
      def predict(input_source, all_words, close_file, cropper)
        check_api_key
        response = predict_req_post(input_source, all_words: all_words, close_file: close_file, cropper: cropper)
        hashed_response = JSON.parse(response.body, object_class: Hash)
        return [hashed_response, response.body] if (200..299).include?(response.code.to_i)

        error = Error.handle_error!(@url_name, hashed_response, response.code.to_i)
        raise error
      end

      # Call the prediction API.
      # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::UrlInputSource]
      # @param close_file [Boolean]
      # @param cropper [Boolean]
      # @return [Hash]
      def predict_async(input_source, all_words, close_file, cropper)
        check_api_key
        response = document_queue_req_get(input_source, all_words, close_file, cropper)
        hashed_response = JSON.parse(response.body, object_class: Hash)
        return [hashed_response, response.body] if (200..299).include?(response.code.to_i)

        error = Error.handle_error!(@url_name, hashed_response, response.code.to_i)
        raise error
      end

      # Calls the parsed async doc.
      # @param job_id [String]
      # @return [Hash]
      def parse_async(job_id)
        check_api_key
        response = document_queue_req(job_id)
        hashed_response = JSON.parse(response.body, object_class: Hash)
        return [hashed_response, response.body] if (200..299).include?(response.code.to_i)

        error = Error.handle_error!(@url_name, hashed_response, response.code.to_i)
        raise error
      end

      # Sets a custom value for the API, only used in testing
      # @param base_url [String]
      def update_url_root(base_url = '')
        env_value = ENV.fetch(BASE_URL_ENV_NAME, BASE_URL_DEFAULT)
        base_url = env_value unless !base_url.empty? && !base_url.nil?
        @url_root = "#{base_url.chomp('/')}/products/#{@owner}/#{@url_name}/v#{@version}"
      end

      private

      # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::UrlInputSource]
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
        form_data = if input_source.is_a?(Mindee::Input::Source::UrlInputSource)
                      [['document', input_source.url]]
                    else
                      [input_source.read_document(close: close_file)]
                    end
        form_data.push ['include_mvision', 'true'] if all_words

        req.set_form(form_data, 'multipart/form-data')

        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, read_timeout: @request_timeout) do |http|
          http.request(req)
        end
      end

      # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::UrlInputSource]
      # @param all_words [Boolean]
      # @param close_file [Boolean]
      # @param cropper [Boolean]
      # @return [Net::HTTPResponse]
      def document_queue_req_get(input_source, all_words, close_file, cropper)
        uri = URI("#{@url_root}/predict_async")

        params = {}
        params[:cropper] = 'true' if cropper
        uri.query = URI.encode_www_form(params)

        headers = {
          'Authorization' => "Token #{@api_key}",
          'User-Agent' => USER_AGENT,
        }
        req = Net::HTTP::Post.new(uri, headers)
        form_data = if input_source.is_a?(Mindee::Input::Source::UrlInputSource)
                      [['document', input_source.url]]
                    else
                      [input_source.read_document(close: close_file)]
                    end
        form_data.push ['include_mvision', 'true'] if all_words

        req.set_form(form_data, 'multipart/form-data')

        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, read_timeout: @request_timeout) do |http|
          http.request(req)
        end
      end

      # @param job_id [String]
      # @return [Net::HTTPResponse]
      def document_queue_req(job_id)
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

      # Checks API key
      def check_api_key
        return unless @api_key.nil? || @api_key.empty?

        raise "Missing API key for product \"'#{@url_name}' v#{@version}\" (belonging to \"#{@owner}\"), " \
              "check your Client Configuration.\n" \
              'You can set this using the ' \
              "'#{HTTP::API_KEY_ENV_NAME}' environment variable."
      end
    end
  end
end
