# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module IND
      module IndianPassport
        # Passport - India API version 1.2 document data.
        class IndianPassportV1Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Standard
          # The first line of the address of the passport holder.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :address1
          # The second line of the address of the passport holder.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :address2
          # The third line of the address of the passport holder.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :address3
          # The birth date of the passport holder, ISO format: YYYY-MM-DD.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :birth_date
          # The birth place of the passport holder.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :birth_place
          # ISO 3166-1 alpha-3 country code (3 letters format).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :country
          # The date when the passport will expire, ISO format: YYYY-MM-DD.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :expiry_date
          # The file number of the passport document.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :file_number
          # The gender of the passport holder.
          # @return [Mindee::Parsing::Standard::ClassificationField]
          attr_reader :gender
          # The given names of the passport holder.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :given_names
          # The identification number of the passport document.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :id_number
          # The date when the passport was issued, ISO format: YYYY-MM-DD.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :issuance_date
          # The place where the passport was issued.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :issuance_place
          # The name of the legal guardian of the passport holder (if applicable).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :legal_guardian
          # The first line of the machine-readable zone (MRZ) of the passport document.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :mrz1
          # The second line of the machine-readable zone (MRZ) of the passport document.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :mrz2
          # The name of the mother of the passport holder.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :name_of_mother
          # The name of the spouse of the passport holder (if applicable).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :name_of_spouse
          # The date of issue of the old passport (if applicable), ISO format: YYYY-MM-DD.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :old_passport_date_of_issue
          # The number of the old passport (if applicable).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :old_passport_number
          # The place of issue of the old passport (if applicable).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :old_passport_place_of_issue
          # The page number of the passport document.
          # @return [Mindee::Parsing::Standard::ClassificationField]
          attr_reader :page_number
          # The surname of the passport holder.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :surname

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super(prediction, page_id)
            @address1 = Parsing::Standard::StringField.new(prediction['address1'], page_id)
            @address2 = Parsing::Standard::StringField.new(prediction['address2'], page_id)
            @address3 = Parsing::Standard::StringField.new(prediction['address3'], page_id)
            @birth_date = Parsing::Standard::DateField.new(prediction['birth_date'], page_id)
            @birth_place = Parsing::Standard::StringField.new(prediction['birth_place'], page_id)
            @country = Parsing::Standard::StringField.new(prediction['country'], page_id)
            @expiry_date = Parsing::Standard::DateField.new(prediction['expiry_date'], page_id)
            @file_number = Parsing::Standard::StringField.new(prediction['file_number'], page_id)
            @gender = Parsing::Standard::ClassificationField.new(prediction['gender'], page_id)
            @given_names = Parsing::Standard::StringField.new(prediction['given_names'], page_id)
            @id_number = Parsing::Standard::StringField.new(prediction['id_number'], page_id)
            @issuance_date = Parsing::Standard::DateField.new(prediction['issuance_date'], page_id)
            @issuance_place = Parsing::Standard::StringField.new(prediction['issuance_place'], page_id)
            @legal_guardian = Parsing::Standard::StringField.new(prediction['legal_guardian'], page_id)
            @mrz1 = Parsing::Standard::StringField.new(prediction['mrz1'], page_id)
            @mrz2 = Parsing::Standard::StringField.new(prediction['mrz2'], page_id)
            @name_of_mother = Parsing::Standard::StringField.new(prediction['name_of_mother'], page_id)
            @name_of_spouse = Parsing::Standard::StringField.new(prediction['name_of_spouse'], page_id)
            @old_passport_date_of_issue = Parsing::Standard::DateField.new(prediction['old_passport_date_of_issue'], page_id)
            @old_passport_number = Parsing::Standard::StringField.new(prediction['old_passport_number'], page_id)
            @old_passport_place_of_issue = Parsing::Standard::StringField.new(prediction['old_passport_place_of_issue'], page_id)
            @page_number = Parsing::Standard::ClassificationField.new(prediction['page_number'], page_id)
            @surname = Parsing::Standard::StringField.new(prediction['surname'], page_id)
          end

          # @return [String]
          def to_s
            out_str = String.new
            out_str << "\n:Page Number: #{@page_number}".rstrip
            out_str << "\n:Country: #{@country}".rstrip
            out_str << "\n:ID Number: #{@id_number}".rstrip
            out_str << "\n:Given Names: #{@given_names}".rstrip
            out_str << "\n:Surname: #{@surname}".rstrip
            out_str << "\n:Birth Date: #{@birth_date}".rstrip
            out_str << "\n:Birth Place: #{@birth_place}".rstrip
            out_str << "\n:Issuance Place: #{@issuance_place}".rstrip
            out_str << "\n:Gender: #{@gender}".rstrip
            out_str << "\n:Issuance Date: #{@issuance_date}".rstrip
            out_str << "\n:Expiry Date: #{@expiry_date}".rstrip
            out_str << "\n:MRZ Line 1: #{@mrz1}".rstrip
            out_str << "\n:MRZ Line 2: #{@mrz2}".rstrip
            out_str << "\n:Legal Guardian: #{@legal_guardian}".rstrip
            out_str << "\n:Name of Spouse: #{@name_of_spouse}".rstrip
            out_str << "\n:Name of Mother: #{@name_of_mother}".rstrip
            out_str << "\n:Old Passport Date of Issue: #{@old_passport_date_of_issue}".rstrip
            out_str << "\n:Old Passport Number: #{@old_passport_number}".rstrip
            out_str << "\n:Address Line 1: #{@address1}".rstrip
            out_str << "\n:Address Line 2: #{@address2}".rstrip
            out_str << "\n:Address Line 3: #{@address3}".rstrip
            out_str << "\n:Old Passport Place of Issue: #{@old_passport_place_of_issue}".rstrip
            out_str << "\n:File Number: #{@file_number}".rstrip
            out_str[1..].to_s
          end
        end
      end
    end
  end
end
