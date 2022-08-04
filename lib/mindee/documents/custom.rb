# frozen_string_literal: true

require_relative '../fields'
require_relative 'base'

module Mindee
  # Custom document object.
  class CustomDocument < Document
    # All value fields in the document
    # @return [Hash<Symbol, Mindee::ListField>]
    attr_reader :fields
    # All classifications in the document
    # @return [Hash<Symbol, Mindee::ClassificationField>]
    attr_reader :classifications

    # @param document_type [String]
    # @param prediction [Hash]
    # @param input_file [Mindee::InputDocument, nil]
    # @param page_id [Integer, nil]
    def initialize(document_type, prediction, input_file: nil, page_id: nil)
      super(document_type, input_file: input_file)
      @fields = {}
      @classifications = {}
      prediction.each do |field_name, field_prediction|
        field_sym = field_name.to_sym
        complete_field = set_field(field_sym, field_prediction, page_id)

        # Create a dynamic accessor function for the field
        singleton_class.module_eval { attr_accessor field_sym }
        send("#{field_sym}=", complete_field)
      end
    end

    def to_s
      out_str = String.new
      out_str << "----- #{@document_type} -----"
      out_str << "\nFilename: #{@filename}".rstrip
      @classifications.each do |name, info|
        out_str << "\n#{name}: #{info}".rstrip
      end
      @fields.each do |name, info|
        out_str << "\n#{name}: #{info}".rstrip
      end
      out_str << "\n----------------------"
      out_str
    end

    private

    # @param field_prediction [Hash]
    def set_field(field_sym, field_prediction, page_id)
      # Currently two types of fields possible in a custom API response:
      # fields having a list of values, and classification fields.
      # Here we use the fact that only value lists have the 'values' attribute.

      if field_prediction.key? 'values'
        @fields[field_sym] = ListField.new(field_prediction, page_id)
      elsif field_prediction.key? 'value'
        @classifications[field_sym] = ClassificationField.new(field_prediction)
      else
        throw 'Unknown API field type'
      end
    end
  end
end
