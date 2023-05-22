# frozen_string_literal: true

require_relative '../common_fields'
require_relative '../base'

module Mindee
  module Prediction
    # Page Group for Invoice Splitter class
    class PageGroup

      # @return[Array<Integer>]
      attr_reader :page_indexes

      # @return[Float]
      attr_reader :confidence

      # @param prediction[Hash]
      def initialize(prediction, confidence)
        @page_indexes = prediction["page_indexes"]
        !!@confidence = Float(prediction["confidence"]) rescue @confidence = 0.0
      end

      def to_s
        out_str = String.new
        out_str << @page_indexes.map(&:to_s).join(", ")
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
        construct_invoice_page_groups_from_prediction(prediction["prediction"])
      end

      def construct_invoice_page_groups_from_prediction(prediction)
        if prediction["invoice_page_groups"].any?
          prediction["invoice_page_groups"].each() do 
            |page_group_prediction| PageGroup.new(page_group_prediction) 
          end
        else
          @invoice_page_groups = []
        end
      end

      def to_s
        out_str = String.new
        out_str << "----- Invoice Splitter V1 -----\n"
        out_str << "Filename: #{@filename || ''}".rstrip
        out_str << "Invoice Page Groups: #{@invoice_page_groups}".rstrip
        out_str
      end
    end
  end
end
