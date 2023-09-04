# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module Passport
      # Passport V1 document prediction.
      class PassportV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # The date of birth of the passport holder.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :birth_date
        # The place of birth of the passport holder.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :birth_place
        # The country's 3 letter code (ISO 3166-1 alpha-3).
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :country
        # The expiry date of the passport.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :expiry_date
        # The gender of the passport holder.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :gender
        # The given name(s) of the passport holder.
        # @return [Array<Mindee::Parsing::Standard::StringField>]
        attr_reader :given_names
        # The passport's identification number.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :id_number
        # The date the passport was issued.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :issuance_date
        # Machine Readable Zone, first line
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :mrz1
        # Machine Readable Zone, second line
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :mrz2
        # The surname of the passport holder.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :surname

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super()
          @birth_date = DateField.new(prediction['birth_date'], page_id)
          @birth_place = StringField.new(prediction['birth_place'], page_id)
          @country = StringField.new(prediction['country'], page_id)
          @expiry_date = DateField.new(prediction['expiry_date'], page_id)
          @gender = StringField.new(prediction['gender'], page_id)
          @given_names = []
          prediction['given_names'].each do |item|
            @given_names.push(StringField.new(item, page_id))
          end
          @id_number = StringField.new(prediction['id_number'], page_id)
          @issuance_date = DateField.new(prediction['issuance_date'], page_id)
          @mrz1 = StringField.new(prediction['mrz1'], page_id)
          @mrz2 = StringField.new(prediction['mrz2'], page_id)
          @surname = StringField.new(prediction['surname'], page_id)
        end

        # @return [String]
        def to_s
          given_names = @given_names.join("\n #{' ' * 15}")
          out_str = String.new
          out_str << "\n:Country Code: #{@country}".rstrip
          out_str << "\n:ID Number: #{@id_number}".rstrip
          out_str << "\n:Given Name(s): #{given_names}".rstrip
          out_str << "\n:Surname: #{@surname}".rstrip
          out_str << "\n:Date of Birth: #{@birth_date}".rstrip
          out_str << "\n:Place of Birth: #{@birth_place}".rstrip
          out_str << "\n:Gender: #{@gender}".rstrip
          out_str << "\n:Date of Issue: #{@issuance_date}".rstrip
          out_str << "\n:Expiry Date: #{@expiry_date}".rstrip
          out_str << "\n:MRZ Line 1: #{@mrz1}".rstrip
          out_str << "\n:MRZ Line 2: #{@mrz2}".rstrip
          out_str[1..].to_s
        end
      end
    end
  end
end
