# frozen_string_literal: true

module Mindee
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
  end

  class ListField
    attr_reader :confidence,
                :values,
                :page_id,
                :constructed

    def initialize(prediction, page_id, constructed: false)
      @values = []
      @confidence = prediction['confidence']
      @page_id = page_id
      @constructed = constructed

      prediction['values'].each do |field|
        @values.push(ListFieldItem.new(field))
      end
    end

    def to_s
      @values.map(&:content).join(' ')
    end
  end
end
