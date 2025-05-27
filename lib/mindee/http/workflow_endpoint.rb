# frozen_string_literal: true

require 'json'
require 'net/http'
require_relative 'http_error_handler'

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
      # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::URLInputSource]
      # @param opts [WorkflowOptions] Options to configure workflow execution behavior.
      # @return [Array]
      def execute_workflow(input_source, opts)
        check_api_key
        response = workflow_execution_req_post(input_source, opts)
        if response.nil?
          raise Mindee::Errors::MindeeHTTPError.new(
            { code: 0, details: 'Server response was nil.', message: 'Unknown error.' }, @url, 0
          )
        end

        hashed_response = JSON.parse(response.body, object_class: Hash)
        return [hashed_response, response.body] if ResponseValidation.valid_async_response?(response)

        ResponseValidation.clean_request!(response)
        error = Mindee::HTTP::ErrorHandler.handle_error(@url_name, response)
        raise error
      end

      # @param input_source [Mindee::Input::Source::LocalInputSource, Mindee::Input::Source::URLInputSource]
      # @param opts [WorkflowOptions] Options to configure workflow execution behavior.
      # @return [Net::HTTPResponse, nil]
      def workflow_execution_req_post(input_source, opts)
        uri = URI(@url)
        params = {} # : Hash[Symbol | String, untyped]
        params[:full_text_ocr] = 'true' if opts.full_text
        params[:rag] = 'true' if opts.rag
        uri.query = URI.encode_www_form(params) if params.any?

        headers = {
          'Authorization' => "Token #{@api_key}",
          'User-Agent' => USER_AGENT,
        }
        req = Net::HTTP::Post.new(uri, headers)
        form_data = [] # : Array[untyped]
        if input_source.is_a?(Mindee::Input::Source::URLInputSource)
          form_data.push ['document', input_source.url]
        else
          form_data.push input_source.read_contents
        end
        form_data.push ['alias', opts.document_alias] if opts.document_alias
        form_data.push ['public_url', opts.public_url] if opts.public_url
        form_data.push ['priority', opts.priority.to_s] if opts.priority

        req.set_form(form_data, 'multipart/form-data')
        req['Transfer-Encoding'] = 'chunked'

        response = nil
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, read_timeout: @request_timeout) do |http|
          response = http.request(req)
        end
        response
      end

      # Checks API key
      def check_api_key
        return unless @api_key.nil? || @api_key.empty?

        raise Errors::MindeeConfigurationError, "Missing API key. Check your Client Configuration.\n" \
                                                "You can set this using the '#{HTTP::API_KEY_ENV_NAME}'" \
                                                'environment variable.'
      end
    end
  end
end
