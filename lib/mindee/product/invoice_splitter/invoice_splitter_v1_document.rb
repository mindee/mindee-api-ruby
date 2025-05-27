# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'invoice_splitter_v1_invoice_page_groups'

module Mindee
  module Product
    module InvoiceSplitter
      # Invoice Splitter API version 1.4 document data.
      class InvoiceSplitterV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # List of page groups. Each group represents a single invoice within a multi-invoice document.
        # @return [Mindee::Product::InvoiceSplitter::InvoiceSplitterV1InvoicePageGroups]
        attr_reader :invoice_page_groups

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @invoice_page_groups = Product::InvoiceSplitter::InvoiceSplitterV1InvoicePageGroups.new(
            prediction['invoice_page_groups'], page_id
          )
        end

        # @return [String]
        def to_s
          invoice_page_groups = invoice_page_groups_to_s
          out_str = String.new
          out_str << "\n:Invoice Page Groups:"
          out_str << invoice_page_groups
          out_str[1..].to_s
        end

        private

        # @param char [String]
        # @return [String]
        def invoice_page_groups_separator(char)
          out_str = String.new
          out_str << '  '
          out_str << "+#{char * 74}"
          out_str << '+'
          out_str
        end

        # @return [String]
        def invoice_page_groups_to_s
          return '' if @invoice_page_groups.empty?

          line_items = @invoice_page_groups.map(&:to_table_line).join("\n#{invoice_page_groups_separator('-')}\n  ")
          out_str = String.new
          out_str << "\n#{invoice_page_groups_separator('-')}"
          out_str << "\n  |"
          out_str << ' Page Indexes                                                             |'
          out_str << "\n#{invoice_page_groups_separator('=')}"
          out_str << "\n  #{line_items}"
          out_str << "\n#{invoice_page_groups_separator('-')}"
          out_str
        end
      end
    end
  end
end
