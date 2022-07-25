# frozen_string_literal: true

module Mindee
  # Field in a list.
  class ListFieldItem
    attr_reader :confidence,
                :content,
                :polygon,
                :bbox

    # @param prediction [Hash]
    def initialize(prediction)
      @content = prediction['content']
      @confidence = prediction['confidence']
      @polygon = prediction['polygon']
      @bbox = Geometry.get_bbox_as_polygon(@polygon) unless @polygon.nil? || @polygon.empty?
    end

    # @return [String]
    def to_s
      @content.to_s
    end
  end

  # Field where actual values are kept in a list (custom docs).
  class ListField
    # @return [Array<Mindee::ListFieldItem>]
    attr_reader :values
    # @return [Integer, nil]
    attr_reader :page_id
    # true if the field was reconstructed or computed using other fields.
    # @return [Boolean]
    attr_reader :reconstructed
    # The confidence score, value will be between 0.0 and 1.0
    # @return [Float]
    attr_accessor :confidence

    # @param prediction [Hash]
    # @param page_id [Integer, nil]
    # @param reconstructed [Boolean]
    def initialize(prediction, page_id, reconstructed: false)
      @values = []
      @confidence = prediction['confidence']
      @page_id = page_id || prediction['page_id']
      @reconstructed = reconstructed

      prediction['values'].each do |field|
        @values.push(ListFieldItem.new(field))
      end
    end

    # @return [Array]
    def contents_list
      @values.map(&:content)
    end

    # @return [String]
    def contents_str(separator: ' ')
      @values.map(&:to_s).join(separator)
    end

    # @return [String]
    def to_s
      contents_str(separator: ' ')
    end
  end
end
