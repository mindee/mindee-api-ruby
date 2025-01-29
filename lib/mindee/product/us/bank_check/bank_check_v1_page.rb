# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'bank_check_v1_document'

module Mindee
  module Product
    module US
      module BankCheck
        # Bank Check API version 1.1 page data.
        class BankCheckV1Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = if prediction['prediction'].empty?
                            nil
                          else
                            BankCheckV1PagePrediction.new(
                              prediction['prediction'],
                              prediction['id']
                            )
                          end
          end
        end

        # Bank Check V1 page prediction.
        class BankCheckV1PagePrediction < BankCheckV1Document
          include Mindee::Parsing::Standard

          # The position of the check on the document.
          # @return [Mindee::Parsing::Standard::PositionField]
          attr_reader :check_position
          # List of signature positions
          # @return [Array<Mindee::Parsing::Standard::PositionField>]
          attr_reader :signatures_positions

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            @check_position = PositionField.new(prediction['check_position'], page_id)
            @signatures_positions = []
            prediction['signatures_positions'].each do |item|
              @signatures_positions.push(PositionField.new(item, page_id))
            end
            super
          end

          # @return [String]
          def to_s
            signatures_positions = @signatures_positions.join("\n #{' ' * 21}")
            out_str = String.new
            out_str << "\n:Check Position: #{@check_position}".rstrip
            out_str << "\n:Signature Positions: #{signatures_positions}".rstrip
            out_str << "\n#{super}"
            out_str
          end
        end
      end
    end
  end
end
