# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'custom_v1_document'

module Mindee
  module Product
    module Custom
      # Custom Document V1 page.
      class CustomV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super(prediction)
          @prediction = CustomV1PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # Custom Document V1 page prediction.
      class CustomV1PagePrediction < CustomV1Document
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
