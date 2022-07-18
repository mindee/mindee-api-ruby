# frozen_string_literal: true

module Mindee
  # Represents page orientation.
  class Orientation
    # @return [Integer]
    attr_reader :page_id
    # The confidence score, value will be between 0.0 and 1.0
    # @return [Float]
    attr_reader :confidence
    # A prediction among these 3 possible outputs:
    #   * 0 degrees: the page is already upright
    #   * 90 degrees: the page must be rotated clockwise to be upright
    #   * 270 degrees: the page must be rotated counterclockwise to be upright
    # @return [Integer]
    attr_reader :degrees

    # @param prediction [Hash]
    # @param page_id [Integer]
    def initialize(prediction, page_id)
      @degrees = prediction['degrees']
      @confidence = prediction['confidence']
      @page_id = page_id
    end
  end
end
