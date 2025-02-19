# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module Payslip
        # Information about the employee.
        class PayslipV2Employee < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # The address of the employee.
          # @return [String]
          attr_reader :address
          # The date of birth of the employee.
          # @return [String]
          attr_reader :date_of_birth
          # The first name of the employee.
          # @return [String]
          attr_reader :first_name
          # The last name of the employee.
          # @return [String]
          attr_reader :last_name
          # The phone number of the employee.
          # @return [String]
          attr_reader :phone_number
          # The registration number of the employee.
          # @return [String]
          attr_reader :registration_number
          # The social security number of the employee.
          # @return [String]
          attr_reader :social_security_number

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super
            @address = prediction['address']
            @date_of_birth = prediction['date_of_birth']
            @first_name = prediction['first_name']
            @last_name = prediction['last_name']
            @phone_number = prediction['phone_number']
            @registration_number = prediction['registration_number']
            @social_security_number = prediction['social_security_number']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:address] = format_for_display(@address)
            printable[:date_of_birth] = format_for_display(@date_of_birth)
            printable[:first_name] = format_for_display(@first_name)
            printable[:last_name] = format_for_display(@last_name)
            printable[:phone_number] = format_for_display(@phone_number)
            printable[:registration_number] = format_for_display(@registration_number)
            printable[:social_security_number] = format_for_display(@social_security_number)
            printable
          end

          # @return [String]
          def to_s
            printable = printable_values
            out_str = String.new
            out_str << "\n  :Address: #{printable[:address]}"
            out_str << "\n  :Date of Birth: #{printable[:date_of_birth]}"
            out_str << "\n  :First Name: #{printable[:first_name]}"
            out_str << "\n  :Last Name: #{printable[:last_name]}"
            out_str << "\n  :Phone Number: #{printable[:phone_number]}"
            out_str << "\n  :Registration Number: #{printable[:registration_number]}"
            out_str << "\n  :Social Security Number: #{printable[:social_security_number]}"
            out_str
          end
        end
      end
    end
  end
end
