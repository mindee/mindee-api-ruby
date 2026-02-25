# frozen_string_literal: true

module Mindee
  module V2
    module Product
      module Crop
        # Result of a crop utility inference.
        class CropResult
          # @return [Array<Cropitem>] List of results of cropped document regions.
          attr_reader :crops

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            @crops = if server_response.key?('crops')
                       server_response['crop'].map do |crop|
                         CropItem.new(crop)
                       end
                     else
                       []
                     end
          end

          # String representation.
          # @return [String]
          def to_s
            crops_str = @crops.join("\n")

            "Crops\n=====\n#{crops_str}"
          end
        end
      end
    end
  end
end
