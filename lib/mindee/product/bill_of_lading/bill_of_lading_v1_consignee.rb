# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module BillOfLading
      # The party to whom the goods are being shipped.
      class BillOfLadingV1Consignee < Mindee::Parsing::Standard::FeatureField
        include Mindee::Parsing::Standard
        # The address of the consignee.
        # @return [String]
        attr_reader :address
        # The  email of the shipper.
        # @return [String]
        attr_reader :email
        # The name of the consignee.
        # @return [String]
        attr_reader :name
        # The phone number of the consignee.
        # @return [String]
        attr_reader :phone

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super(prediction, page_id)
          @address = prediction['address']
          @email = prediction['email']
          @name = prediction['name']
          @phone = prediction['phone']
          @page_id = page_id
        end

        # @return [Hash]
        def printable_values
          printable = {}
          printable[:address] = format_for_display(@address, nil)
          printable[:email] = format_for_display(@email, nil)
          printable[:name] = format_for_display(@name, nil)
          printable[:phone] = format_for_display(@phone, nil)
          printable
        end

        # @return [String]
        def to_table_line
          printable = printable_values
          out_str = String.new
          out_str << format('| %- 8s', printable[:address])
          out_str << format('| %- 6s', printable[:email])
          out_str << format('| %- 5s', printable[:name])
          out_str << format('| %- 6s', printable[:phone])
          out_str << '|'
        end

        # @return [String]
        def to_s
          printable = printable_values
          out_str = String.new
          out_str << "\n  :Address: #{printable[:address]}"
          out_str << "\n  :Email: #{printable[:email]}"
          out_str << "\n  :Name: #{printable[:name]}"
          out_str << "\n  :Phone: #{printable[:phone]}"
          out_str
        end
      end
    end
  end
end
