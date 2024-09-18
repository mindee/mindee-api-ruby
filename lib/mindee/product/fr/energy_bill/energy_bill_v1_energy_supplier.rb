# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module EnergyBill
        # The company that supplies the energy.
        class EnergyBillV1EnergySupplier < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # The address of the energy supplier.
          # @return [String]
          attr_reader :address
          # The name of the energy supplier.
          # @return [String]
          attr_reader :name

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super(prediction, page_id)
            @address = prediction['address']
            @name = prediction['name']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:address] = format_for_display(@address)
            printable[:name] = format_for_display(@name)
            printable
          end

          # @return [String]
          def to_s
            printable = printable_values
            out_str = String.new
            out_str << "\n  :Address: #{printable[:address]}"
            out_str << "\n  :Name: #{printable[:name]}"
            out_str
          end
        end
      end
    end
  end
end
