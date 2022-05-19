# frozen_string_literal: true

module Mindee
  # Stores all response attributes.
  class DocumentResponse
    # @return [String]
    attr_reader :document_type
    # @return [Hash]
    attr_reader :http_response
    # @return [Mindee::Document]
    attr_reader :document
    # @return [Array<Mindee::Document>]
    attr_reader :pages

    def initialize(http_response, document_type, document, pages)
      @http_response = http_response
      @document_type = document_type
      @document = document
      @pages = pages
    end

    def to_s
      inspect
    end
  end
end
