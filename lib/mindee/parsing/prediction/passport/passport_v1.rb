# frozen_string_literal: true

require 'mrz'

require_relative '../common_fields'
require_relative '../base'

# We need to do this disgusting thing to avoid the following error message:
# td3 line one does not match the required format (MRZ::InvalidFormatError)
#
# See:
# https://github.com/streetspotr/mrz/issues/2
# https://github.com/streetspotr/mrz/pull/3
#
MRZ::TD3Parser::FORMAT_ONE = %r{\A(.{2})(.{3})([^<]+)<(.*)\z}.freeze

module Mindee
  # Passport document.
  class PassportV1 < Prediction
    # @return [Mindee::Orientation]
    attr_reader :orientation
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

    # @param prediction [Hash]
    # @param page_id [Integer, nil]
    def initialize(prediction, page_id)
      super()
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
      out_str = String.new
      out_str << '-----Passport data-----'
      out_str << "\nFilename: #{@filename}".rstrip
      out_str << "\nFull name: #{@full_name}".rstrip
      out_str << "\nGiven names: #{given_names}".rstrip
      out_str << "\nSurname: #{@surname}".rstrip
      out_str << "\nCountry: #{@country}".rstrip
      out_str << "\nID Number: #{@id_number}".rstrip
      out_str << "\nIssuance date: #{@issuance_date}".rstrip
      out_str << "\nBirth date: #{@birth_date}".rstrip
      out_str << "\nExpiry date: #{@expiry_date}".rstrip
      out_str << "\nMRZ 1: #{@mrz1}".rstrip
      out_str << "\nMRZ 2: #{@mrz2}".rstrip
      out_str << "\nMRZ: #{@mrz}".rstrip
      out_str << "\n----------------------"
      out_str
    end

    # @return [Boolean]
    def expired?
      return true unless @expiry_date.date_object

      @expiry_date.date_object < Date.today
    end

    private

    def check_mrz
      return if @mrz1.value.nil? || @mrz2.value.nil?

      mrz = MRZ.parse([@mrz1.value, @mrz2.value])
      checks = {
        mrz_valid: valid_mrz?(mrz),
        mrz_valid_birth_date: valid_birth_date?(mrz),
        mrz_valid_expiry_date: valid_expiry_date?(mrz),
        mrz_valid_id_number: valid_id_number?(mrz),
        mrz_valid_surname: valid_surname?(mrz),
        mrz_valid_country: valid_country?(mrz),
      }
      @checklist.merge!(checks)
    end

    def valid_mrz?(mrz)
      check = mrz.valid?
      @mrz.confidence = 1.0 if check
      check
    end

    def valid_birth_date?(mrz)
      check = mrz.valid_birth_date? && mrz.birth_date == @birth_date.date_object
      @birth_date.confidence = 1.0 if check
      check
    end

    def valid_expiry_date?(mrz)
      check = mrz.valid_expiration_date? && mrz.expiration_date == @expiry_date.date_object
      @expiry_date.confidence = 1.0 if check
      check
    end

    def valid_id_number?(mrz)
      check = mrz.valid_document_number? && mrz.document_number == @id_number.value
      @id_number.confidence = 1.0 if check
      check
    end

    def valid_surname?(mrz)
      check = mrz.last_name == @surname.value
      @surname.confidence = 1.0 if check
      check
    end

    def valid_country?(mrz)
      check = mrz.nationality == @country.value
      @country.confidence = 1.0 if check
      check
    end

    def construct_full_name(page_id)
      return unless @surname.value &&
                    !@given_names.empty? &&
                    @given_names[0].value

      full_name = {
        'value' => "#{@given_names[0].value} #{@surname.value}",
        'confidence' => Field.array_confidence([@surname, @given_names[0]]),
      }
      Field.new(full_name, page_id, reconstructed: true)
    end

    def construct_mrz(page_id)
      return if @mrz1.value.nil? || @mrz2.value.nil?

      mrz = {
        'value' => @mrz1.value + @mrz2.value,
        'confidence' => Field.array_confidence([@mrz1, @mrz2]),
      }
      Field.new(mrz, page_id, reconstructed: true)
    end
  end
end
