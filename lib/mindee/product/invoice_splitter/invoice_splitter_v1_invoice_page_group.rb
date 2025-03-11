# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module InvoiceSplitter
      # List of page groups. Each group represents a single invoice within a multi-invoice document.
      class InvoiceSplitterV1InvoicePageGroup < Mindee::Parsing::Standard::FeatureField
        include Mindee::Parsing::Standard
        # List of page indexes that belong to the same invoice (group).
        # @return [Array<Integer>]
        attr_reader :page_indexes

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @page_indexes = prediction['page_indexes']
          @page_id = page_id
        end

        # @return [Hash]
        def printable_values
          printable = {}
          printable[:page_indexes] = format_for_display(@page_indexes)
          printable
        end

        # @return [Hash]
        def table_printable_values
          printable = {}
          printable[:page_indexes] = @page_indexes.join(', ')
          printable
        end

        # @return [String]
        def to_table_line
          printable = table_printable_values
          out_str = String.new
          out_str << format('| %- 73s', printable[:page_indexes])
          out_str << '|'
        end

        # @return [String]
        def to_s
          printable = printable_values
          out_str = String.new
          out_str << "\n  :Page Indexes: #{printable[:page_indexes]}"
          out_str
        end
      end
    end
  end
end
