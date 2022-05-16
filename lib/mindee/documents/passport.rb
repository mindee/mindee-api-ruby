# frozen_string_literal: true

require 'mrz'

require_relative '../fields'
require_relative 'base'

module Mindee
  class Passport < Document
    attr_reader :country,
                :id_number,
                :expiry_date,
                :issuance_date,
                :surname,
                :given_names,
                :full_name,
                :birth_date,
                :birth_place,
                :gender,
                :mrz1,
                :mrz2,
                :mrz

    def initialize(prediction, page_id)
      super('passport')
      @country = Field.new(prediction['country'], page_id)
      @id_number = Field.new(prediction['id_number'], page_id)
      @birth_date = DateField.new(prediction['birth_date'], page_id)
      @expiry_date = DateField.new(prediction['expiry_date'], page_id)
      @issuance_date = DateField.new(prediction['issuance_date'], page_id)
      @birth_place = Field.new(prediction['birth_place'], page_id)
      @gender = Field.new(prediction['gender'], page_id)
      @surname = Field.new(prediction['surname'], page_id)
      @mrz1 = Field.new(prediction['mrz1'], page_id)
      @mrz2 = Field.new(prediction['mrz2'], page_id)
      @given_names = []
      prediction['given_names'].each do |item|
        @given_names.push(Field.new(item, page_id))
      end
      @full_name = construct_full_name(page_id)
      @mrz = construct_mrz(page_id)
      check_mrz
    end

    def to_s
      given_names = @given_names.join(' ')
      "-----Passport data-----\n" \
        "Full name: #{@full_name}\n" \
        "Given names: #{given_names}\n" \
        "Surname: #{@surname}\n" \
        "Country: #{@country}\n" \
        "ID Number: #{@id_number}\n" \
        "Issuance date: #{@issuance_date}\n" \
        "Birth date: #{@birth_date}\n" \
        "Expiry date: #{@expiry_date}\n" \
        "MRZ 1: #{@mrz1}\n" \
        "MRZ 2: #{@mrz2}\n" \
        "MRZ: #{@mrz}\n" \
        '----------------------'
    end

    def expired?
      return true unless @expiry_date.date_object

      @expiry_date.date_object < Date.today
    end

    private

    def check_mrz
      return false unless @mrz&.value

      mrz = MRZ.parse([@mrz1.value, @mrz2.value])
      @checks << [
        mrz.valid?,
        valid_birth_date?(mrz),
        valid_expiry_date?(mrz),
        valid_id_number?(mrz),
      ]
    end

    def valid_birth_date?(mrz)
      @birth_date.confidence = 1.0 if mrz.valid_birth_date? &&
                                      mrz.birth_date == @birth_date.date_object
      mrz.valid_birth_date?
    end

    def valid_expiry_date?(mrz)
      @expiry_date.confidence = 1.0 if mrz.valid_expiration_date? &&
                                       mrz.expiration_date == @expiry_date.date_object
      mrz.valid_expiration_date?
    end

    def valid_id_number?(mrz)
      @id_number.confidence = 1.0 if mrz.valid_document_number? &&
                                     mrz.document_number == @id_number.value
      mrz.valid_document_number?
    end

    def construct_full_name(page_id)
      return unless @surname.value &&
                    !@given_names.empty? &&
                    @given_names[0].value

      full_name = {
        'value' => "#{@given_names[0].value} #{@surname.value}",
        'confidence' => Field.array_confidence([@surname, @given_names[0]]),
      }
      Field.new(full_name, page_id, constructed: true)
    end

    def construct_mrz(page_id)
      return unless @mrz1.value &&
                    @mrz2.value

      mrz = {
        'value' => @mrz1.value + @mrz2.value,
        'confidence' => Field.array_confidence([@mrz1, @mrz2]),
      }
      Field.new(mrz, page_id, constructed: true)
    end
  end
end
