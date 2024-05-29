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
            printable[:city] = format_for_display(@city, 15)
            printable[:complete] = format_for_display(@complete, 35)
            printable[:postal_code] = format_for_display(@postal_code, nil)
            printable[:state] = format_for_display(@state, nil)
            printable[:street] = format_for_display(@street, 25)
            printable
          end

          # @return [String]
          def to_table_line
            printable = printable_values
            out_str = String.new
            out_str << format('| %- 16s', printable[:city])
            out_str << format('| %- 36s', printable[:complete])
            out_str << format('| %- 12s', printable[:postal_code])
            out_str << format('| %- 6s', printable[:state])
            out_str << format('| %- 26s', printable[:street])
            out_str << '|'
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
