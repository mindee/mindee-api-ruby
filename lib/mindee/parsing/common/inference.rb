# frozen_string_literal: true

require_relative 'page'
require_relative 'product'

module Mindee
  module Parsing
    module Common
      # Inference holds all predictions
      class Inference
        # @return [Boolean]
        attr_reader :is_rotation_applied
        # @return [Array<Mindee::Page>]
        attr_reader :pages
        # @return [Mindee::Prediction]
        attr_reader :prediction
        # @return [Mindee::Product]
        attr_reader :product

        # @param product_class [Class<Mindee::Product>]
        # @param http_response [Hash]
        def initialize(product_class, http_response)
          @is_rotation_applied = http_response['is_rotation_applied']
          @prediction = product_class.new(http_response['prediction'], nil)
          @product = Product.new(http_response['product'])
          @pages = []
          http_response['pages'].each do |page|
            @pages.push(Page.new(product_class, page))
          end
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
  class Inference < Mindee::Parsing::Common::Inference
  end
end
