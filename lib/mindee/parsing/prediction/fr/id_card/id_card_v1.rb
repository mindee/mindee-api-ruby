# frozen_string_literal: true

require_relative '../../common_fields'
require_relative '../../base'

module Mindee
  module Prediction
    module FR
      # French national ID card
      class IdCardV1 < Prediction
        # The authority which has issued the card.
        # @return [Array<Mindee::TextField>]
        attr_reader :authority
        # Indicates if it is the recto side, the verso side or both.
        # @return [Mindee::TextField]
        attr_reader :document_side
        # The card number.
        # @return [Mindee::TextField]
        attr_reader :id_number
        # The expiration date of the card.
        # @return [Mindee::DateField]
        attr_reader :expiry_date
        # The surname (last name) of the cardholder.
        # @return [Mindee::TextField]
        attr_reader :surname
        # List of first (given) names of the cardholder.
        # @return [Mindee::TextField]
        attr_reader :given_names
        # The date of birth of the cardholder.
        # @return [Mindee::DateField]
        attr_reader :birth_date
        # The place of birth of the cardholder.
        # @return [Mindee::TextField]
        attr_reader :birth_place
        # The sex or gender of the cardholder.
        # @return [Mindee::TextField]
        attr_reader :gender
        # The value of the first MRZ line.
        # @return [Mindee::TextField]
        attr_reader :mrz1
        # The value of the second MRZ line.
        # @return [Mindee::TextField]
        attr_reader :mrz2

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @document_side = TextField.new(prediction['document_side'], page_id) if page_id
          @authority = TextField.new(prediction['authority'], page_id)
          @id_number = TextField.new(prediction['id_number'], page_id)
          @birth_date = DateField.new(prediction['birth_date'], page_id)
          @expiry_date = DateField.new(prediction['expiry_date'], page_id)
          @birth_place = TextField.new(prediction['birth_place'], page_id)
          @gender = TextField.new(prediction['gender'], page_id)
          @surname = TextField.new(prediction['surname'], page_id)
          @mrz1 = TextField.new(prediction['mrz1'], page_id)
          @mrz2 = TextField.new(prediction['mrz2'], page_id)
          @given_names = []
          prediction['given_names'].each do |item|
            @given_names.push(TextField.new(item, page_id))
          end
        end

        def to_s
          given_names = @given_names.map(&:value).join(', ')
          out_str = String.new
          out_str << "\n:Document side: #{@document_side}".rstrip if @document_side
          out_str << "\n:Authority: #{@authority}".rstrip
          out_str << "\n:Given names: #{given_names}".rstrip
          out_str << "\n:Surname: #{@surname}".rstrip
          out_str << "\n:Gender: #{@gender}".rstrip
          out_str << "\n:ID Number: #{@id_number}".rstrip
          out_str << "\n:Birth date: #{@birth_date}".rstrip
          out_str << "\n:Birth place: #{@birth_place}".rstrip
          out_str << "\n:Expiry date: #{@expiry_date}".rstrip
          out_str << "\n:MRZ 1: #{@mrz1}".rstrip
          out_str << "\n:MRZ 2: #{@mrz2}".rstrip
          out_str[1..].to_s
        end
      end
    end
  end
end
