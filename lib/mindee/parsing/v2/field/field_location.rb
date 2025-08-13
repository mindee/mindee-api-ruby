# frozen_string_literal: true

require_relative '../../../geometry/polygon'

module Mindee
  module Parsing
    module V2
      module Field
        # Location of a field.
        class FieldLocation
          # @return [Mindee::Geometry::Polygon, nil] Polygon corresponding to the field location.
          attr_reader :polygon

          # @return [Integer, nil] Page on which the field is located.
          attr_reader :page

          # @param server_response [Hash] Raw server response hash.
          def initialize(server_response)
            polygon_data = server_response['polygon'] || server_response[:polygon]
            @polygon = polygon_data ? Mindee::Geometry::Polygon.new(polygon_data) : nil

            page_id = server_response['page'] || server_response[:page]
            @page = page_id.is_a?(Float) || page_id.is_a?(Integer) ? page_id.to_i : nil
          end

          # String representation of the polygon (empty string when none).
          #
          # @return [String]
          def to_s
            @polygon ? @polygon.to_s : ''
          end
        end
      end
    end
  end
end
