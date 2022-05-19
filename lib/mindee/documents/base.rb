# frozen_string_literal: true

module Mindee
  # Base document object.
  class Document
    # document type
    # @return [String]
    attr_reader :document_type
    # Validation checks for the document
    # @return [Hash<Symbol, Boolean>]
    attr_reader :checklist

    # @param document_type [String]
    def initialize(document_type)
      @document_type = document_type
      @checklist = {}
    end

    # @return [Boolean]
    def all_checks
      @checklist.all? { |_, value| value == true }
    end
  end
end
