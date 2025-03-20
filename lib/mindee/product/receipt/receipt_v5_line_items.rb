# frozen_string_literal: true

require_relative 'receipt_v5_line_item'

module Mindee
  module Product
    module Receipt
      # List of all line items on the receipt.
      class ReceiptV5LineItems < Array
        # Entries.
        # @return [Array<ReceiptV5LineItem>]
        attr_reader :entries

        # @param prediction [Array]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          entries = prediction.map do |entry|
            Receipt::ReceiptV5LineItem.new(entry, page_id)
          end
          super(entries)
        end

        # Creates a line of rST table-compliant string separators.
        # @param char [String] Character to use as a separator.
        # @return [String]
        def self.line_items_separator(char)
          out_str = String.new
          out_str << "+#{char * 38}"
          out_str << "+#{char * 10}"
          out_str << "+#{char * 14}"
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
          out_str << ' | Quantity'
          out_str << ' | Total Amount'
          out_str << ' | Unit Price'
          out_str << (" |\n#{self.class.line_items_separator('=')}")
          out_str + lines
        end
      end
    end
  end
end
