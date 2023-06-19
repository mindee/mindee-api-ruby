# frozen_string_literal: true

require 'json'
require_relative 'http/endpoint'
require_relative 'parsing/common/document'
require_relative 'parsing/common/error'
require_relative 'product'

module Mindee
  # Specific client for sending a document to the API.
  class DocumentConfig
    # Array of possible Mindee::Endpoint to be used.
    # @return [Mindee::HTTP::Endpoint]
    attr_reader :endpoint

    # @param product_class [Class<Mindee::Product>]
    # @param endpoint [Mindee::HTTP::Endpoint]
    def initialize(product_class, endpoint)
      @product_class = product_class
      @endpoint = endpoint
    end

    # Call the prediction API.
    # @param input_source [Mindee::Input::LocalInputSource, Mindee::Input::UrlInputSource]
    # @param all_words [Boolean]
    # @param close_file [Boolean]
    # @param cropper [Boolean]
    # @return [Hash]
    def predict(input_source, all_words, close_file, cropper)
      check_api_key
      response = predict_request(input_source, all_words, close_file, cropper)
      hashed_response = JSON.parse(response.body, object_class: Hash)
      return hashed_response if (200..299).include?(response.code.to_i)

      error = Parsing::Common::Error.new(hashed_response['api_request']['error'])
      raise error
    end

    # Call the prediction API.
    # @param input_source [Mindee::Input::LocalInputSource, Mindee::Input::UrlInputSource]
    # @param close_file [Boolean]
    # @param cropper [Boolean]
    # @return [Hash]
    def predict_async(input_source, all_words, close_file, cropper)
      check_api_key
      response = predict_async_request(input_source, all_words, close_file, cropper)
      hashed_response = JSON.parse(response.body, object_class: Hash)
      return hashed_response if (200..299).include?(response.code.to_i)

      error = Parsing::Common::Error.new(hashed_response['api_request']['error'])
      raise error
    end

    # Calls the parsed async doc.
    # @param job_id [String]
    # @return [Hash]
    def parse_async(job_id)
      check_api_key
      response = document_queue_request(job_id)
      hashed_response = JSON.parse(response.body, object_class: Hash)
      return hashed_response if (200..299).include?(response.code.to_i)

      error = Parsing::Common::Error.new(hashed_response['api_request']['error'])
      raise error
    end

    private

    # @param input_source [Mindee::Input::LocalInputSource, Mindee::Input::UrlInputSource]
    # @param all_words [Boolean]
    # @param close_file [Boolean]
    # @param cropper [Boolean]
    # @return [Net::HTTPResponse]
    def predict_request(input_source, all_words, close_file, cropper)
      @endpoint.predict_req_post(input_source, all_words: all_words, close_file: close_file, cropper: cropper)
    end

    # @param input_source [Mindee::Input::LocalInputSource, Mindee::Input::UrlInputSource]
    # @param all_words [Boolean]
    # @param close_file [Boolean]
    # @param cropper [Boolean]
    # @return [Net::HTTPResponse]
    def predict_async_request(input_source, all_words, close_file, cropper)
      @endpoint.predict_async_req_post(input_source, all_words, close_file, cropper)
    end

    # @param job_id [String]
    # @return [Net::HTTPResponse]
    def document_queue_request(job_id)
      @endpoint.document_queue_req_get(job_id)
    end

    def check_api_key
      return unless @endpoint.api_key.nil? || @endpoint.api_key.empty?

      raise "Missing API key for '#{@document_type}', " \
            "check your Client Configuration.\n" \
            'You can set this using the ' \
            "'#{HTTP::API_KEY_ENV_NAME}' environment variable."
    end
  end
end
