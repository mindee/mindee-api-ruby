# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module ProofOfAddress
      # Proof of Address API version 1.1 document data.
      class ProofOfAddressV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # The date the document was issued.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :date
        # List of dates found on the document.
        # @return [Array<Mindee::Parsing::Standard::DateField>]
        attr_reader :dates
        # The address of the document's issuer.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :issuer_address
        # List of company registrations found for the issuer.
        # @return [Array<Mindee::Parsing::Standard::CompanyRegistrationField>]
        attr_reader :issuer_company_registration
        # The name of the person or company issuing the document.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :issuer_name
        # The locale detected on the document.
        # @return [Mindee::Parsing::Standard::LocaleField]
        attr_reader :locale
        # The address of the recipient.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :recipient_address
        # List of company registrations found for the recipient.
        # @return [Array<Mindee::Parsing::Standard::CompanyRegistrationField>]
        attr_reader :recipient_company_registration
        # The name of the person or company receiving the document.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :recipient_name

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super()
          @date = DateField.new(prediction['date'], page_id)
          @dates = []
          prediction['dates'].each do |item|
            @dates.push(DateField.new(item, page_id))
          end
          @issuer_address = StringField.new(prediction['issuer_address'], page_id)
          @issuer_company_registration = []
          prediction['issuer_company_registration'].each do |item|
            @issuer_company_registration.push(CompanyRegistrationField.new(item, page_id))
          end
          @issuer_name = StringField.new(prediction['issuer_name'], page_id)
          @locale = LocaleField.new(prediction['locale'], page_id)
          @recipient_address = StringField.new(prediction['recipient_address'], page_id)
          @recipient_company_registration = []
          prediction['recipient_company_registration'].each do |item|
            @recipient_company_registration.push(CompanyRegistrationField.new(item, page_id))
          end
          @recipient_name = StringField.new(prediction['recipient_name'], page_id)
        end

        # @return [String]
        def to_s
          issuer_company_registration = @issuer_company_registration.join("\n #{' ' * 30}")
          recipient_company_registration = @recipient_company_registration.join("\n #{' ' * 33}")
          dates = @dates.join("\n #{' ' * 7}")
          out_str = String.new
          out_str << "\n:Locale: #{@locale}".rstrip
          out_str << "\n:Issuer Name: #{@issuer_name}".rstrip
          out_str << "\n:Issuer Company Registrations: #{issuer_company_registration}".rstrip
          out_str << "\n:Issuer Address: #{@issuer_address}".rstrip
          out_str << "\n:Recipient Name: #{@recipient_name}".rstrip
          out_str << "\n:Recipient Company Registrations: #{recipient_company_registration}".rstrip
          out_str << "\n:Recipient Address: #{@recipient_address}".rstrip
          out_str << "\n:Dates: #{dates}".rstrip
          out_str << "\n:Date of Issue: #{@date}".rstrip
          out_str[1..].to_s
        end
      end
    end
  end
end
