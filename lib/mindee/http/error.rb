# frozen_string_literal: true

module Mindee
  module HTTP
    # Mindee HTTP error module.
    module Error
      module_function

      # Creates an error object based on what's retrieved from a request.
      # @param response [Hash] dictionary response retrieved by the server
      def create_error_obj(response)
        error_obj = response.respond_to?(:each_pair) ? response.dig('api_request', 'error') : nil
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
      # @param code [Integer] http error code of the response
      def handle_error!(url, response, code)
        error_obj = create_error_obj(response)
        case code
        when 400..499
          MindeeHttpClientError.new(error_obj, url, code)
        when 500..599
          MindeeHttpServerError.new(error_obj, url, code)
        else
          MindeeHttpError.new(error_obj, url, code)
        end
      end

      # API HttpError
      class MindeeHttpError < StandardError
        # @return [String]
        attr_reader :status_code
        # @return [String]
        attr_reader :api_code
        # @return [String]
        attr_reader :api_details
        # @return [String]
        attr_reader :api_message

        # @param http_error [Hash]
        # @param url [String]
        # @param code [Integer]
        def initialize(http_error, url, code)
          @status_code = code
          @api_code = http_error['code']
          @api_details = http_error['details']
          @api_message = http_error['message']
          super("#{url} #{@status_code} HTTP error: #{@api_details} - #{@api_message}")
        end
      end

      # API client HttpError
      class MindeeHttpClientError < MindeeHttpError
      end

      # API server HttpError
      class MindeeHttpServerError < MindeeHttpError
      end
    end
  end
end
