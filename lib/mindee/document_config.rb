# frozen_string_literal: true

require 'json'

require_relative 'api/endpoint'
require_relative 'api/response'
require_relative 'documents'

module Mindee
  # Specific client for sending a document to the API.
  class DocumentConfig
    # Array of possible Mindee::Endpoint to be used.
    # @return [Array<Mindee::Endpoint>]
    attr_reader :endpoints

    # @param doc_class [Class<Mindee::Document>]
    # @param document_type [String]
    # @param endpoints [Array<Mindee::Endpoint>]
    # @param raise_on_error [Boolean]
    def initialize(doc_class, document_type, endpoints, raise_on_error)
      @doc_class = doc_class
      @document_type = document_type
      @endpoints = endpoints
      @raise_on_error = raise_on_error
    end

    # Parse a prediction API result.
    # @param input_doc [Mindee::InputDocument]
    # @param response [Hash]
    # @return [Mindee::DocumentResponse]
    def build_predict_result(input_doc, response)
      document = @doc_class.new(
        response['document']['inference']['prediction'],
        input_file: input_doc,
        page_id: nil
      )
      pages = []
      response['document']['inference']['pages'].each do |page|
        pages.push(
          @doc_class.new(
            page['prediction'],
            input_file: input_doc,
            page_id: page['id']
          )
        )
      end
      DocumentResponse.new(response, @document_type, document, pages)
    end

    # Call the prediction API.
    # @param input_doc [Mindee::InputDocument]
    # @param include_words [Boolean]
    # @param close_file [Boolean]
    # @param cropper [Boolean]
    # @return [Mindee::DocumentResponse]
    def predict(input_doc, include_words, close_file, cropper)
      check_api_keys
      response = predict_request(input_doc, include_words, close_file, cropper)
      parse_response(input_doc, response)
    end

    private

    # @param input_doc [Mindee::InputDocument]
    # @param response [Net::HTTPResponse]
    # @return [Mindee::DocumentResponse]
    def parse_response(input_doc, response)
      hashed_response = JSON.parse(response.body, object_class: Hash)
      unless (200..299).include?(response.code.to_i)
        if @raise_on_error
          raise Net::HTTPError.new(
            "API #{response.code} HTTP error: #{hashed_response}", response
          )
        end
        return DocumentResponse.new(
          hashed_response, @document_type, {}, []
        )
      end
      build_predict_result(input_doc, hashed_response)
    end

    # @param input_doc [Mindee::InputDocument]
    # @param include_words [Boolean]
    # @param close_file [Boolean]
    # # @param cropper [Boolean]
    # @return [Net::HTTPResponse]
    def predict_request(input_doc, include_words, close_file, cropper)
      @endpoints[0].predict_req_post(input_doc, include_words: include_words, close_file: close_file, cropper: cropper)
    end

    def check_api_keys
      @endpoints.each do |endpoint|
        next unless endpoint.api_key.nil? || endpoint.api_key.empty?

        raise "Missing API key for '#{@document_type}', " \
              "check your Client Configuration.\n" \
              'You can set this using the ' \
              "'#{endpoint.envvar_key_name}' environment variable."
      end
    end
  end

  # Client for Financial documents
  class FinancialDocConfig < DocumentConfig
    def initialize(api_key, raise_on_error)
      endpoints = [
        InvoiceEndpoint.new(api_key),
        ReceiptEndpoint.new(api_key),
      ]
      super(
        FinancialDocument,
        'financial_doc',
        endpoints,
        raise_on_error
      )
    end

    private

    # @param input_doc [Mindee::InputDocument]
    # @param include_words [Boolean]
    # @param close_file [Boolean]
    # # @param cropper [Boolean]
    # @return [Net::HTTPResponse]
    def predict_request(input_doc, include_words, close_file)
      endpoint = input_doc.pdf? ? @endpoints[0] : @endpoints[1]
      endpoint.predict_req_post(input_doc, include_words: include_words, close_file: close_file, cropper: cropper)
    end
  end

  # Client for Custom (constructed) documents
  class CustomDocConfig < DocumentConfig
    def initialize(account_name, endpoint_name, version, api_key, raise_on_error)
      endpoints = [CustomEndpoint.new(endpoint_name, account_name, version, api_key)]
      super(
        CustomV1,
        endpoint_name,
        endpoints,
        raise_on_error
      )
    end

    # Parse a prediction API result.
    # @param input_doc [Mindee::InputDocument]
    # @param response [Hash]
    # @return [Mindee::DocumentResponse]
    def build_predict_result(input_doc, response)
      document = CustomV1.new(
        @document_type,
        response['document']['inference']['prediction'],
        input_file: input_doc,
        page_id: nil
      )
      pages = []
      response['document']['inference']['pages'].each do |page|
        pages.push(
          CustomV1.new(
            @document_type,
            page['prediction'],
            input_file: input_doc,
            page_id: page['id']
          )
        )
      end
      DocumentResponse.new(response, @document_type, document, pages)
    end
  end
end
