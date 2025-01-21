# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module BillOfLading
      # The party to be notified of the arrival of the goods.
      class BillOfLadingV1NotifyParty < Mindee::Parsing::Standard::FeatureField
        include Mindee::Parsing::Standard
        # The address of the notify party.
        # @return [String]
        attr_reader :address
        # The  email of the shipper.
        # @return [String]
        attr_reader :email
        # The name of the notify party.
        # @return [String]
        attr_reader :name
        # The phone number of the notify party.
        # @return [String]
        attr_reader :phone

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @address = prediction['address']
          @email = prediction['email']
          @name = prediction['name']
          @phone = prediction['phone']
          @page_id = page_id
        end

        # @return [Hash]
        def printable_values
          printable = {}
          printable[:address] = format_for_display(@address)
          printable[:email] = format_for_display(@email)
          printable[:name] = format_for_display(@name)
          printable[:phone] = format_for_display(@phone)
          printable
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
