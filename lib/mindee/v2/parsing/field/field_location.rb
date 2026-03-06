# frozen_string_literal: true

require_relative '../../../geometry/polygon'

module Mindee
  module V2
    module Parsing
      module Field
        # Location of a field.
        class FieldLocation
          # @return [Mindee::Geometry::Polygon, nil] Polygon corresponding to the field location.
          attr_reader :polygon

          # @return [Integer, nil] Page on which the field is located.
          attr_reader :page

          # @param server_response [Hash] Raw server response hash.
          def initialize(server_response)
            @polygon = Mindee::Geometry::Polygon.new(server_response['polygon'])
            @page = server_response['page']
          end

          # String representation of the polygon (empty string when none).
          #
          # @return [String]
          def to_s
            "#{polygon} on page #{page}"
          end
        end
      end
    end
  end
end
