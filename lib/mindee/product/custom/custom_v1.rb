# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    # Custom document object.
    class CustomV1
      # All value fields in the document
      # @return [Hash<Symbol, Mindee::Custom::ListField>]
      attr_reader :fields
      # All classifications in the document
      # @return [Hash<Symbol, Mindee::Custom::ClassificationField>]
      attr_reader :classifications

      # @param prediction [Hash]
      # @param page_id [Integer, nil]
      def initialize(prediction, page_id)
        @fields = {}
        @classifications = {}
        prediction.each do |field_name, field_prediction|
          field_sym = field_name.to_sym
          set_field(field_sym, field_prediction, page_id)
        end
      end

      def to_s
        out_str = String.new
        @classifications.each do |name, info|
          out_str << "\n:#{name}: #{info}".rstrip
        end
        @fields.each do |name, info|
          out_str << "\n:#{name}: #{info}".rstrip
        end
        out_str[1..].to_s
      end

      private

      # @param field_prediction [Hash]
      def set_field(field_sym, field_prediction, page_id)
        # Currently two types of fields possible in a custom API response:
        # fields having a list of values, and classification fields.
        # Here we use the fact that only value lists have the 'values' attribute.

        if field_prediction.key? 'values'
          @fields[field_sym] = Custom::ListField.new(field_prediction, page_id)
        elsif field_prediction.key? 'value'
          @classifications[field_sym] = Custom::ClassificationField.new(field_prediction)
        else
          throw 'Unknown API field type'
        end
      end
    end
  end
end
