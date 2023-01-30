# frozen_string_literal: true

require 'mrz'

require_relative '../common_fields'
require_relative '../base'

module Mindee
  module Prediction
    # Passport document.
    class ProofOfAddressV1 < Prediction
      # ISO 639-1 code, works best with ca, de, en, es, fr, it, nl and pt.
      # @return [Mindee::Locale]
      attr_reader :locale
      # ISO date yyyy-mm-dd. Works both for European and US dates.
      # @return [Mindee::DateField]
      attr_reader :date
      # All extracted ISO date yyyy-mm-dd. Works both for European and US dates.
      # @return [Array<Mindee::DateField>]
      attr_reader :dates
      # Address of the document's issuer.
      # @return [Mindee::TextField]
      attr_reader :issuer_address
      # Generic: VAT NUMBER, TAX ID, COMPANY REGISTRATION NUMBER or country specific.
      # @return [Array<Mindee::CompanyRegistration>]
      attr_reader :issuer_company_registration
      # Name of the person or company issuing the document.
      # @return [Mindee::TextField]
      attr_reader :issuer_name
      # Address of the recipient.
      # @return [Mindee::TextField]
      attr_reader :recipient_address
      # Generic: VAT NUMBER, TAX ID, COMPANY REGISTRATION NUMBER or country specific.
      # @return [Array<Mindee::CompanyRegistration>]
      attr_reader :recipient_company_registration
      # Name of the document's recipient.
      # @return [Mindee::TextField]
      attr_reader :recipient_name

      # @param prediction [Hash]
      # @param page_id [Integer, nil]
      def initialize(prediction, page_id)
        super
        @locale = Locale.new(prediction['locale'])
        @date = DateField.new(prediction['date'], page_id)
        @dates = []
        prediction['dates'].each do |item|
          @dates.push(DateField.new(item, page_id))
        end
        @issuer_name = TextField.new(prediction['issuer_name'], page_id)
        @issuer_address = TextField.new(prediction['issuer_address'], page_id)
        @issuer_company_registration = []
        prediction['issuer_company_registration'].each do |item|
          @issuer_company_registration.push(CompanyRegistration.new(item, page_id))
        end
        @recipient_name = TextField.new(prediction['recipient_name'], page_id)
        @recipient_address = TextField.new(prediction['recipient_address'], page_id)
        @recipient_company_registration = []
        prediction['recipient_company_registration'].each do |item|
          @recipient_company_registration.push(CompanyRegistration.new(item, page_id))
        end
      end

      def to_s
        recipient_company_registrations = @recipient_company_registration.join(' ')
        issuer_company_registrations = @issuer_company_registration.join(' ')
        dates = @dates.join("\n        ")
        out_str = String.new
        out_str << "\n:Locale: #{@locale}".rstrip
        out_str << "\n:Issuer name: #{@issuer_name}".rstrip
        out_str << "\n:Issuer Address: #{@issuer_address}".rstrip
        out_str << "\n:Issuer Company Registrations: #{issuer_company_registrations}".rstrip
        out_str << "\n:Recipient name: #{@recipient_name}".rstrip
        out_str << "\n:Recipient Address: #{@recipient_address}".rstrip
        out_str << "\n:Recipient Company Registrations: #{recipient_company_registrations}".rstrip
        out_str << "\n:Issuance date: #{@date}".rstrip
        out_str << "\n:Dates: #{dates}".rstrip
        out_str[1..].to_s
      end
    end
  end
end
