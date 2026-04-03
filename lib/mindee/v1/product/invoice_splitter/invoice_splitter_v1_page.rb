# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'invoice_splitter_v1_document'

module Mindee
  module V1
    module Product
      module InvoiceSplitter
        # Invoice Splitter API version 1.4 page data.
        class InvoiceSplitterV1Page < Mindee::V1::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = if prediction['prediction'].empty?
                            nil
                          else
                            InvoiceSplitterV1PagePrediction.new(
                              prediction['prediction'],
                              prediction['id']
                            )
                          end
          end
        end

        # Invoice Splitter V1 page prediction.
        class InvoiceSplitterV1PagePrediction < InvoiceSplitterV1Document
          # @return [String]
          def to_s
            out_str = String.new
            out_str << "\n#{super}"
            out_str
          end
        end
      end
    end
  end
end
