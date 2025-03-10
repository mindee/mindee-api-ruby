# frozen_string_literal: true

require_relative 'invoice_splitter_v1_invoice_page_group'

module Mindee
  module Product
    module InvoiceSplitter
      # List of page groups. Each group represents a single invoice within a multi-invoice document.
      class InvoiceSplitterV1InvoicePageGroups < Array
        # Entries.
        # @return [Array<InvoiceSplitterV1InvoicePageGroup>]
        attr_reader :entries

        # @param prediction [Array]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          entries = prediction.map do |entry|
            InvoiceSplitter::InvoiceSplitterV1InvoicePageGroup.new(entry, page_id)
          end
          super(entries)
        end

        # Creates a line of rST table-compliant string separators.
        # @param char [String] Character to use as a separator.
        # @return [String]
        def self.line_items_separator(char)
          out_str = String.new
          out_str << "+#{char * 74}"
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
          out_str << ' | Page Indexes                                                            '
          out_str << (" |\n#{self.class.line_items_separator('=')}")
          out_str + lines
        end
      end
    end
  end
end
