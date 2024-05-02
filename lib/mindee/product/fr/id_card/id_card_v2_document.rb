# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module IdCard
        # Carte Nationale d'Identité API version 2.0 document data.
        class IdCardV2Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Standard
          # The alternate name of the card holder.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :alternate_name
          # The name of the issuing authority.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :authority
          # The date of birth of the card holder.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :birth_date
          # The place of birth of the card holder.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :birth_place
          # The card access number (CAN).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :card_access_number
          # The document number.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :document_number
          # The expiry date of the identification card.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :expiry_date
          # The gender of the card holder.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :gender
          # The given name(s) of the card holder.
          # @return [Array<Mindee::Parsing::Standard::StringField>]
          attr_reader :given_names
          # The date of issue of the identification card.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :issue_date
          # The Machine Readable Zone, first line.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :mrz1
          # The Machine Readable Zone, second line.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :mrz2
          # The Machine Readable Zone, third line.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :mrz3
          # The nationality of the card holder.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :nationality
          # The surname of the card holder.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :surname

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super()
            @alternate_name = StringField.new(prediction['alternate_name'], page_id)
            @authority = StringField.new(prediction['authority'], page_id)
            @birth_date = DateField.new(prediction['birth_date'], page_id)
            @birth_place = StringField.new(prediction['birth_place'], page_id)
            @card_access_number = StringField.new(prediction['card_access_number'], page_id)
            @document_number = StringField.new(prediction['document_number'], page_id)
            @expiry_date = DateField.new(prediction['expiry_date'], page_id)
            @gender = StringField.new(prediction['gender'], page_id)
            @given_names = []
            prediction['given_names'].each do |item|
              @given_names.push(StringField.new(item, page_id))
            end
            @issue_date = DateField.new(prediction['issue_date'], page_id)
            @mrz1 = StringField.new(prediction['mrz1'], page_id)
            @mrz2 = StringField.new(prediction['mrz2'], page_id)
            @mrz3 = StringField.new(prediction['mrz3'], page_id)
            @nationality = StringField.new(prediction['nationality'], page_id)
            @surname = StringField.new(prediction['surname'], page_id)
          end

          # @return [String]
          def to_s
            given_names = @given_names.join("\n #{' ' * 15}")
            out_str = String.new
            out_str << "\n:Nationality: #{@nationality}".rstrip
            out_str << "\n:Card Access Number: #{@card_access_number}".rstrip
            out_str << "\n:Document Number: #{@document_number}".rstrip
            out_str << "\n:Given Name(s): #{given_names}".rstrip
            out_str << "\n:Surname: #{@surname}".rstrip
            out_str << "\n:Alternate Name: #{@alternate_name}".rstrip
            out_str << "\n:Date of Birth: #{@birth_date}".rstrip
            out_str << "\n:Place of Birth: #{@birth_place}".rstrip
            out_str << "\n:Gender: #{@gender}".rstrip
            out_str << "\n:Expiry Date: #{@expiry_date}".rstrip
            out_str << "\n:Mrz Line 1: #{@mrz1}".rstrip
            out_str << "\n:Mrz Line 2: #{@mrz2}".rstrip
            out_str << "\n:Mrz Line 3: #{@mrz3}".rstrip
            out_str << "\n:Date of Issue: #{@issue_date}".rstrip
            out_str << "\n:Issuing Authority: #{@authority}".rstrip
            out_str[1..].to_s
          end
        end
      end
    end
  end
end
