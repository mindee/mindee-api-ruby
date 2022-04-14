# frozen_string_literal: true

module Mindee
  class DocumentConfig
    attr_reader :endpoints

    def initialize(document_type, singular_name, plural_name, endpoints)
      @document_type = document_type
      @singular_name = singular_name
      @plural_name = plural_name
      @endpoints = endpoints
    end
  end
end
