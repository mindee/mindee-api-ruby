# frozen_string_literal: true

module Mindee
  # Field in a list.
  class ListFieldItem
    attr_reader :confidence,
                :content,
                :polygon,
                :bbox

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
    attr_reader :confidence,
                :values,
                :page_id,
                :reconstructed

    def initialize(prediction, page_id, reconstructed: false)
      @values = []
      @confidence = prediction['confidence']
      @page_id = page_id
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
