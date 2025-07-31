# frozen_string_literal: true

require 'json'
require 'net/http'

module Mindee
  module HTTP
    # Module dedicated to the validation & sanitizing of HTTP responses.
    module ResponseValidation
      # Checks if the synchronous response is valid. Returns True if the response is valid.
      # @param [Net::HTTPResponse] response
      # @return [bool]
      def self.valid_sync_response?(response)
        return false unless (200..399).cover?(response.code.to_i)

        begin
          JSON.parse(response.body, object_class: Hash)
        rescue StandardError
          return false
        end
        true
      end

      # Checks if a V2 response is valid.
      # @param [Net::HTTPResponse] response
      # @return [bool]
      def self.valid_v2_response?(response)
        return false unless valid_sync_response?(response)

        hashed_response = JSON.parse(response.body, object_class: Hash)

        return false if hashed_response.dig('job', 'status').to_s == 'Failed'

        return false if hashed_response.dig('job', 'error') && !hashed_response.dig('job', 'error').empty?

        true
      end

      # Checks if the asynchronous response is valid. Also checks if it is a valid synchronous response.
      # Returns true if the response is valid.
      # @param [Net::HTTPResponse] response
      # @return [bool]
      def self.valid_async_response?(response)
        return false unless valid_sync_response?(response)

        return false unless (200..302).cover?(response.code.to_i)

        hashed_response = JSON.parse(response.body, object_class: Hash)

        return false if hashed_response.dig('job', 'status') == Mindee::Parsing::Common::JobStatus::FAILURE

        return false if hashed_response.dig('job', 'error') && !hashed_response.dig('job', 'error').empty?

        true
      end

      # Checks and correct the response object depending on the possible kinds of returns.
      # @param response [Net::HTTPResponse]
      def self.clean_request!(response)
        return response if (response.code.to_i < 200) || (response.code.to_i > 302) # : Net::HTTPResponse

        return response if response.body.empty?

        hashed_response = JSON.parse(response.body, object_class: Hash)
        if hashed_response.dig('api_request', 'status_code').to_i > 399
          response.instance_variable_set(:@code, hashed_response['api_request']['status_code'].to_s)
        end

        return if !hashed_response.dig('job', 'error').empty? &&
                  (hashed_response.dig('job', 'status') != Mindee::Parsing::Common::JobStatus::FAILURE.to_s)

        response.instance_variable_set(:@code, '500')
      end
    end
  end
end
