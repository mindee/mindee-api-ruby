# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'international_id_v2_document'

module Mindee
  module Product
    module InternationalId
      # International ID API version 2.1 page data.
      class InternationalIdV2Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = if prediction['prediction'].empty?
                          {}
                        else
                          InternationalIdV2PagePrediction.new(
                            prediction['prediction'],
                            prediction['id']
                          )
                        end
        end
      end

      # International ID V2 page prediction.
      class InternationalIdV2PagePrediction < InternationalIdV2Document
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
