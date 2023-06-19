# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    # Page Group for Invoice Splitter class
    class PageGroup
      # @return[Array<Integer>]
      attr_reader :page_indexes

      # @return[Float, nil]
      attr_reader :confidence

      # @param prediction[Hash]
      def initialize(prediction)
        @page_indexes = prediction['page_indexes']
        @confidence = prediction['confidence'].nil? ? 0.0 : Float(prediction['confidence'])
      end

      def to_s
        out_str = String.new
        out_str << ":Page indexes: #{@page_indexes.join(', ')}"
        out_str
      end
    end

    # Invoice Splitter prediction.
    class InvoiceSplitterV1
      # @return[Array<PageGroup>]
      attr_reader :invoice_page_groups

      # @param prediction [Hash]
      # @param page_id [Integer, nil]
      def initialize(prediction, _page_id)
        construct_invoice_page_groups_from_prediction(prediction)
      end

      def construct_invoice_page_groups_from_prediction(prediction)
        @invoice_page_groups = []
        return unless prediction.key?('invoice_page_groups') && prediction['invoice_page_groups'].any?

        prediction['invoice_page_groups'].each do |page_group_prediction|
          @invoice_page_groups.append(PageGroup.new(page_group_prediction))
        end
      end

      def to_s
        out_str = String.new
        out_str << "\n:Invoice Page Groups:"
        if !@invoice_page_groups.nil? && @invoice_page_groups.any?
          @invoice_page_groups.map do |page|
            out_str << "\n  #{page}"
          end
        end
        out_str[1..].to_s
      end
    end
  end
end
