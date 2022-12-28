# frozen_string_literal: true

module Mindee
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

  # Page object
  class Page
    # @return [Integer]
    attr_reader :id
    # @return [Mindee::Prediction]
    attr_reader :prediction
    # @return [Mindee::Orientation]
    attr_reader :orientation

    def initialize(prediction_class, page)
      @id = page['id'].to_i
      @prediction = prediction_class.new(page['prediction'], @id)
      @orientation = Orientation.new(page['orientation'], @id)
    end

    def to_s
      out_str = String.new
      title = "Page #{@id}"
      out_str << "#{title}\n"
      out_str << ('-' * title.size)
      out_str << "\n#{@prediction}"
    end
  end
end
