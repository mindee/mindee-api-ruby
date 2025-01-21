# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'bill_of_lading_v1_document'

module Mindee
  module Product
    module BillOfLading
      # Bill of Lading API version 1.1 page data.
      class BillOfLadingV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = BillOfLadingV1PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # Bill of Lading V1 page prediction.
      class BillOfLadingV1PagePrediction < BillOfLadingV1Document
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
