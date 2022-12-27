# frozen_string_literal: true

module Mindee
  # Base document object.
  class Prediction
    # document type
    # @return [String]
    attr_reader :document_type
    # Validation checks for the document
    # @return [Hash<Symbol, Boolean>]
    attr_reader :checklist
    # Original filename of the document
    # @return [String, nil]
    attr_reader :filename
    # Detected MIME type of the document
    # @return [String, nil]
    attr_reader :file_mimetype

    def initialize
      @checklist = {}
    end

    # @return [Boolean]
    def all_checks
      @checklist.all? { |_, value| value == true }
    end
  end
end
