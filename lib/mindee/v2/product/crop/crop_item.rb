# frozen_string_literal: true

module Mindee
  module V2
    module Product
      module Crop
        # Result of a cropped document region.
        class CropItem
          # @return [String] Type or classification of the detected object.
          attr_reader :object_type
          # @return [Parsing::V2::Field::FieldLocation] Coordinates of the detected object on the document.
          attr_reader :location

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            @object_type = server_response['object_type']
            @location = Mindee::Parsing::V2::Field::FieldLocation.new(server_response['location'])
          end

          # String representation.
          # @return [String]
          def to_s
            "* :Location: #{location}\n  :Object Type: #{object_type}"
          end
        end
      end
    end
  end
end
