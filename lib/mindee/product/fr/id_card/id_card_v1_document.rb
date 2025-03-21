# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module IdCard
        # Carte Nationale d'Identité API version 1.1 document data.
        class IdCardV1Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Standard
          # The name of the issuing authority.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :authority
          # The date of birth of the card holder.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :birth_date
          # The place of birth of the card holder.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :birth_place
          # The expiry date of the identification card.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :expiry_date
          # The gender of the card holder.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :gender
          # The given name(s) of the card holder.
          # @return [Array<Mindee::Parsing::Standard::StringField>]
          attr_reader :given_names
          # The identification card number.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :id_number
          # Machine Readable Zone, first line
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :mrz1
          # Machine Readable Zone, second line
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :mrz2
          # The surname of the card holder.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :surname

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super
            @authority = Parsing::Standard::StringField.new(
              prediction['authority'],
              page_id
            )
            @birth_date = Parsing::Standard::DateField.new(
              prediction['birth_date'],
              page_id
            )
            @birth_place = Parsing::Standard::StringField.new(
              prediction['birth_place'],
              page_id
            )
            @expiry_date = Parsing::Standard::DateField.new(
              prediction['expiry_date'],
              page_id
            )
            @gender = Parsing::Standard::StringField.new(
              prediction['gender'],
              page_id
            )
            @given_names = [] # : Array[Parsing::Standard::StringField]
            prediction['given_names'].each do |item|
              @given_names.push(Parsing::Standard::StringField.new(item, page_id))
            end
            @id_number = Parsing::Standard::StringField.new(
              prediction['id_number'],
              page_id
            )
            @mrz1 = Parsing::Standard::StringField.new(prediction['mrz1'], page_id)
            @mrz2 = Parsing::Standard::StringField.new(prediction['mrz2'], page_id)
            @surname = Parsing::Standard::StringField.new(
              prediction['surname'],
              page_id
            )
          end

          # @return [String]
          def to_s
            given_names = @given_names.join("\n #{' ' * 15}")
            out_str = String.new
            out_str << "\n:Identity Number: #{@id_number}".rstrip
            out_str << "\n:Given Name(s): #{given_names}".rstrip
            out_str << "\n:Surname: #{@surname}".rstrip
            out_str << "\n:Date of Birth: #{@birth_date}".rstrip
            out_str << "\n:Place of Birth: #{@birth_place}".rstrip
            out_str << "\n:Expiry Date: #{@expiry_date}".rstrip
            out_str << "\n:Issuing Authority: #{@authority}".rstrip
            out_str << "\n:Gender: #{@gender}".rstrip
            out_str << "\n:MRZ Line 1: #{@mrz1}".rstrip
            out_str << "\n:MRZ Line 2: #{@mrz2}".rstrip
            out_str[1..].to_s
          end
        end
      end
    end
  end
end
