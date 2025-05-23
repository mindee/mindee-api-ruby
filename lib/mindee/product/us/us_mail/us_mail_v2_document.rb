# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'us_mail_v2_sender_address'
require_relative 'us_mail_v2_recipient_addresses'

module Mindee
  module Product
    module US
      module UsMail
        # US Mail API version 2.0 document data.
        class UsMailV2Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Standard
          # The addresses of the recipients.
          # @return [Mindee::Product::US::UsMail::UsMailV2RecipientAddresses]
          attr_reader :recipient_addresses
          # The names of the recipients.
          # @return [Array<Mindee::Parsing::Standard::StringField>]
          attr_reader :recipient_names
          # The address of the sender.
          # @return [Mindee::Product::US::UsMail::UsMailV2SenderAddress]
          attr_reader :sender_address
          # The name of the sender.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :sender_name

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super
            @recipient_addresses = Product::US::UsMail::UsMailV2RecipientAddresses.new(
              prediction['recipient_addresses'], page_id
            )
            @recipient_names = [] # : Array[Parsing::Standard::StringField]
            prediction['recipient_names'].each do |item|
              @recipient_names.push(Parsing::Standard::StringField.new(item, page_id))
            end
            @sender_address = Product::US::UsMail::UsMailV2SenderAddress.new(
              prediction['sender_address'],
              page_id
            )
            @sender_name = Parsing::Standard::StringField.new(
              prediction['sender_name'],
              page_id
            )
          end

          # @return [String]
          def to_s
            sender_address = @sender_address.to_s
            recipient_names = @recipient_names.join("\n #{' ' * 17}")
            recipient_addresses = recipient_addresses_to_s
            out_str = String.new
            out_str << "\n:Sender Name: #{@sender_name}".rstrip
            out_str << "\n:Sender Address:"
            out_str << sender_address
            out_str << "\n:Recipient Names: #{recipient_names}".rstrip
            out_str << "\n:Recipient Addresses:"
            out_str << recipient_addresses
            out_str[1..].to_s
          end

          private

          # @param char [String]
          # @return [String]
          def recipient_addresses_separator(char)
            out_str = String.new
            out_str << '  '
            out_str << "+#{char * 17}"
            out_str << "+#{char * 37}"
            out_str << "+#{char * 19}"
            out_str << "+#{char * 13}"
            out_str << "+#{char * 24}"
            out_str << "+#{char * 7}"
            out_str << "+#{char * 27}"
            out_str << '+'
            out_str
          end

          # @return [String]
          def recipient_addresses_to_s
            return '' if @recipient_addresses.empty?

            line_items = @recipient_addresses.map(&:to_table_line).join("\n#{recipient_addresses_separator('-')}\n  ")
            out_str = String.new
            out_str << "\n#{recipient_addresses_separator('-')}"
            out_str << "\n  |"
            out_str << ' City            |'
            out_str << ' Complete Address                    |'
            out_str << ' Is Address Change |'
            out_str << ' Postal Code |'
            out_str << ' Private Mailbox Number |'
            out_str << ' State |'
            out_str << ' Street                    |'
            out_str << "\n#{recipient_addresses_separator('=')}"
            out_str << "\n  #{line_items}"
            out_str << "\n#{recipient_addresses_separator('-')}"
            out_str
          end
        end
      end
    end
  end
end
