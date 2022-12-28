# frozen_string_literal: true

require_relative 'page'

module Mindee
  # Product information
  class Product
    attr_reader :name, :type, :version

    # @param http_response [Hash]
    def initialize(http_response)
      @name = http_response['name']
      @type = http_response['type']
      @version = http_response['version']
    end
  end

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

    # @param prediction_class [Class<Mindee::Prediction>]
    # @param http_response [Hash]
    def initialize(prediction_class, http_response)
      @is_rotation_applied = http_response['is_rotation_applied']
      @prediction = prediction_class.new(http_response['prediction'], nil)
      @product = Product.new(http_response['product'])
      @pages = []
      http_response['pages'].each do |page|
        @pages.push(Page.new(prediction_class, page))
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
