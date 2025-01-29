# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'w9_v1_document'

module Mindee
  module Product
    module US
      module W9
        # W9 API version 1.0 page data.
        class W9V1Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = if prediction['prediction'].empty?
                            nil
                          else
                            W9V1PagePrediction.new(
                              prediction['prediction'],
                              prediction['id']
                            )
                          end
          end
        end

        # W9 V1 page prediction.
        class W9V1PagePrediction < W9V1Document
          include Mindee::Parsing::Standard

          # The street address (number, street, and apt. or suite no.) of the applicant.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :address
          # The business name or disregarded entity name, if different from Name.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :business_name
          # The city, state, and ZIP code of the applicant.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :city_state_zip
          # The employer identification number.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :ein
          # Name as shown on the applicant's income tax return.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :name
          # Position of the signature date on the document.
          # @return [Mindee::Parsing::Standard::PositionField]
          attr_reader :signature_date_position
          # Position of the signature on the document.
          # @return [Mindee::Parsing::Standard::PositionField]
          attr_reader :signature_position
          # The applicant's social security number.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :ssn
          # The federal tax classification, which can vary depending on the revision date.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :tax_classification
          # Depending on revision year, among S, C, P or D for Limited Liability Company Classification.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :tax_classification_llc
          # Tax Classification Other Details.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :tax_classification_other_details
          # The Revision month and year of the W9 form.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :w9_revision_date

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            @address = StringField.new(prediction['address'], page_id)
            @business_name = StringField.new(prediction['business_name'], page_id)
            @city_state_zip = StringField.new(prediction['city_state_zip'], page_id)
            @ein = StringField.new(prediction['ein'], page_id)
            @name = StringField.new(prediction['name'], page_id)
            @signature_date_position = PositionField.new(prediction['signature_date_position'], page_id)
            @signature_position = PositionField.new(prediction['signature_position'], page_id)
            @ssn = StringField.new(prediction['ssn'], page_id)
            @tax_classification = StringField.new(prediction['tax_classification'], page_id)
            @tax_classification_llc = StringField.new(prediction['tax_classification_llc'], page_id)
            @tax_classification_other_details = StringField.new(prediction['tax_classification_other_details'], page_id)
            @w9_revision_date = StringField.new(prediction['w9_revision_date'], page_id)
            super()
          end

          # @return [String]
          def to_s
            out_str = String.new
            out_str << "\n:Name: #{@name}".rstrip
            out_str << "\n:SSN: #{@ssn}".rstrip
            out_str << "\n:Address: #{@address}".rstrip
            out_str << "\n:City State Zip: #{@city_state_zip}".rstrip
            out_str << "\n:Business Name: #{@business_name}".rstrip
            out_str << "\n:EIN: #{@ein}".rstrip
            out_str << "\n:Tax Classification: #{@tax_classification}".rstrip
            out_str << "\n:Tax Classification Other Details: #{@tax_classification_other_details}".rstrip
            out_str << "\n:W9 Revision Date: #{@w9_revision_date}".rstrip
            out_str << "\n:Signature Position: #{@signature_position}".rstrip
            out_str << "\n:Signature Date Position: #{@signature_date_position}".rstrip
            out_str << "\n:Tax Classification LLC: #{@tax_classification_llc}".rstrip
            out_str
          end
        end
      end
    end
  end
end
