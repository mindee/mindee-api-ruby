# frozen_string_literal: true

module Mindee
  module Parsing
    module Common
      # Product information
      class Product
        # @return [String] Name of the product.
        attr_reader :name
        # @return [String?] Type of product.
        attr_reader :type
        # @return [String] Product version.
        attr_reader :version

        # @param prediction [Hash]
        def initialize(prediction)
          @name = prediction['name']
          @type = prediction['type']
          @version = prediction['version']
        end
      end
    end
  end
end
