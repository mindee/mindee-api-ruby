# frozen_string_literal: true

module Mindee
  module Parsing
    module Common
      # Page orientation
      class Orientation
        # @return [Integer]
        attr_reader :page_id
        # A prediction among these 3 possible outputs:
        #   * 0 degrees: the page is already upright
        #   * 90 degrees: the page must be rotated clockwise to be upright
        #   * 270 degrees: the page must be rotated counterclockwise to be upright
        # @return [Integer, nil]
        attr_reader :value

        # @param prediction [Hash]
        # @param page_id [Integer]
        def initialize(prediction, page_id)
          @value = prediction['value']
          @page_id = page_id
        end
      end
    end
  end
end
