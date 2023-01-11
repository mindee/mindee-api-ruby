# frozen_string_literal: true

require_relative '../../common_fields'
require_relative '../../base'

module Mindee
  module Prediction
    module FR
      # French Carte Vitale
      class CarteVitaleV1 < Prediction
        # List of given (first) names of the cardholder.
        # @return [Array<Mindee::TextField>]
        attr_reader :given_names
        # The surname (last name) of the cardholder.
        # @return [Mindee::TextField]
        attr_reader :surname
        # The social security number of the cardholder.
        # @return [Mindee::TextField]
        attr_reader :social_security
        # The issuance date of the card.
        # @return [Mindee::DateField]
        attr_reader :issuance_date

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @given_names = []
          prediction['given_names'].each do |item|
            @given_names.push(TextField.new(item, page_id))
          end
          @surname = TextField.new(prediction['surname'], page_id)
          @social_security = TextField.new(prediction['social_security'], page_id)
          @issuance_date = DateField.new(prediction['issuance_date'], page_id)
        end

        def to_s
          given_names = @given_names.map(&:value).join(', ')
          out_str = String.new
          out_str << "\n:Given names: #{given_names}".rstrip
          out_str << "\n:Surname: #{@surname}".rstrip
          out_str << "\n:Social Security Number: #{@social_security}".rstrip
          out_str << "\n:Issuance date: #{@issuance_date}".rstrip
          out_str[1..].to_s
        end
      end
    end
  end
end
