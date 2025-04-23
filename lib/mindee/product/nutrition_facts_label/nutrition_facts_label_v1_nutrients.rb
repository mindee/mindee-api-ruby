# frozen_string_literal: true

require_relative 'nutrition_facts_label_v1_serving_size'
require_relative 'nutrition_facts_label_v1_calorie'
require_relative 'nutrition_facts_label_v1_total_fat'
require_relative 'nutrition_facts_label_v1_saturated_fat'
require_relative 'nutrition_facts_label_v1_trans_fat'
require_relative 'nutrition_facts_label_v1_cholesterol'
require_relative 'nutrition_facts_label_v1_total_carbohydrate'
require_relative 'nutrition_facts_label_v1_dietary_fiber'
require_relative 'nutrition_facts_label_v1_total_sugar'
require_relative 'nutrition_facts_label_v1_added_sugar'
require_relative 'nutrition_facts_label_v1_protein'
require_relative 'nutrition_facts_label_v1_sodium'
require_relative 'nutrition_facts_label_v1_nutrient'

module Mindee
  module Product
    module NutritionFactsLabel
      # The amount of nutrients in the product.
      class NutritionFactsLabelV1Nutrients < Array
        # Entries.
        # @return [Array<NutritionFactsLabelV1Nutrient>]
        attr_reader :entries

        # @param prediction [Array]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          entries = prediction.map do |entry|
            NutritionFactsLabel::NutritionFactsLabelV1Nutrient.new(entry, page_id)
          end
          super(entries)
        end

        # Creates a line of rST table-compliant string separators.
        # @param char [String] Character to use as a separator.
        # @return [String]
        def self.line_items_separator(char)
          out_str = String.new
          out_str << "+#{char * 13}"
          out_str << "+#{char * 22}"
          out_str << "+#{char * 10}"
          out_str << "+#{char * 13}"
          out_str << "+#{char * 6}"
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
          out_str << ' | Daily Value'
          out_str << ' | Name                '
          out_str << ' | Per 100g'
          out_str << ' | Per Serving'
          out_str << ' | Unit'
          out_str << " |\n#{self.class.line_items_separator('=')}"
          out_str + lines
        end
      end
    end
  end
end
