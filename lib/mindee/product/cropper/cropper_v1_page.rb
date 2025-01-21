# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'cropper_v1_document'

module Mindee
  module Product
    module Cropper
      # Cropper API version 1.1 page data.
      class CropperV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = CropperV1PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # Cropper V1 page prediction.
      class CropperV1PagePrediction < CropperV1Document
        include Mindee::Parsing::Standard

        # List of documents found in the image.
        # @return [Array<Mindee::Parsing::Standard::PositionField>]
        attr_reader :cropping

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          @cropping = []
          prediction['cropping'].each do |item|
            @cropping.push(PositionField.new(item, page_id))
          end
          super()
        end

        # @return [String]
        def to_s
          cropping = @cropping.join("\n #{' ' * 18}")
          out_str = String.new
          out_str << "\n:Document Cropper: #{cropping}".rstrip
          out_str
        end
      end
    end
  end
end
