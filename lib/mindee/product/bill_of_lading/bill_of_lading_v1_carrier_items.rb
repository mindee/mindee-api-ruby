# frozen_string_literal: true

require_relative 'bill_of_lading_v1_shipper'
require_relative 'bill_of_lading_v1_consignee'
require_relative 'bill_of_lading_v1_notify_party'
require_relative 'bill_of_lading_v1_carrier'
require_relative 'bill_of_lading_v1_carrier_item'

module Mindee
  module Product
    module BillOfLading
      # The goods being shipped.
      class BillOfLadingV1CarrierItems < Array
        # Entries.
        # @return [Array<BillOfLadingV1CarrierItem>]
        attr_reader :entries

        # @param prediction [Array]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          entries = prediction.map do |entry|
            BillOfLading::BillOfLadingV1CarrierItem.new(entry, page_id)
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
          out_str << "+#{char * 13}"
          out_str << "+#{char * 18}"
          out_str << "+#{char * 10}"
          out_str << "+#{char * 13}"
          out_str
        end

        # @return [String]
        def to_s
          return '' if empty?

          lines = map do |entry|
            "\n  #{entry.to_table_line}\n#{self.class.line_items_separator('-')}"
          end.join
          out_str = String.new
          out_str << "\n#{self.class.line_items_separator('-')}\n "
          out_str << ' | Description                         '
          out_str << ' | Gross Weight'
          out_str << ' | Measurement'
          out_str << ' | Measurement Unit'
          out_str << ' | Quantity'
          out_str << ' | Weight Unit'
          out_str << " |\n#{self.class.line_items_separator('=')}"
          out_str + lines
        end
      end
    end
  end
end
