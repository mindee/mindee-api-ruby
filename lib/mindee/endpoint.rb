# frozen_string_literal: true

require 'net/http'
require_relative 'version'

module Mindee
  MINDEE_API_URL = 'https://api.mindee.net/v1'
  USER_AGENT = "mindee-api-ruby@#{Mindee::VERSION} ruby-v#{RUBY_VERSION}"

  INVOICE_VERSION = '3'
  INVOICE_URL_NAME = 'invoices'

  RECEIPT_VERSION = '3'
  RECEIPT_URL_NAME = 'expense_receipts'

  PASSPORT_VERSION = '1'
  PASSPORT_URL_NAME = 'passport'

  # Generic API endpoint for a product.
  class Endpoint
    attr_reader :api_key

    def initialize(owner, url_name, version, api_key)
      @owner = owner
      @url_name = url_name
      @version = version
      @api_key = api_key unless api_key.nil?
      @url_root = "#{MINDEE_API_URL}/products/#{@owner}/#{@url_name}/v#{@version}"
    end

    def predict_request(input_doc, include_words: false)
      uri = URI("#{@url_root}/predict")
      req = Net::HTTP::Post.new(uri)
      req['Authorization'] = @api_key

      params = [
        ['document', input_doc.read_document],
      ]
      params.push ['include_mvision', 'true'] if include_words

      req.set_form(params, 'multipart/form-data')

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end
    end
  end

  class InvoiceEndpoint < Endpoint
    def initialize(api_key)
      super('mindee', INVOICE_URL_NAME, INVOICE_VERSION, api_key)
    end
  end

  class ReceiptEndpoint < Endpoint
    def initialize(api_key)
      super('mindee', RECEIPT_URL_NAME, RECEIPT_VERSION, api_key)
    end
  end

  class PassportEndpoint < Endpoint
    def initialize(api_key)
      super('mindee', PASSPORT_URL_NAME, PASSPORT_VERSION, api_key)
    end
  end

  class CustomEndpoint < Endpoint
    def initialize(document_type, account_name, version, api_key)
      super(account_name, document_type, version, api_key)
    end
  end
end
