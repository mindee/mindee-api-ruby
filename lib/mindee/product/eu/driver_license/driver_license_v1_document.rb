# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module EU
      module DriverLicense
        # Driver License API version 1.0 document data.
        class DriverLicenseV1Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Standard
          # EU driver license holders address
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :address
          # EU driver license holders categories
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :category
          # Country code extracted as a string.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :country_code
          # The date of birth of the document holder
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :date_of_birth
          # ID number of the Document.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :document_id
          # Date the document expires
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :expiry_date
          # First name(s) of the driver license holder
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :first_name
          # Authority that issued the document
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :issue_authority
          # Date the document was issued
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :issue_date
          # Last name of the driver license holder.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :last_name
          # Machine-readable license number
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :mrz
          # Place where the driver license holder was born
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :place_of_birth

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super()
            @address = StringField.new(prediction['address'], page_id)
            @category = StringField.new(prediction['category'], page_id)
            @country_code = StringField.new(prediction['country_code'], page_id)
            @date_of_birth = DateField.new(prediction['date_of_birth'], page_id)
            @document_id = StringField.new(prediction['document_id'], page_id)
            @expiry_date = DateField.new(prediction['expiry_date'], page_id)
            @first_name = StringField.new(prediction['first_name'], page_id)
            @issue_authority = StringField.new(prediction['issue_authority'], page_id)
            @issue_date = DateField.new(prediction['issue_date'], page_id)
            @last_name = StringField.new(prediction['last_name'], page_id)
            @mrz = StringField.new(prediction['mrz'], page_id)
            @place_of_birth = StringField.new(prediction['place_of_birth'], page_id)
          end

          # @return [String]
          def to_s
            out_str = String.new
            out_str << "\n:Country Code: #{@country_code}".rstrip
            out_str << "\n:Document ID: #{@document_id}".rstrip
            out_str << "\n:Driver License Category: #{@category}".rstrip
            out_str << "\n:Last Name: #{@last_name}".rstrip
            out_str << "\n:First Name: #{@first_name}".rstrip
            out_str << "\n:Date Of Birth: #{@date_of_birth}".rstrip
            out_str << "\n:Place Of Birth: #{@place_of_birth}".rstrip
            out_str << "\n:Expiry Date: #{@expiry_date}".rstrip
            out_str << "\n:Issue Date: #{@issue_date}".rstrip
            out_str << "\n:Issue Authority: #{@issue_authority}".rstrip
            out_str << "\n:MRZ: #{@mrz}".rstrip
            out_str << "\n:Address: #{@address}".rstrip
            out_str[1..].to_s
          end
        end
      end
    end
  end
end
