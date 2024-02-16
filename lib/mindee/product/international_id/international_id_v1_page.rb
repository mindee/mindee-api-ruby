# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'international_id_v1_document'

module Mindee
  module Product
    module InternationalId
      # International ID V1 page.
      class InternationalIdV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super(prediction)
          @prediction = InternationalIdV1PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # International ID V1 page prediction.
      class InternationalIdV1PagePrediction < InternationalIdV1Document
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
