# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module US
      module UsMail
        # The address of the sender.
        class UsMailV2SenderAddress < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # The city of the sender's address.
          # @return [String]
          attr_reader :city
          # The complete address of the sender.
          # @return [String]
          attr_reader :complete
          # The postal code of the sender's address.
          # @return [String]
          attr_reader :postal_code
          # Second part of the ISO 3166-2 code, consisting of two letters indicating the US State.
          # @return [String]
          attr_reader :state
          # The street of the sender's address.
          # @return [String]
          attr_reader :street

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super(prediction, page_id)
            @city = prediction['city']
            @complete = prediction['complete']
            @postal_code = prediction['postal_code']
            @state = prediction['state']
            @street = prediction['street']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:city] = format_for_display(@city)
            printable[:complete] = format_for_display(@complete)
            printable[:postal_code] = format_for_display(@postal_code)
            printable[:state] = format_for_display(@state)
            printable[:street] = format_for_display(@street)
            printable
          end

          # @return [String]
          def to_s
            printable = printable_values
            out_str = String.new
            out_str << "\n  :City: #{printable[:city]}"
            out_str << "\n  :Complete Address: #{printable[:complete]}"
            out_str << "\n  :Postal Code: #{printable[:postal_code]}"
            out_str << "\n  :State: #{printable[:state]}"
            out_str << "\n  :Street: #{printable[:street]}"
            out_str
          end
        end
      end
    end
  end
end
