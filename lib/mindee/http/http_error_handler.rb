# frozen_string_literal: true

require 'json'
require_relative '../errors/mindee_http_error'

module Mindee
  module HTTP
    # Mindee HTTP error module.
    module ErrorHandler
      module_function

      # Extracts the HTTP error from the response hash, or the job error if there is one.
      # @param response [Hash] dictionary response retrieved by the server
      def extract_error(response)
        return unless response.respond_to?(:each_pair)

        if !response.dig('api_request', 'error').empty?
          response.dig('api_request', 'error')
        elsif !response.dig('job', 'error').empty?
          response.dig('job', 'error')
        end
      end

      # Creates an error object based on what's retrieved from a request.
      # @param response [Hash] dictionary response retrieved by the server
      def create_error_obj(response)
        error_obj = extract_error(response)
        if error_obj.nil?
          error_obj = if response.include?('Maximum pdf pages')
                        {
                          'code' => 'TooManyPages',
                          'message' => 'Maximum amound of pdf pages reached.',
                          'details' => response,
                        }
                      elsif response.include?('Max file size is')
                        {
                          'code' => 'FileTooLarge',
                          'message' => 'Maximum file size reached.',
                          'details' => response,
                        }
                      elsif response.include?('Invalid file type')
                        {
                          'code' => 'InvalidFiletype',
                          'message' => 'Invalid file type.',
                          'details' => response,
                        }
                      elsif response.include?('Gateway timeout')
                        {
                          'code' => 'RequestTimeout',
                          'message' => 'Request timed out.',
                          'details' => response,
                        }
                      elsif response.include?('Too Many Requests')
                        {
                          'code' => 'TooManyRequests',
                          'message' => 'Too Many Requests.',
                          'details' => response,
                        }
                      else
                        {
                          'code' => 'UnknownError',
                          'message' => 'Server sent back an unexpected reply.',
                          'details' => response,
                        }
                      end

        end
        error_obj
      end

      # Creates an appropriate HTTP error exception, based on retrieved http error code
      # @param url [String] the url of the product
      # @param response [Hash] dictionary response retrieved by the server
      def handle_error(url, response)
        code = response.code.to_i
        begin
          parsed_hash = JSON.parse(response.body, object_class: Hash)
        rescue JSON::ParserError
          parsed_hash = response.body.to_s
        end
        error_obj = create_error_obj(parsed_hash)
        case code
        when 400..499
          Errors::MindeeHTTPClientError.new(error_obj || {}, url, code)
        when 500..599
          Errors::MindeeHTTPServerError.new(error_obj || {}, url, code)
        else
          Errors::MindeeHTTPError.new(error_obj || {}, url, code)
        end
      end

      # Creates an appropriate HTTP error exception for a V2 API response, based on retrieved http error code.
      # @param hashed_response [Hash] dictionary response retrieved by the server
      def generate_v2_error(hashed_response)
        code = hashed_response['code'].to_i
        if hashed_response.key?('status')
          Errors::MindeeHTTPErrorV2.new(hashed_response)
        elsif code < 200 || code > 399
          Errors::MindeeHTTPErrorV2.new({ 'status' => code, 'detail' => 'No details available.' })
        else
          Errors::MindeeHTTPErrorV2.new({ 'status' => -1, 'detail' => 'Unknown Error.' })
        end
      end
    end
  end
end
