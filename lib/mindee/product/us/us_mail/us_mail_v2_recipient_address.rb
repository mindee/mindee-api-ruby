# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module US
      module UsMail
        # The addresses of the recipients.
        class UsMailV2RecipientAddress < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # The city of the recipient's address.
          # @return [String]
          attr_reader :city
          # The complete address of the recipient.
          # @return [String]
          attr_reader :complete
          # Indicates if the recipient's address is a change of address.
          # @return [Boolean]
          attr_reader :is_address_change
          # The postal code of the recipient's address.
          # @return [String]
          attr_reader :postal_code
          # The private mailbox number of the recipient's address.
          # @return [String]
          attr_reader :private_mailbox_number
          # Second part of the ISO 3166-2 code, consisting of two letters indicating the US State.
          # @return [String]
          attr_reader :state
          # The street of the recipient's address.
          # @return [String]
          attr_reader :street

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super(prediction, page_id)
            @city = prediction['city']
            @complete = prediction['complete']
            @is_address_change = prediction['is_address_change']
            @postal_code = prediction['postal_code']
            @private_mailbox_number = prediction['private_mailbox_number']
            @state = prediction['state']
            @street = prediction['street']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:city] = format_for_display(@city)
            printable[:complete] = format_for_display(@complete)
            printable[:is_address_change] = format_for_display(@is_address_change)
            printable[:postal_code] = format_for_display(@postal_code)
            printable[:private_mailbox_number] = format_for_display(@private_mailbox_number)
            printable[:state] = format_for_display(@state)
            printable[:street] = format_for_display(@street)
            printable
          end

          # @return [Hash]
          def table_printable_values
            printable = {}
            printable[:city] = format_for_display(@city, 15)
            printable[:complete] = format_for_display(@complete, 35)
            printable[:is_address_change] = format_for_display(@is_address_change, nil)
            printable[:postal_code] = format_for_display(@postal_code, nil)
            printable[:private_mailbox_number] = format_for_display(@private_mailbox_number, nil)
            printable[:state] = format_for_display(@state, nil)
            printable[:street] = format_for_display(@street, 25)
            printable
          end

          # @return [String]
          def to_table_line
            printable = table_printable_values
            out_str = String.new
            out_str << format('| %- 16s', printable[:city])
            out_str << format('| %- 36s', printable[:complete])
            out_str << format('| %- 18s', printable[:is_address_change])
            out_str << format('| %- 12s', printable[:postal_code])
            out_str << format('| %- 23s', printable[:private_mailbox_number])
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
            out_str << "\n  :Is Address Change: #{printable[:is_address_change]}"
            out_str << "\n  :Postal Code: #{printable[:postal_code]}"
            out_str << "\n  :Private Mailbox Number: #{printable[:private_mailbox_number]}"
            out_str << "\n  :State: #{printable[:state]}"
            out_str << "\n  :Street: #{printable[:street]}"
            out_str
          end
        end
      end
    end
  end
end
