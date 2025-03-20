# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module DeliveryNote
      # Delivery note API version 1.2 document data.
      class DeliveryNoteV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # The address of the customer receiving the goods.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :customer_address
        # The name of the customer receiving the goods.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :customer_name
        # The date on which the delivery is scheduled to arrive.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :delivery_date
        # A unique identifier for the delivery note.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :delivery_number
        # The address of the supplier providing the goods.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :supplier_address
        # The name of the supplier providing the goods.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :supplier_name
        # The total monetary value of the goods being delivered.
        # @return [Mindee::Parsing::Standard::AmountField]
        attr_reader :total_amount

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @customer_address = Parsing::Standard::StringField.new(
            prediction['customer_address'],
            page_id
          )
          @customer_name = Parsing::Standard::StringField.new(
            prediction['customer_name'],
            page_id
          )
          @delivery_date = Parsing::Standard::DateField.new(
            prediction['delivery_date'],
            page_id
          )
          @delivery_number = Parsing::Standard::StringField.new(
            prediction['delivery_number'],
            page_id
          )
          @supplier_address = Parsing::Standard::StringField.new(
            prediction['supplier_address'],
            page_id
          )
          @supplier_name = Parsing::Standard::StringField.new(
            prediction['supplier_name'],
            page_id
          )
          @total_amount = Parsing::Standard::AmountField.new(
            prediction['total_amount'],
            page_id
          )
        end

        # @return [String]
        def to_s
          out_str = String.new
          out_str << "\n:Delivery Date: #{@delivery_date}".rstrip
          out_str << "\n:Delivery Number: #{@delivery_number}".rstrip
          out_str << "\n:Supplier Name: #{@supplier_name}".rstrip
          out_str << "\n:Supplier Address: #{@supplier_address}".rstrip
          out_str << "\n:Customer Name: #{@customer_name}".rstrip
          out_str << "\n:Customer Address: #{@customer_address}".rstrip
          out_str << "\n:Total Amount: #{@total_amount}".rstrip
          out_str[1..].to_s
        end
      end
    end
  end
end
