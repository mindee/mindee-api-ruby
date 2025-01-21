# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'nutrition_facts_label_v1_document'

module Mindee
  module Product
    module NutritionFactsLabel
      # Nutrition Facts Label API version 1.0 page data.
      class NutritionFactsLabelV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = NutritionFactsLabelV1PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # Nutrition Facts Label V1 page prediction.
      class NutritionFactsLabelV1PagePrediction < NutritionFactsLabelV1Document
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
