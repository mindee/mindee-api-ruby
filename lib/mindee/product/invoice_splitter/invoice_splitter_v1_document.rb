# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module InvoiceSplitter
      # Page Group for Invoice Splitter class
      class InvoiceSplitterV1PageGroup
        # @return[Array<Integer>]
        attr_reader :page_indexes

        # @return[Float, nil]
        attr_reader :confidence

        # @param prediction[Hash]
        def initialize(prediction)
          @page_indexes = prediction['page_indexes']
          @confidence = prediction['confidence'].nil? ? 0.0 : Float(prediction['confidence'])
        end

        # @return [String]
        def to_s
          out_str = String.new
          out_str << ":Page indexes: #{@page_indexes.join(', ')}"
          out_str
        end
      end

      # Invoice Splitter V1 document prediction.
      class InvoiceSplitterV1Document < Mindee::Parsing::Common::Prediction
        # @return[Array<Mindee::Product::InvoiceSplitterV1PageGroup>]
        attr_reader :invoice_page_groups

        # @param prediction [Hash]
        # @param _page_id [Integer, nil]
        def initialize(prediction, _page_id)
          super()
          construct_invoice_page_groups_from_prediction(prediction)
        end

        # Reconstructs the page groups of a prediction
        # @param prediction [hash]
        def construct_invoice_page_groups_from_prediction(prediction)
          @invoice_page_groups = []
          return unless prediction.key?('invoice_page_groups') && prediction['invoice_page_groups'].any?

          prediction['invoice_page_groups'].each do |page_group_prediction|
            @invoice_page_groups.append(InvoiceSplitterV1PageGroup.new(page_group_prediction))
          end
        end

        # @return [String]
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
end
