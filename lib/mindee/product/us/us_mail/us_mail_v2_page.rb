# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'us_mail_v2_document'

module Mindee
  module Product
    module US
      module UsMail
        # US Mail API version 2.0 page data.
        class UsMailV2Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super(prediction)
            @prediction = UsMailV2PagePrediction.new(
              prediction['prediction'],
              prediction['id']
            )
          end
        end

        # US Mail V2 page prediction.
        class UsMailV2PagePrediction < UsMailV2Document
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
