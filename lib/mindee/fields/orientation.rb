# frozen_string_literal: true

module Mindee
  # Represents page orientation.
  class Orientation
    attr_reader :degrees,
                :confidence,
                :page_id

    def initialize(prediction, page_id)
      @degrees = prediction['degrees']
      @confidence = prediction['confidence']
      @page_id = page_id
    end
  end
end
