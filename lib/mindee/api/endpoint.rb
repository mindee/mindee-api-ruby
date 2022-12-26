# frozen_string_literal: true

require 'net/http'
require_relative '../version'

module Mindee
  module API
    API_KEY_ENV_NAME = 'MINDEE_API_KEY'
    API_KEY_DEFAULT = nil

    BASE_URL_ENV_NAME = 'MINDEE_BASE_URL'
    BASE_URL_DEFAULT = 'https://api.mindee.net/v1'

    REQUEST_TIMEOUT_ENV_NAME = 'MINDEE_REQUEST_TIMEOUT'
    TIMEOUT_DEFAULT = 120

    USER_AGENT = "mindee-api-ruby@v#{Mindee::VERSION} ruby-v#{RUBY_VERSION} #{Mindee::PLATFORM}"

    INVOICE_VERSION = '3'
    INVOICE_URL_NAME = 'invoices'

    RECEIPT_VERSION = '3'
    RECEIPT_URL_NAME = 'expense_receipts'

    PASSPORT_VERSION = '1'
    PASSPORT_URL_NAME = 'passport'

    # Generic API endpoint for a product.
    class Endpoint
      attr_reader :api_key

      def initialize(owner, url_name, version, key_name: nil, api_key: nil)
        @owner = owner
        @url_name = url_name
        @version = version
        @key_name = key_name || url_name
        @api_key = api_key || set_api_key_from_env
        @url_root = "#{BASE_URL_DEFAULT}/products/#{@owner}/#{@url_name}/v#{@version}"
      end

      # @param input_doc [Mindee::InputDocument]
      # @param include_words [Boolean]
      # @param close_file [Boolean]
      # @param cropper [Boolean]
      # @return [Net::HTTPResponse]
      def predict_req_post(input_doc, include_words: false, close_file: true, cropper: false)
        uri = URI("#{@url_root}/predict")

        params = {}
        params[:cropper] = 'true' if cropper
        uri.query = URI.encode_www_form(params)

        headers = {
          'Authorization' => "Token #{@api_key}",
          'User-Agent' => USER_AGENT,
        }
        req = Net::HTTP::Post.new(uri, headers)

        form_data = {
          'document' => input_doc.read_document(close: close_file),
        }
        form_data.push ['include_mvision', 'true'] if include_words

        req.set_form(form_data, 'multipart/form-data')

        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(req)
        end
      end

      # Set the endpoint's API key from an environment variable, if present.
      # We look first for the specific key, if not set, we'll use the generic key
      def set_api_key_from_env
        env_key = ENV.fetch(API_KEY_ENV_NAME, API_KEY_DEFAULT)
        @api_key = env_key if env_key
      end
    end

    # Invoice API endpoint
    class InvoiceEndpoint < Endpoint
      def initialize(api_key)
        super('mindee', INVOICE_URL_NAME, INVOICE_VERSION, key_name: 'invoice', api_key: api_key)
      end
    end

    # Receipt API endpoint
    class ReceiptEndpoint < Endpoint
      def initialize(api_key)
        super('mindee', RECEIPT_URL_NAME, RECEIPT_VERSION, key_name: 'receipt', api_key: api_key)
      end
    end

    # Passport API endpoint
    class PassportEndpoint < Endpoint
      def initialize(api_key)
        super('mindee', PASSPORT_URL_NAME, PASSPORT_VERSION, api_key: api_key)
      end
    end

    # Custom (constructed) API endpoint
    class CustomEndpoint < Endpoint
      def initialize(document_type, account_name, version, api_key)
        super(account_name, document_type, version, api_key: api_key)
      end
    end
  end
end
