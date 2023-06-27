# frozen_string_literal: true

module Mindee
  module Parsing
    module Common
      # Product information
      class Product
        attr_reader :name, :type, :version

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
