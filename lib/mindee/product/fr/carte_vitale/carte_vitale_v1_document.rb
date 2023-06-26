# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module CarteVitale
        # Carte Vitale V1 document prediction.
        class CarteVitaleV1Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Common
          include Mindee::Parsing::Standard
          # The given name(s) of the card holder.
          # @return [Array<Mindee::Parsing::Standard::TextField>]
          attr_reader :given_names
          # The surname of the card holder.
          # @return [Mindee::Parsing::Standard::TextField]
          attr_reader :surname
          # The Social Security Number (Numéro de Sécurité Sociale) of the card holder
          # @return [Mindee::Parsing::Standard::TextField]
          attr_reader :social_security
          # The date the card was issued.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :issuance_date

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super()
            @given_names = []
            prediction['given_names'].each do |item|
              @given_names.push(TextField.new(item, page_id))
            end
            @surname = TextField.new(prediction['surname'], page_id)
            @social_security = TextField.new(prediction['social_security'], page_id)
            @issuance_date = DateField.new(prediction['issuance_date'], page_id)
          end

          # @return [String]
          def to_s
            given_names = @given_names.join("\n #{' ' * 15}")
            out_str = String.new
            out_str << "\n:Given Name(s): #{given_names}".rstrip
            out_str << "\n:Surname: #{@surname}".rstrip
            out_str << "\n:Social Security Number: #{@social_security}".rstrip
            out_str << "\n:Issuance Date: #{@issuance_date}".rstrip
            out_str[1..].to_s
          end
        end
      end
    end
  end
end
