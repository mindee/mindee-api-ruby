# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'health_card_v1_document'

module Mindee
  module Product
    module FR
      module HealthCard
        # Health Card API version 1.0 page data.
        class HealthCardV1Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = HealthCardV1PagePrediction.new(
              prediction['prediction'],
              prediction['id']
            )
          end
        end

        # Health Card V1 page prediction.
        class HealthCardV1PagePrediction < HealthCardV1Document
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
end
