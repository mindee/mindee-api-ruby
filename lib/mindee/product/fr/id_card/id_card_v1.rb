# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      # Carte Nationale d'Identité v1 prediction results.
      class IdCardV1
        @endpoint_name = 'idcard_fr'
        @endpoint_version = '1'

        # The side of the document which is visible.
        # @return [Mindee::TextField]
        attr_reader :document_side
        # The identification card number.
        # @return [Mindee::TextField]
        attr_reader :id_number
        # The given name(s) of the card holder.
        # @return [Array<Mindee::TextField>]
        attr_reader :given_names
        # The surname of the card holder.
        # @return [Mindee::TextField]
        attr_reader :surname
        # The date of birth of the card holder.
        # @return [Mindee::DateField]
        attr_reader :birth_date
        # The place of birth of the card holder.
        # @return [Mindee::TextField]
        attr_reader :birth_place
        # The expiry date of the identification card.
        # @return [Mindee::DateField]
        attr_reader :expiry_date
        # The name of the issuing authority.
        # @return [Mindee::TextField]
        attr_reader :authority
        # The gender of the card holder.
        # @return [Mindee::TextField]
        attr_reader :gender
        # Machine Readable Zone, first line
        # @return [Mindee::TextField]
        attr_reader :mrz1
        # Machine Readable Zone, second line
        # @return [Mindee::TextField]
        attr_reader :mrz2

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          @document_side = TextField.new(prediction['document_side'], page_id) if page_id
          @authority = TextField.new(prediction['authority'], page_id)
          @id_number = TextField.new(prediction['id_number'], page_id)
          @given_names = []
          prediction['given_names'].each do |item|
            @given_names.push(TextField.new(item, page_id))
          end
          @surname = TextField.new(prediction['surname'], page_id)
          @birth_date = DateField.new(prediction['birth_date'], page_id)
          @birth_place = TextField.new(prediction['birth_place'], page_id)
          @expiry_date = DateField.new(prediction['expiry_date'], page_id)
          @authority = TextField.new(prediction['authority'], page_id)
          @gender = TextField.new(prediction['gender'], page_id)
          @mrz1 = TextField.new(prediction['mrz1'], page_id)
          @mrz2 = TextField.new(prediction['mrz2'], page_id)
        end

        def to_s
          given_names = @given_names.join("\n #{' ' * 15}")
          out_str = String.new
          out_str << "\n:Document Side: #{@document_side}".rstrip if @document_side
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

        class << self
          attr_reader :endpoint_name, :endpoint_version
        end
      end
    end
  end
end