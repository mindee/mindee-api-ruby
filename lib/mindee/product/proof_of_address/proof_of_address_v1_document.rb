# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module ProofOfAddress
      # Proof of Address V1 document prediction.
      class ProofOfAddressV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # The locale detected on the document.
        # @return [Mindee::Parsing::Standard::Locale]
        attr_reader :locale
        # The name of the person or company issuing the document.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :issuer_name
        # List of company registrations found for the issuer.
        # @return [Array<Mindee::CompanyRegistrationField>]
        attr_reader :issuer_company_registration
        # The address of the document's issuer.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :issuer_address
        # The name of the person or company receiving the document.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :recipient_name
        # List of company registrations found for the recipient.
        # @return [Array<Mindee::CompanyRegistrationField>]
        attr_reader :recipient_company_registration
        # The address of the recipient.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :recipient_address
        # List of dates found on the document.
        # @return [Array<Mindee::Parsing::Standard::DateField>]
        attr_reader :dates
        # The date the document was issued.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :date

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super()
          @locale = Locale.new(prediction['locale'], page_id)
          @issuer_name = TextField.new(prediction['issuer_name'], page_id)
          @issuer_company_registration = []
          prediction['issuer_company_registration'].each do |item|
            @issuer_company_registration.push(CompanyRegistration.new(item, page_id))
          end
          @issuer_address = TextField.new(prediction['issuer_address'], page_id)
          @recipient_name = TextField.new(prediction['recipient_name'], page_id)
          @recipient_company_registration = []
          prediction['recipient_company_registration'].each do |item|
            @recipient_company_registration.push(CompanyRegistration.new(item, page_id))
          end
          @recipient_address = TextField.new(prediction['recipient_address'], page_id)
          @dates = []
          prediction['dates'].each do |item|
            @dates.push(DateField.new(item, page_id))
          end
          @date = DateField.new(prediction['date'], page_id)
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
