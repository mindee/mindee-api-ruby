# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module MultiReceiptsDetector
      # Multi Receipts Detector API version 1.0 document data.
      class MultiReceiptsDetectorV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # Positions of the receipts on the document.
        # @return [Array<Mindee::Parsing::Standard::PositionField>]
        attr_reader :receipts

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super()
          @receipts = []
          prediction['receipts'].each do |item|
            @receipts.push(PositionField.new(item, page_id))
          end
        end

        # @return [String]
        def to_s
          receipts = @receipts.join("\n #{' ' * 18}")
          out_str = String.new
          out_str << "\n:List of Receipts: #{receipts}".rstrip
          out_str[1..].to_s
        end
      end
    end
  end
end
