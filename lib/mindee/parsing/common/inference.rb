# frozen_string_literal: true

require_relative 'product'

module Mindee
  module Parsing
    # Common fields used for most documents.
    module Common
      # Abstract class for prediction Inferences
      # Holds prediction for a page or entire document.
      class Inference
        # @return [bool]
        attr_reader :is_rotation_applied
        # @return [Array<Mindee::Parsing::Common::Page>]
        attr_reader :pages
        # @return [Mindee::Parsing::Common::Prediction]
        attr_reader :prediction
        # @return [Mindee::Parsing::Common::Product]
        attr_reader :product
        # Name of the endpoint for this product.
        # @return [String]
        attr_reader :endpoint_name
        # Version for this product.
        # @return [String]
        attr_reader :endpoint_version
        # Whether this product has access to an asynchronous endpoint.
        # @return [bool]
        attr_reader :has_async
        # Whether this product has access to synchronous endpoint.
        # @return [bool]
        attr_reader :has_sync

        @endpoint_name = nil
        @endpoint_version = nil
        @has_async = false
        @has_sync = false

        # @param raw_prediction [Hash]
        def initialize(raw_prediction)
          @is_rotation_applied = raw_prediction['is_rotation_applied']
          @product = Product.new(raw_prediction['product'])
          @pages = [] # : Array[Page]
        end

        # @return [String]
        def to_s
          is_rotation_applied = @is_rotation_applied ? 'Yes' : 'No'
          out_str = String.new
          out_str << "Inference\n#########"
          out_str << "\n:Product: #{@product.name} v#{@product.version}"
          out_str << "\n:Rotation applied: #{is_rotation_applied}"
          out_str << "\n\nPrediction\n=========="
          out_str << "\n#{@prediction.to_s.size.positive? ? "#{@prediction}\n" : ''}"
          if @pages.any? { |page| !page.prediction.nil? }
            out_str << "\nPage Predictions\n================\n\n"
            out_str << @pages.map(&:to_s).join("\n\n")
          end
          out_str.rstrip!
          out_str
        end
      end
    end
  end
end
