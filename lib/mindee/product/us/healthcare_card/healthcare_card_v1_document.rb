# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'healthcare_card_v1_copays'

module Mindee
  module Product
    module US
      module HealthcareCard
        # Healthcare Card API version 1.2 document data.
        class HealthcareCardV1Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Standard
          # The name of the company that provides the healthcare plan.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :company_name
          # Is a fixed amount for a covered service.
          # @return [Mindee::Product::US::HealthcareCard::HealthcareCardV1Copays]
          attr_reader :copays
          # The list of dependents covered by the healthcare plan.
          # @return [Array<Mindee::Parsing::Standard::StringField>]
          attr_reader :dependents
          # The date when the member enrolled in the healthcare plan.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :enrollment_date
          # The group number associated with the healthcare plan.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :group_number
          # The organization that issued the healthcare plan.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :issuer80840
          # The unique identifier for the member in the healthcare system.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :member_id
          # The name of the member covered by the healthcare plan.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :member_name
          # The unique identifier for the payer in the healthcare system.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :payer_id
          # The BIN number for prescription drug coverage.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :rx_bin
          # The group number for prescription drug coverage.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :rx_grp
          # The ID number for prescription drug coverage.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :rx_id
          # The PCN number for prescription drug coverage.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :rx_pcn

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super
            @company_name = Parsing::Standard::StringField.new(
              prediction['company_name'],
              page_id
            )
            @copays = Product::US::HealthcareCard::HealthcareCardV1Copays.new(prediction['copays'], page_id)
            @dependents = [] # : Array[Parsing::Standard::StringField]
            prediction['dependents'].each do |item|
              @dependents.push(Parsing::Standard::StringField.new(item, page_id))
            end
            @enrollment_date = Parsing::Standard::DateField.new(
              prediction['enrollment_date'],
              page_id
            )
            @group_number = Parsing::Standard::StringField.new(
              prediction['group_number'],
              page_id
            )
            @issuer80840 = Parsing::Standard::StringField.new(
              prediction['issuer_80840'],
              page_id
            )
            @member_id = Parsing::Standard::StringField.new(
              prediction['member_id'],
              page_id
            )
            @member_name = Parsing::Standard::StringField.new(
              prediction['member_name'],
              page_id
            )
            @payer_id = Parsing::Standard::StringField.new(
              prediction['payer_id'],
              page_id
            )
            @rx_bin = Parsing::Standard::StringField.new(
              prediction['rx_bin'],
              page_id
            )
            @rx_grp = Parsing::Standard::StringField.new(
              prediction['rx_grp'],
              page_id
            )
            @rx_id = Parsing::Standard::StringField.new(prediction['rx_id'], page_id)
            @rx_pcn = Parsing::Standard::StringField.new(
              prediction['rx_pcn'],
              page_id
            )
          end

          # @return [String]
          def to_s
            dependents = @dependents.join("\n #{' ' * 12}")
            copays = copays_to_s
            out_str = String.new
            out_str << "\n:Company Name: #{@company_name}".rstrip
            out_str << "\n:Member Name: #{@member_name}".rstrip
            out_str << "\n:Member ID: #{@member_id}".rstrip
            out_str << "\n:Issuer 80840: #{@issuer80840}".rstrip
            out_str << "\n:Dependents: #{dependents}".rstrip
            out_str << "\n:Group Number: #{@group_number}".rstrip
            out_str << "\n:Payer ID: #{@payer_id}".rstrip
            out_str << "\n:RX BIN: #{@rx_bin}".rstrip
            out_str << "\n:RX ID: #{@rx_id}".rstrip
            out_str << "\n:RX GRP: #{@rx_grp}".rstrip
            out_str << "\n:RX PCN: #{@rx_pcn}".rstrip
            out_str << "\n:copays:"
            out_str << copays
            out_str << "\n:Enrollment Date: #{@enrollment_date}".rstrip
            out_str[1..].to_s
          end

          private

          # @param char [String]
          # @return [String]
          def copays_separator(char)
            out_str = String.new
            out_str << '  '
            out_str << "+#{char * 14}"
            out_str << "+#{char * 14}"
            out_str << '+'
            out_str
          end

          # @return [String]
          def copays_to_s
            return '' if @copays.empty?

            line_items = @copays.map(&:to_table_line).join("\n#{copays_separator('-')}\n  ")
            out_str = String.new
            out_str << "\n#{copays_separator('-')}"
            out_str << "\n  |"
            out_str << ' Service Fees |'
            out_str << ' Service Name |'
            out_str << "\n#{copays_separator('=')}"
            out_str << "\n  #{line_items}"
            out_str << "\n#{copays_separator('-')}"
            out_str
          end
        end
      end
    end
  end
end
