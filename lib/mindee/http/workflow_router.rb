# frozen_string_literal: true

require 'json'
require 'net/http'
require_relative 'error'

module Mindee
  module HTTP
    # Handles the routing for workflow calls.
    class WorkflowRouter
      # @return [String]
      attr_reader :api_key
      # @return [Integer]
      attr_reader :request_timeout
      # @return [String]
      attr_reader :url

      def initialize(workflow_id, api_key: '')
        @request_timeout = ENV.fetch(REQUEST_TIMEOUT_ENV_NAME, TIMEOUT_DEFAULT).to_i
        @api_key = api_key.nil? || api_key.empty? ? ENV.fetch(API_KEY_ENV_NAME, API_KEY_DEFAULT) : api_key
        base_url = ENV.fetch(BASE_URL_ENV_NAME, BASE_URL_DEFAULT)
        @url = "#{base_url.chomp('/')}/workflows/#{workflow_id}/executions"
      end

      # Sends a document to the workflow.
      # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::UrlInputSource]
      # @param all_words [Boolean] Whether the full word extraction needs to be performed
      # @param full_text [Boolean] Whether to include the full OCR text response in compatible APIs.
      # @param close_file [Boolean] Whether the file will be closed after reading
      # @param cropper [Boolean] Whether a cropping operation will be applied
      # @return [Array]
      def execute_workflow(input_source, all_words, full_text, close_file, cropper)
        check_api_key
        response = workflow_execution_req_post(input_source, all_words, full_text, close_file, cropper)
        hashed_response = JSON.parse(response.body, object_class: Hash)
        return [hashed_response, response.body] if ResponseValidation.valid_async_response?(response)

        ResponseValidation.clean_request!(response)
        error = Error.handle_error(@url_name, response)
        raise error
      end

      # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::UrlInputSource]
      # @param all_words [Boolean] Whether the full word extraction needs to be performed
      # @param full_text [Boolean] Whether to include the full OCR text response in compatible APIs.
      # @param close_file [Boolean] Whether the file will be closed after reading
      # @param cropper [Boolean] Whether a cropping operation will be applied
      # @return [Net::HTTPResponse, nil]
      def workflow_execution_req_post(input_source, all_words, full_text, close_file, cropper)
        uri = URI(@url)
        params = {}
        params[:cropper] = 'true' if cropper
        params[:full_text_ocr] = 'true' if full_text
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

        response = nil
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, read_timeout: @request_timeout) do |http|
          response = http.request(req)
        end
        response
      end

      # Checks API key
      def check_api_key
        return unless @api_key.nil? || @api_key.empty?

        raise "Missing API key. Check your Client Configuration.\n" \
              'You can set this using the ' \
              "'#{HTTP::API_KEY_ENV_NAME}' environment variable."
      end
    end
  end
end
