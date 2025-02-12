# frozen_string_literal: true

require_relative '../../parsing'
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
      # Nutrition Facts Label API version 1.0 document data.
      class NutritionFactsLabelV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # The amount of added sugars in the product.
        # @return [Mindee::Product::NutritionFactsLabel::NutritionFactsLabelV1AddedSugar]
        attr_reader :added_sugars
        # The amount of calories in the product.
        # @return [Mindee::Product::NutritionFactsLabel::NutritionFactsLabelV1Calorie]
        attr_reader :calories
        # The amount of cholesterol in the product.
        # @return [Mindee::Product::NutritionFactsLabel::NutritionFactsLabelV1Cholesterol]
        attr_reader :cholesterol
        # The amount of dietary fiber in the product.
        # @return [Mindee::Product::NutritionFactsLabel::NutritionFactsLabelV1DietaryFiber]
        attr_reader :dietary_fiber
        # The amount of nutrients in the product.
        # @return [Array<Mindee::Product::NutritionFactsLabel::NutritionFactsLabelV1Nutrient>]
        attr_reader :nutrients
        # The amount of protein in the product.
        # @return [Mindee::Product::NutritionFactsLabel::NutritionFactsLabelV1Protein]
        attr_reader :protein
        # The amount of saturated fat in the product.
        # @return [Mindee::Product::NutritionFactsLabel::NutritionFactsLabelV1SaturatedFat]
        attr_reader :saturated_fat
        # The number of servings in each box of the product.
        # @return [Mindee::Parsing::Standard::AmountField]
        attr_reader :serving_per_box
        # The size of a single serving of the product.
        # @return [Mindee::Product::NutritionFactsLabel::NutritionFactsLabelV1ServingSize]
        attr_reader :serving_size
        # The amount of sodium in the product.
        # @return [Mindee::Product::NutritionFactsLabel::NutritionFactsLabelV1Sodium]
        attr_reader :sodium
        # The total amount of carbohydrates in the product.
        # @return [Mindee::Product::NutritionFactsLabel::NutritionFactsLabelV1TotalCarbohydrate]
        attr_reader :total_carbohydrate
        # The total amount of fat in the product.
        # @return [Mindee::Product::NutritionFactsLabel::NutritionFactsLabelV1TotalFat]
        attr_reader :total_fat
        # The total amount of sugars in the product.
        # @return [Mindee::Product::NutritionFactsLabel::NutritionFactsLabelV1TotalSugar]
        attr_reader :total_sugars
        # The amount of trans fat in the product.
        # @return [Mindee::Product::NutritionFactsLabel::NutritionFactsLabelV1TransFat]
        attr_reader :trans_fat

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super(prediction)
          @added_sugars = NutritionFactsLabelV1AddedSugar.new(prediction['added_sugars'], page_id)
          @calories = NutritionFactsLabelV1Calorie.new(prediction['calories'], page_id)
          @cholesterol = NutritionFactsLabelV1Cholesterol.new(prediction['cholesterol'], page_id)
          @dietary_fiber = NutritionFactsLabelV1DietaryFiber.new(prediction['dietary_fiber'], page_id)
          @nutrients = []
          prediction['nutrients'].each do |item|
            @nutrients.push(NutritionFactsLabel::NutritionFactsLabelV1Nutrient.new(item, page_id))
          end
          @protein = NutritionFactsLabelV1Protein.new(prediction['protein'], page_id)
          @saturated_fat = NutritionFactsLabelV1SaturatedFat.new(prediction['saturated_fat'], page_id)
          @serving_per_box = AmountField.new(prediction['serving_per_box'], page_id)
          @serving_size = NutritionFactsLabelV1ServingSize.new(prediction['serving_size'], page_id)
          @sodium = NutritionFactsLabelV1Sodium.new(prediction['sodium'], page_id)
          @total_carbohydrate = NutritionFactsLabelV1TotalCarbohydrate.new(prediction['total_carbohydrate'], page_id)
          @total_fat = NutritionFactsLabelV1TotalFat.new(prediction['total_fat'], page_id)
          @total_sugars = NutritionFactsLabelV1TotalSugar.new(prediction['total_sugars'], page_id)
          @trans_fat = NutritionFactsLabelV1TransFat.new(prediction['trans_fat'], page_id)
        end

        # @return [String]
        def to_s
          serving_size = @serving_size.to_s
          calories = @calories.to_s
          total_fat = @total_fat.to_s
          saturated_fat = @saturated_fat.to_s
          trans_fat = @trans_fat.to_s
          cholesterol = @cholesterol.to_s
          total_carbohydrate = @total_carbohydrate.to_s
          dietary_fiber = @dietary_fiber.to_s
          total_sugars = @total_sugars.to_s
          added_sugars = @added_sugars.to_s
          protein = @protein.to_s
          sodium = @sodium.to_s
          nutrients = nutrients_to_s
          out_str = String.new
          out_str << "\n:Serving per Box: #{@serving_per_box}".rstrip
          out_str << "\n:Serving Size:"
          out_str << serving_size
          out_str << "\n:Calories:"
          out_str << calories
          out_str << "\n:Total Fat:"
          out_str << total_fat
          out_str << "\n:Saturated Fat:"
          out_str << saturated_fat
          out_str << "\n:Trans Fat:"
          out_str << trans_fat
          out_str << "\n:Cholesterol:"
          out_str << cholesterol
          out_str << "\n:Total Carbohydrate:"
          out_str << total_carbohydrate
          out_str << "\n:Dietary Fiber:"
          out_str << dietary_fiber
          out_str << "\n:Total Sugars:"
          out_str << total_sugars
          out_str << "\n:Added Sugars:"
          out_str << added_sugars
          out_str << "\n:Protein:"
          out_str << protein
          out_str << "\n:sodium:"
          out_str << sodium
          out_str << "\n:nutrients:"
          out_str << nutrients
          out_str[1..].to_s
        end

        private

        # @param char [String]
        # @return [String]
        def nutrients_separator(char)
          out_str = String.new
          out_str << '  '
          out_str << "+#{char * 13}"
          out_str << "+#{char * 22}"
          out_str << "+#{char * 10}"
          out_str << "+#{char * 13}"
          out_str << "+#{char * 6}"
          out_str << '+'
          out_str
        end

        # @return [String]
        def nutrients_to_s
          return '' if @nutrients.empty?

          line_items = @nutrients.map(&:to_table_line).join("\n#{nutrients_separator('-')}\n  ")
          out_str = String.new
          out_str << "\n#{nutrients_separator('-')}"
          out_str << "\n  |"
          out_str << ' Daily Value |'
          out_str << ' Name                 |'
          out_str << ' Per 100g |'
          out_str << ' Per Serving |'
          out_str << ' Unit |'
          out_str << "\n#{nutrients_separator('=')}"
          out_str << "\n  #{line_items}"
          out_str << "\n#{nutrients_separator('-')}"
          out_str
        end
      end
    end
  end
end
