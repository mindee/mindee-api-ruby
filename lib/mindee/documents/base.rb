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
    # Original filename of the document
    # @return [String, nil]
    attr_reader :filename
    # Detected MIME type of the document
    # @return [String, nil]
    attr_reader :file_mimetype

    # @param input_file [Mindee::InputDocument]
    # @param document_type [String]
    def initialize(document_type, input_file: nil)
      @document_type = document_type
      if input_file
        @filename = input_file.filename
        @file_mimetype = input_file.file_mimetype
      end
      @checklist = {}
    end

    # @return [Boolean]
    def all_checks
      @checklist.all? { |_, value| value == true }
    end
  end
end
