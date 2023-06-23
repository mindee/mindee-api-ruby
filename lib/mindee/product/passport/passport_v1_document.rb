# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module Passport
      # Passport V1 document prediction.
      class PassportV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Common
        include Mindee::Parsing::Standard
        # The country of issue.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :country
        # The passport number.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :id_number
        # The expiration date of the passport.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :expiry_date
        # The issuance date of the passport.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :issuance_date
        # The surname (last name) of the passport holder.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :surname
        # List of first (given) names of the passport holder.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :given_names
        # The full name of the passport holder.
        # @return [Array<Mindee::Parsing::Standard::TextField>]
        attr_reader :full_name
        # The date of birth of the passport holder.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :birth_date
        # The place of birth of the passport holder.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :birth_place
        # The sex or gender of the passport holder.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :gender
        # The value of the first MRZ line.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :mrz1
        # The value of the second MRZ line.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :mrz2
        # All the MRZ values combined.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :mrz

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super()
          @country = TextField.new(prediction['country'], page_id)
          @id_number = TextField.new(prediction['id_number'], page_id)
          @birth_date = DateField.new(prediction['birth_date'], page_id)
          @expiry_date = DateField.new(prediction['expiry_date'], page_id)
          @issuance_date = DateField.new(prediction['issuance_date'], page_id)
          @birth_place = TextField.new(prediction['birth_place'], page_id)
          @gender = TextField.new(prediction['gender'], page_id)
          @surname = TextField.new(prediction['surname'], page_id)
          @mrz1 = TextField.new(prediction['mrz1'], page_id)
          @mrz2 = TextField.new(prediction['mrz2'], page_id)
          @given_names = []
          prediction['given_names'].each do |item|
            @given_names.push(TextField.new(item, page_id))
          end
          @full_name = construct_full_name(page_id)
          @mrz = construct_mrz(page_id)
        end

        def to_s
          given_names = @given_names.join(' ')
          out_str = String.new
          out_str << "\n:Full name: #{@full_name}".rstrip
          out_str << "\n:Given names: #{given_names}".rstrip
          out_str << "\n:Surname: #{@surname}".rstrip
          out_str << "\n:Country: #{@country}".rstrip
          out_str << "\n:ID Number: #{@id_number}".rstrip
          out_str << "\n:Issuance date: #{@issuance_date}".rstrip
          out_str << "\n:Birth date: #{@birth_date}".rstrip
          out_str << "\n:Expiry date: #{@expiry_date}".rstrip
          out_str << "\n:MRZ 1: #{@mrz1}".rstrip
          out_str << "\n:MRZ 2: #{@mrz2}".rstrip
          out_str << "\n:MRZ: #{@mrz}".rstrip
          out_str[1..].to_s
        end

        # @return [Boolean]
        def expired?
          return true unless @expiry_date.date_object

          @expiry_date.date_object < Date.today
        end

        private

        def construct_full_name(page_id)
          return unless @surname.value &&
                        !@given_names.empty? &&
                        @given_names[0].value

          full_name = {
            'value' => "#{@given_names[0].value} #{@surname.value}",
            'confidence' => TextField.array_confidence([@surname, @given_names[0]]),
          }
          TextField.new(full_name, page_id, reconstructed: true)
        end

        def construct_mrz(page_id)
          return if @mrz1.value.nil? || @mrz2.value.nil?

          mrz = {
            'value' => @mrz1.value + @mrz2.value,
            'confidence' => TextField.array_confidence([@mrz1, @mrz2]),
          }
          TextField.new(mrz, page_id, reconstructed: true)
        end
      end
    end
  end
end
