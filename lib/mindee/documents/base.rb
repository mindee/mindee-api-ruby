# frozen_string_literal: true

module Mindee
  class Document
    attr_reader :document_type

    def initialize(document_type)
      @document_type = document_type
    end
  end
end
