# frozen_string_literal: true

require 'json'
require 'net/http'
require_relative 'error'

module Mindee
  module HTTP
    # Handles the routing for workflow calls.
    class WorkflowEndpoint
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
      # @param document_alias [String, nil] Alias to give to the document.
      # @param priority [Symbol, nil] Priority to give to the document.
      # @param full_text [Boolean] Whether to include the full OCR text response in compatible APIs.
      # @param public_url [String, nil] A unique, encrypted URL for accessing the document validation interface without
      # requiring authentication.
      # @return [Array]
      def execute_workflow(input_source, full_text, document_alias, priority, public_url)
        check_api_key
        response = workflow_execution_req_post(input_source, document_alias, priority, full_text, public_url)
        hashed_response = JSON.parse(response.body, object_class: Hash)
        return [hashed_response, response.body] if ResponseValidation.valid_async_response?(response)

        ResponseValidation.clean_request!(response)
        error = Error.handle_error(@url_name, response)
        raise error
      end

      # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::UrlInputSource]
      # @param document_alias [String, nil] Alias to give to the document.
      # @param priority [Symbol, nil] Priority to give to the document.
      # @param full_text [Boolean] Whether to include the full OCR text response in compatible APIs.
      # @param public_url [String, nil] A unique, encrypted URL for accessing the document validation interface without
      # requiring authentication.
      # @return [Net::HTTPResponse, nil]
      def workflow_execution_req_post(input_source, document_alias, priority, full_text, public_url)
        uri = URI(@url)
        params = {}
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
                      [input_source.read_document]
                    end
        form_data.push ['alias', document_alias] if document_alias
        form_data.push ['public_url', public_url] if public_url
        form_data.push ['priority', priority.to_s] if priority

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
