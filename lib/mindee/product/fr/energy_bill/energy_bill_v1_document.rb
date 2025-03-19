# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'energy_bill_v1_energy_supplier'
require_relative 'energy_bill_v1_energy_consumer'
require_relative 'energy_bill_v1_subscriptions'
require_relative 'energy_bill_v1_energy_usages'
require_relative 'energy_bill_v1_taxes_and_contributions'
require_relative 'energy_bill_v1_meter_detail'

module Mindee
  module Product
    module FR
      module EnergyBill
        # Energy Bill API version 1.2 document data.
        class EnergyBillV1Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Standard
          # The unique identifier associated with a specific contract.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :contract_id
          # The unique identifier assigned to each electricity or gas consumption point. It specifies the exact
          # location where the energy is delivered.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :delivery_point
          # The date by which the payment for the energy invoice is due.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :due_date
          # The entity that consumes the energy.
          # @return [Mindee::Product::FR::EnergyBill::EnergyBillV1EnergyConsumer]
          attr_reader :energy_consumer
          # The company that supplies the energy.
          # @return [Mindee::Product::FR::EnergyBill::EnergyBillV1EnergySupplier]
          attr_reader :energy_supplier
          # Details of energy consumption.
          # @return [Mindee::Product::FR::EnergyBill::EnergyBillV1EnergyUsages]
          attr_reader :energy_usage
          # The date when the energy invoice was issued.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :invoice_date
          # The unique identifier of the energy invoice.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :invoice_number
          # Information about the energy meter.
          # @return [Mindee::Product::FR::EnergyBill::EnergyBillV1MeterDetail]
          attr_reader :meter_details
          # The subscription details fee for the energy service.
          # @return [Mindee::Product::FR::EnergyBill::EnergyBillV1Subscriptions]
          attr_reader :subscription
          # Details of Taxes and Contributions.
          # @return [Mindee::Product::FR::EnergyBill::EnergyBillV1TaxesAndContributions]
          attr_reader :taxes_and_contributions
          # The total amount to be paid for the energy invoice.
          # @return [Mindee::Parsing::Standard::AmountField]
          attr_reader :total_amount
          # The total amount to be paid for the energy invoice before taxes.
          # @return [Mindee::Parsing::Standard::AmountField]
          attr_reader :total_before_taxes
          # Total of taxes applied to the invoice.
          # @return [Mindee::Parsing::Standard::AmountField]
          attr_reader :total_taxes

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super
            @contract_id = Parsing::Standard::StringField.new(
              prediction['contract_id'],
              page_id
            )
            @delivery_point = Parsing::Standard::StringField.new(
              prediction['delivery_point'],
              page_id
            )
            @due_date = Parsing::Standard::DateField.new(
              prediction['due_date'],
              page_id
            )
            @energy_consumer = Product::FR::EnergyBill::EnergyBillV1EnergyConsumer.new(
              prediction['energy_consumer'],
              page_id
            )
            @energy_supplier = Product::FR::EnergyBill::EnergyBillV1EnergySupplier.new(
              prediction['energy_supplier'],
              page_id
            )
            @energy_usage = Product::FR::EnergyBill::EnergyBillV1EnergyUsages.new(prediction['energy_usage'], page_id)
            @invoice_date = Parsing::Standard::DateField.new(
              prediction['invoice_date'],
              page_id
            )
            @invoice_number = Parsing::Standard::StringField.new(
              prediction['invoice_number'],
              page_id
            )
            @meter_details = Product::FR::EnergyBill::EnergyBillV1MeterDetail.new(
              prediction['meter_details'],
              page_id
            )
            @subscription = Product::FR::EnergyBill::EnergyBillV1Subscriptions.new(prediction['subscription'], page_id)
            @taxes_and_contributions = Product::FR::EnergyBill::EnergyBillV1TaxesAndContributions.new(
              prediction['taxes_and_contributions'], page_id
            )
            @total_amount = Parsing::Standard::AmountField.new(
              prediction['total_amount'],
              page_id
            )
            @total_before_taxes = Parsing::Standard::AmountField.new(
              prediction['total_before_taxes'],
              page_id
            )
            @total_taxes = Parsing::Standard::AmountField.new(
              prediction['total_taxes'],
              page_id
            )
          end

          # @return [String]
          def to_s
            energy_supplier = @energy_supplier.to_s
            energy_consumer = @energy_consumer.to_s
            subscription = subscription_to_s
            energy_usage = energy_usage_to_s
            taxes_and_contributions = taxes_and_contributions_to_s
            meter_details = @meter_details.to_s
            out_str = String.new
            out_str << "\n:Invoice Number: #{@invoice_number}".rstrip
            out_str << "\n:Contract ID: #{@contract_id}".rstrip
            out_str << "\n:Delivery Point: #{@delivery_point}".rstrip
            out_str << "\n:Invoice Date: #{@invoice_date}".rstrip
            out_str << "\n:Due Date: #{@due_date}".rstrip
            out_str << "\n:Total Before Taxes: #{@total_before_taxes}".rstrip
            out_str << "\n:Total Taxes: #{@total_taxes}".rstrip
            out_str << "\n:Total Amount: #{@total_amount}".rstrip
            out_str << "\n:Energy Supplier:"
            out_str << energy_supplier
            out_str << "\n:Energy Consumer:"
            out_str << energy_consumer
            out_str << "\n:Subscription:"
            out_str << subscription
            out_str << "\n:Energy Usage:"
            out_str << energy_usage
            out_str << "\n:Taxes and Contributions:"
            out_str << taxes_and_contributions
            out_str << "\n:Meter Details:"
            out_str << meter_details
            out_str[1..].to_s
          end

          private

          # @param char [String]
          # @return [String]
          def subscription_separator(char)
            out_str = String.new
            out_str << '  '
            out_str << "+#{char * 38}"
            out_str << "+#{char * 12}"
            out_str << "+#{char * 12}"
            out_str << "+#{char * 10}"
            out_str << "+#{char * 11}"
            out_str << "+#{char * 12}"
            out_str << '+'
            out_str
          end

          # @return [String]
          def subscription_to_s
            return '' if @subscription.empty?

            line_items = @subscription.map(&:to_table_line).join("\n#{subscription_separator('-')}\n  ")
            out_str = String.new
            out_str << "\n#{subscription_separator('-')}"
            out_str << "\n  |"
            out_str << ' Description                          |'
            out_str << ' End Date   |'
            out_str << ' Start Date |'
            out_str << ' Tax Rate |'
            out_str << ' Total     |'
            out_str << ' Unit Price |'
            out_str << "\n#{subscription_separator('=')}"
            out_str << "\n  #{line_items}"
            out_str << "\n#{subscription_separator('-')}"
            out_str
          end

          # @param char [String]
          # @return [String]
          def energy_usage_separator(char)
            out_str = String.new
            out_str << '  '
            out_str << "+#{char * 13}"
            out_str << "+#{char * 38}"
            out_str << "+#{char * 12}"
            out_str << "+#{char * 12}"
            out_str << "+#{char * 10}"
            out_str << "+#{char * 11}"
            out_str << "+#{char * 17}"
            out_str << "+#{char * 12}"
            out_str << '+'
            out_str
          end

          # @return [String]
          def energy_usage_to_s
            return '' if @energy_usage.empty?

            line_items = @energy_usage.map(&:to_table_line).join("\n#{energy_usage_separator('-')}\n  ")
            out_str = String.new
            out_str << "\n#{energy_usage_separator('-')}"
            out_str << "\n  |"
            out_str << ' Consumption |'
            out_str << ' Description                          |'
            out_str << ' End Date   |'
            out_str << ' Start Date |'
            out_str << ' Tax Rate |'
            out_str << ' Total     |'
            out_str << ' Unit of Measure |'
            out_str << ' Unit Price |'
            out_str << "\n#{energy_usage_separator('=')}"
            out_str << "\n  #{line_items}"
            out_str << "\n#{energy_usage_separator('-')}"
            out_str
          end

          # @param char [String]
          # @return [String]
          def taxes_and_contributions_separator(char)
            out_str = String.new
            out_str << '  '
            out_str << "+#{char * 38}"
            out_str << "+#{char * 12}"
            out_str << "+#{char * 12}"
            out_str << "+#{char * 10}"
            out_str << "+#{char * 11}"
            out_str << "+#{char * 12}"
            out_str << '+'
            out_str
          end

          # @return [String]
          def taxes_and_contributions_to_s
            return '' if @taxes_and_contributions.empty?

            line_items = @taxes_and_contributions.map(&:to_table_line).join(
              "\n#{taxes_and_contributions_separator('-')}\n  "
            )
            out_str = String.new
            out_str << "\n#{taxes_and_contributions_separator('-')}"
            out_str << "\n  |"
            out_str << ' Description                          |'
            out_str << ' End Date   |'
            out_str << ' Start Date |'
            out_str << ' Tax Rate |'
            out_str << ' Total     |'
            out_str << ' Unit Price |'
            out_str << "\n#{taxes_and_contributions_separator('=')}"
            out_str << "\n  #{line_items}"
            out_str << "\n#{taxes_and_contributions_separator('-')}"
            out_str
          end
        end
      end
    end
  end
end
