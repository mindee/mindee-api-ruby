# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'us_mail_v3_document'

module Mindee
  module Product
    module US
      module UsMail
        # US Mail API version 3.0 page data.
        class UsMailV3Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super(prediction)
            @prediction = UsMailV3PagePrediction.new(
              prediction['prediction'],
              prediction['id']
            )
          end
        end

        # US Mail V3 page prediction.
        class UsMailV3PagePrediction < UsMailV3Document
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
