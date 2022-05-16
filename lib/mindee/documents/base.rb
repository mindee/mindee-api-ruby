# frozen_string_literal: true

module Mindee
  # Base document object.
  class Document
    attr_reader :document_type

    def initialize(document_type)
      @document_type = document_type
      @checks = []
    end

    def all_checks
      @checks.all? { |value| value == true }
    end
  end
end
