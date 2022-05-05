# frozen_string_literal: true

module Mindee
  class DocumentResponse
    attr_reader :http_response,
                :document_type,
                :document,
                :pages

    def initialize(http_response, document_type, document, pages)
      @http_response = http_response
      @document_type = document_type
      @document = document
      @pages = pages
    end
  end
end
