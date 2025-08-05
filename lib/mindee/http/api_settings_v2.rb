# frozen_string_literal: true

module Mindee
  module HTTP
    # API client for version 2.
    class ApiSettingsV2
      # V2 API key's default environment key name.
      MINDEE_V2_API_KEY_ENV_NAME = 'MINDEE_V2_API_KEY'
      # V2 API key's default value.
      MINDEE_V2_API_KEY_DEFAULT = nil

      # V2 base URL default environment key name.
      MINDEE_V2_BASE_URL_ENV_NAME = 'MINDEE_V2_BASE_URL'
      # V2 base URL default value.
      MINDEE_V2_BASE_URL_DEFAULT = 'https://api-v2.mindee.net/v2'

      # HTTP request timeout default environment key name.
      MINDEE_V2_REQUEST_TIMEOUT_ENV_NAME = 'MINDEE_V2_REQUEST_TIMEOUT'
      # HTTP request timeout default value.
      MINDEE_V2_TIMEOUT_DEFAULT = 120

      # Default value for the user agent (same as V1).
      USER_AGENT = "mindee-api-ruby@v#{Mindee::VERSION} ruby-v#{RUBY_VERSION} #{Mindee::PLATFORM}".freeze

      # @return [String]
      attr_reader :api_key
      # @return [Integer]
      attr_reader :request_timeout
      # @return [String]
      attr_reader :base_url
      # @return [String]
      attr_reader :user_agent

      def initialize(api_key: '')
        @request_timeout = ENV.fetch(MINDEE_V2_REQUEST_TIMEOUT_ENV_NAME, MINDEE_V2_TIMEOUT_DEFAULT).to_i
        if api_key.nil? && !ENV.fetch(MINDEE_V2_API_KEY_ENV_NAME, MINDEE_V2_API_KEY_DEFAULT).to_s.empty?
          logger.debug('API key set from environment')
        end
        @api_key = if api_key.nil? || api_key.empty?
                     ENV.fetch(MINDEE_V2_API_KEY_ENV_NAME,
                               MINDEE_V2_API_KEY_DEFAULT)
                   else
                     api_key
                   end
        @base_url = ENV.fetch(MINDEE_V2_BASE_URL_ENV_NAME, MINDEE_V2_BASE_URL_DEFAULT).chomp('/')
        @user_agent = USER_AGENT
      end

      # Checks API key for a value.
      # @return
      # @raise [Errors::MindeeAPIError] Raises if the api key is empty or nil.
      def check_api_key
        return unless @api_key.nil? || @api_key.empty?

        raise Errors::MindeeAPIError,
              "Missing API key. check your Client Configuration.\nYou can set this using the " \
              "'#{MINDEE_V2_API_KEY_ENV_NAME}' environment variable."
      end
    end
  end
end
