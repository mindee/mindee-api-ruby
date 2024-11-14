# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'delivery_note_v1_document'

module Mindee
  module Product
    module DeliveryNote
      # Delivery note API version 1.1 page data.
      class DeliveryNoteV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super(prediction)
          @prediction = DeliveryNoteV1PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # Delivery note V1 page prediction.
      class DeliveryNoteV1PagePrediction < DeliveryNoteV1Document
        # @return [String]
        def to_s
          out_str = String.new
          out_str << "\n#{super}"
          out_str
        end
      end
    end
  end
end
