# frozen_string_literal: true

module Mindee
  module Custom
    # Field in a list.
    class ListFieldItem
      # The confidence score, value will be between 0.0 and 1.0
      # @return [Float]
      attr_accessor :confidence
      # @return [Mindee::Geometry::Quadrilateral]
      attr_reader :bounding_box
      # @return [Mindee::Geometry::Polygon]
      attr_reader :polygon
      attr_reader :content

      # @param prediction [Hash]
      def initialize(prediction)
        @content = prediction['content']
        @confidence = prediction['confidence']
        @polygon = Geometry.polygon_from_prediction(prediction['polygon'])
        @bounding_box = Geometry.get_bounding_box(@polygon) unless @polygon.nil? || @polygon.empty?
      end

      # @return [String]
      def to_s
        @content.to_s
      end
    end

    # Field in a list.
    class ListFieldItem
      # The confidence score, value will be between 0.0 and 1.0
      # @return [Float]
      attr_accessor :confidence
      # @return [Mindee::Geometry::Quadrilateral]
      attr_reader :bounding_box
      # @return [Mindee::Geometry::Polygon]
      attr_reader :polygon
      attr_reader :content

      # @param prediction [Hash]
      def initialize(prediction)
        @content = prediction['content']
        @confidence = prediction['confidence']
        @polygon = Geometry.polygon_from_prediction(prediction['polygon'])
        @bounding_box = Geometry.get_bounding_box(@polygon) unless @polygon.nil? || @polygon.empty?
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
end
