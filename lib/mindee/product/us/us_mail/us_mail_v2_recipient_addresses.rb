# frozen_string_literal: true

require_relative 'us_mail_v2_sender_address'
require_relative 'us_mail_v2_recipient_address'

module Mindee
  module Product
    module US
      module UsMail
        # The addresses of the recipients.
        class UsMailV2RecipientAddresses < Array
          # Entries.
          # @return [Array<UsMailV2RecipientAddress>]
          attr_reader :entries

          # @param prediction [Array]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            entries = prediction.map do |entry|
              UsMail::UsMailV2RecipientAddress.new(entry, page_id)
            end
            super(entries)
          end

          # Creates a line of rST table-compliant string separators.
          # @param char [String] Character to use as a separator.
          # @return [String]
          def self.line_items_separator(char)
            out_str = String.new
            out_str << "+#{char * 17}"
            out_str << "+#{char * 37}"
            out_str << "+#{char * 19}"
            out_str << "+#{char * 13}"
            out_str << "+#{char * 24}"
            out_str << "+#{char * 7}"
            out_str << "+#{char * 27}"
            out_str
          end

          # @return [String]
          def to_s
            return '' if empty?

            lines = map do |entry|
              "\n  #{entry.to_table_line}\n#{self.class.line_items_separator('-')}"
            end.join
            out_str = String.new
            out_str << ("\n#{self.class.line_items_separator('-')}\n ")
            out_str << ' | City           '
            out_str << ' | Complete Address                   '
            out_str << ' | Is Address Change'
            out_str << ' | Postal Code'
            out_str << ' | Private Mailbox Number'
            out_str << ' | State'
            out_str << ' | Street                   '
            out_str << (" |\n#{self.class.line_items_separator('=')}")
            out_str + lines
          end
        end
      end
    end
  end
end
