# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module DriverLicense
      # Driver License API version 1.0 document data.
      class DriverLicenseV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # The category or class of the driver license.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :category
        # The alpha-3 ISO 3166 code of the country where the driver license was issued.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :country_code
        # The date of birth of the driver license holder.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :date_of_birth
        # The DD number of the driver license.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :dd_number
        # The expiry date of the driver license.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :expiry_date
        # The first name of the driver license holder.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :first_name
        # The unique identifier of the driver license.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :id
        # The date when the driver license was issued.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :issued_date
        # The authority that issued the driver license.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :issuing_authority
        # The last name of the driver license holder.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :last_name
        # The Machine Readable Zone (MRZ) of the driver license.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :mrz
        # The place of birth of the driver license holder.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :place_of_birth
        # Second part of the ISO 3166-2 code, consisting of two letters indicating the US State.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :state

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super()
          @category = StringField.new(prediction['category'], page_id)
          @country_code = StringField.new(prediction['country_code'], page_id)
          @date_of_birth = DateField.new(prediction['date_of_birth'], page_id)
          @dd_number = StringField.new(prediction['dd_number'], page_id)
          @expiry_date = DateField.new(prediction['expiry_date'], page_id)
          @first_name = StringField.new(prediction['first_name'], page_id)
          @id = StringField.new(prediction['id'], page_id)
          @issued_date = DateField.new(prediction['issued_date'], page_id)
          @issuing_authority = StringField.new(prediction['issuing_authority'], page_id)
          @last_name = StringField.new(prediction['last_name'], page_id)
          @mrz = StringField.new(prediction['mrz'], page_id)
          @place_of_birth = StringField.new(prediction['place_of_birth'], page_id)
          @state = StringField.new(prediction['state'], page_id)
        end

        # @return [String]
        def to_s
          out_str = String.new
          out_str << "\n:Country Code: #{@country_code}".rstrip
          out_str << "\n:State: #{@state}".rstrip
          out_str << "\n:ID: #{@id}".rstrip
          out_str << "\n:Category: #{@category}".rstrip
          out_str << "\n:Last Name: #{@last_name}".rstrip
          out_str << "\n:First Name: #{@first_name}".rstrip
          out_str << "\n:Date of Birth: #{@date_of_birth}".rstrip
          out_str << "\n:Place of Birth: #{@place_of_birth}".rstrip
          out_str << "\n:Expiry Date: #{@expiry_date}".rstrip
          out_str << "\n:Issued Date: #{@issued_date}".rstrip
          out_str << "\n:Issuing Authority: #{@issuing_authority}".rstrip
          out_str << "\n:MRZ: #{@mrz}".rstrip
          out_str << "\n:DD Number: #{@dd_number}".rstrip
          out_str[1..].to_s
        end
      end
    end
  end
end
