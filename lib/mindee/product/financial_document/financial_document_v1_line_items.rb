# frozen_string_literal: true

require_relative 'financial_document_v1_line_item'

module Mindee
  module Product
    module FinancialDocument
      # List of line item details.
      class FinancialDocumentV1LineItems < Array
        # Entries.
        # @return [Array<FinancialDocumentV1LineItem>]
        attr_reader :entries

        # @param prediction [Array]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          entries = prediction.map do |entry|
            FinancialDocument::FinancialDocumentV1LineItem.new(entry, page_id)
          end
          super(entries)
        end

        # Creates a line of rST table-compliant string separators.
        # @param char [String] Character to use as a separator.
        # @return [String]
        def self.line_items_separator(char)
          out_str = String.new
          out_str << "+#{char * 38}"
          out_str << "+#{char * 14}"
          out_str << "+#{char * 10}"
          out_str << "+#{char * 12}"
          out_str << "+#{char * 14}"
          out_str << "+#{char * 14}"
          out_str << "+#{char * 17}"
          out_str << "+#{char * 12}"
          out_str
        end

        # @return [String]
        def to_s
          return '' if empty?

          lines = map do |entry|
            "\n  #{entry.to_table_line}\n#{self.class.line_items_separator('-')}"
          end.join
          out_str = String.new
          out_str << ("\n#{self.class.line_items_separator('-')}\n ")
          out_str << ' | Description                         '
          out_str << ' | Product code'
          out_str << ' | Quantity'
          out_str << ' | Tax Amount'
          out_str << ' | Tax Rate (%)'
          out_str << ' | Total Amount'
          out_str << ' | Unit of measure'
          out_str << ' | Unit Price'
          out_str << (" |\n#{self.class.line_items_separator('=')}")
          out_str + lines
        end
      end
    end
  end
end
