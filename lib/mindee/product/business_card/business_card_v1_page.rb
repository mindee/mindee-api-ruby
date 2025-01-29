# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'business_card_v1_document'

module Mindee
  module Product
    module BusinessCard
      # Business Card API version 1.0 page data.
      class BusinessCardV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = if prediction['prediction'].empty?
                          nil
                        else
                          BusinessCardV1PagePrediction.new(
                            prediction['prediction'],
                            prediction['id']
                          )
                        end
        end
      end

      # Business Card V1 page prediction.
      class BusinessCardV1PagePrediction < BusinessCardV1Document
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
