# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module Cropper
      # Cropper V1 document prediction.
      class CropperV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super()
        end
      end
    end
  end
end
