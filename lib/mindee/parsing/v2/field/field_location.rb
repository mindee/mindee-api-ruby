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
            @polygon = Mindee::Geometry::Polygon.new(server_response['polygon'])
            @page = server_response['page']
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
