# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module Payslip
        # Information about the employer.
        class PayslipV3Employer < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # The address of the employer.
          # @return [String]
          attr_reader :address
          # The company ID of the employer.
          # @return [String]
          attr_reader :company_id
          # The site of the company.
          # @return [String]
          attr_reader :company_site
          # The NAF code of the employer.
          # @return [String]
          attr_reader :naf_code
          # The name of the employer.
          # @return [String]
          attr_reader :name
          # The phone number of the employer.
          # @return [String]
          attr_reader :phone_number
          # The URSSAF number of the employer.
          # @return [String]
          attr_reader :urssaf_number

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super(prediction, page_id)
            @address = prediction['address']
            @company_id = prediction['company_id']
            @company_site = prediction['company_site']
            @naf_code = prediction['naf_code']
            @name = prediction['name']
            @phone_number = prediction['phone_number']
            @urssaf_number = prediction['urssaf_number']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:address] = format_for_display(@address)
            printable[:company_id] = format_for_display(@company_id)
            printable[:company_site] = format_for_display(@company_site)
            printable[:naf_code] = format_for_display(@naf_code)
            printable[:name] = format_for_display(@name)
            printable[:phone_number] = format_for_display(@phone_number)
            printable[:urssaf_number] = format_for_display(@urssaf_number)
            printable
          end

          # @return [String]
          def to_s
            printable = printable_values
            out_str = String.new
            out_str << "\n  :Address: #{printable[:address]}"
            out_str << "\n  :Company ID: #{printable[:company_id]}"
            out_str << "\n  :Company Site: #{printable[:company_site]}"
            out_str << "\n  :NAF Code: #{printable[:naf_code]}"
            out_str << "\n  :Name: #{printable[:name]}"
            out_str << "\n  :Phone Number: #{printable[:phone_number]}"
            out_str << "\n  :URSSAF Number: #{printable[:urssaf_number]}"
            out_str
          end
        end
      end
    end
  end
end
