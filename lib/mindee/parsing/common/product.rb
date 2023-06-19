# frozen_string_literal: true

module Mindee
  module Parsing
    module Common
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
    end
  end
end
