# frozen_string_literal: true

require_relative '../common_fields'
require_relative '../base'

module Mindee
  module Prediction
    # Page Group for Invoice Splitter class
    class PageGroup

      # @return[Array<Integer>]
      attr_reader :page_indexes

      # @return[Float, nil]
      attr_reader :confidence

      # @param prediction[Hash]
      def initialize(prediction)
        @page_indexes = prediction["page_indexes"]
        !!@confidence = Float(prediction["confidence"]) rescue @confidence = 0.0
      end

      def to_s
        out_str = String.new
        out_str << ":Page indexes: #{@page_indexes.join(", ")}"
        out_str
      end
    end

    # Invoice Splitter prediction.
    class InvoiceSplitterV1 < Prediction

      # @return[Array<PageGroup>]
      attr_reader :invoice_page_groups
      # @param prediction [Hash]
      # @param page_id [Integer, nil]
      def initialize(prediction, page_id)
        super
        construct_invoice_page_groups_from_prediction(prediction)
      end

      def construct_invoice_page_groups_from_prediction(prediction)
        @invoice_page_groups = []
        if prediction.key?("invoice_page_groups") && prediction["invoice_page_groups"].any?
          prediction["invoice_page_groups"].each{ 
            |page_group_prediction| @invoice_page_groups.append(PageGroup.new(page_group_prediction))}
        end
      end

      def to_s
        out_str = String.new
        out_str << "\n:Invoice Page Groups:"
        out_str << "#{@invoice_page_groups == nil || !@invoice_page_groups.any? ? "" : "\n  "+@invoice_page_groups.map{|page| page.to_s}.join("\n  ")}".rstrip
        out_str[1..].to_s
      end
    end
  end
end
