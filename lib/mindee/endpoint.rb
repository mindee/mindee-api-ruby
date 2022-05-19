# frozen_string_literal: true

require 'net/http'
require_relative 'version'

module Mindee
  MINDEE_API_URL = 'https://api.mindee.net/v1'
  USER_AGENT = "mindee-api-ruby@#{Mindee::VERSION} ruby-v#{RUBY_VERSION} #{Mindee::PLATFORM}"

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
      @url_root = "#{MINDEE_API_URL}/products/#{@owner}/#{@url_name}/v#{@version}"
    end

    def predict_request(input_doc, include_words: false)
      uri = URI("#{@url_root}/predict")
      headers = {
        'Authorization' => "Token #{@api_key}",
        'User-Agent' => USER_AGENT,
      }
      req = Net::HTTP::Post.new(uri, headers)

      params = [
        ['document', input_doc.read_document],
      ]
      params.push ['include_mvision', 'true'] if include_words

      req.set_form(params, 'multipart/form-data')

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end
    end

    def envvar_key_name
      key_name = to_envar(@key_name)
      key_name = "#{to_envar(@owner)}_#{key_name}" if @owner != 'mindee'
      "MINDEE_#{key_name}_API_KEY"
    end

    private

    # Create a standard way to get/set environment variable names.
    def to_envar(name)
      name.sub('-', '_').upcase
    end

    # Set the endpoint's API key from an environment variable, if present.
    def set_api_key_from_env
      env_key = ENV.fetch('MINDEE_INVOICE_API_KEY', nil)
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
