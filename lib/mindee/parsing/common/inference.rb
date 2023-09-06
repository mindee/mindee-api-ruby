# frozen_string_literal: true

require_relative 'product'

module Mindee
  module Parsing
    # Common fields used for most documents.
    module Common
      # Abstract class for prediction Inferences
      # Holds prediction for a page or entire document.
      class Inference
        # @return [Boolean]
        attr_reader :is_rotation_applied
        # @return [Array<Mindee::Parsing::Common::Page>]
        attr_reader :pages
        # @return [Mindee::Parsing::Common::Prediction]
        attr_reader :prediction
        # @return [Mindee::Parsing::Common::Product]
        attr_reader :product

        # @param raw_prediction [Hash]
        def initialize(raw_prediction)
          @is_rotation_applied = raw_prediction['is_rotation_applied']
          @product = Product.new(raw_prediction['product'])
          @pages = []
        end

        # @return [String]
        def to_s
          is_rotation_applied = @is_rotation_applied ? 'Yes' : 'No'
          out_str = String.new
          out_str << "Inference\n#########"
          out_str << "\n:Product: #{@product.name} v#{@product.version}"
          out_str << "\n:Rotation applied: #{is_rotation_applied}"
          out_str << "\n\nPrediction\n=========="
          out_str << "\n#{@prediction.to_s.size > 0 ? @prediction.to_s + "\n" : ""}"
          out_str << "\nPage Predictions\n================\n\n"
          out_str << @pages.map(&:to_s).join("\n\n")
        end
      end
    end
  end
end
