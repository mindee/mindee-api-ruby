# frozen_string_literal: true

require_relative '../fields'
require_relative 'base'

module Mindee
  # Custom document object.
  class CustomDocument < Document
    # All fields in the document
    # @return [Hash<Symbol, Mindee::ListField>]
    attr_reader :fields

    # @param document_type [String]
    # @param prediction [Hash]
    # @param input_file [Mindee::InputDocument, nil]
    # @param page_id [Integer, nil]
    def initialize(document_type, prediction, input_file: nil, page_id: nil)
      super(document_type, input_file: input_file)
      @fields = {}
      prediction.each do |field_name, field_prediction|
        field_sym = field_name.to_sym
        complete_field = ListField.new(field_prediction, page_id)

        # Add the field to the `fields` array
        @fields[field_sym] = complete_field

        # Create a dynamic accessor function for the field
        singleton_class.module_eval { attr_accessor field_sym }
        send("#{field_sym}=", complete_field)
      end
    end

    def to_s
      out_str = String.new
      out_str << "----- #{@document_type} -----"
      out_str << "\nFilename: #{@filename}".rstrip
      @fields.each do |name, info|
        out_str << "\n#{name}: #{info}".rstrip
      end
      out_str << "\n----------------------"
      out_str
    end
  end
end
