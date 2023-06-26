# frozen_string_literal: true

require_relative 'product'

module Mindee
  module Parsing
    module Common
      # Abstract class for prediction Inferences
      # Holds prediction for a page or entire document.
      class Inference
        # @return [Boolean]
        attr_reader :is_rotation_applied
        # @return [Array<Mindee::Parsing::Common::Prediction>]
        attr_reader :pages
        # @return [Mindee::Parsing::Common::Prediction]
        attr_reader :prediction
        # @return [Mindee::Parsing::Common::Product]
        attr_reader :product

        # @param http_response [Hash]
        def initialize(http_response)
          @is_rotation_applied = http_response['is_rotation_applied']
          @product = Product.new(http_response['product'])
          @pages = []
        end

        def to_s
          is_rotation_applied = @is_rotation_applied ? 'Yes' : 'No'
          out_str = String.new
          out_str << "Inference\n#########"
          out_str << "\n:Product: #{@product.name} v#{@product.version}"
          out_str << "\n:Rotation applied: #{is_rotation_applied}"
          out_str << "\n\nPrediction\n=========="
          out_str << "\n#{@prediction}"
          out_str << "\n\nPage Predictions\n================\n\n"
          out_str << @pages.map(&:to_s).join("\n\n")
        end
      end
    end
  end
end
