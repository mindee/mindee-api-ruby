# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module InternationalId
      # International ID V2 document prediction.
      class InternationalIdV2Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # The physical address of the document holder.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :address
        # The date of birth of the document holder.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :birth_date
        # The place of birth of the document holder.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :birth_place
        # The country where the document was issued.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :country_of_issue
        # The unique identifier assigned to the document.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :document_number
        # The type of personal identification document.
        # @return [Mindee::Parsing::Standard::ClassificationField]
        attr_reader :document_type
        # The date when the document becomes invalid.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :expiry_date
        # The list of the document holder's given names.
        # @return [Array<Mindee::Parsing::Standard::StringField>]
        attr_reader :given_names
        # The date when the document was issued.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :issue_date
        # The Machine Readable Zone, first line.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :mrz_line1
        # The Machine Readable Zone, second line.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :mrz_line2
        # The Machine Readable Zone, third line.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :mrz_line3
        # The country of citizenship of the document holder.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :nationality
        # The unique identifier assigned to the document holder.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :personal_number
        # The biological sex of the document holder.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :sex
        # The state or territory where the document was issued.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :state_of_issue
        # The list of the document holder's family names.
        # @return [Array<Mindee::Parsing::Standard::StringField>]
        attr_reader :surnames

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super()
          @address = StringField.new(prediction['address'], page_id)
          @birth_date = DateField.new(prediction['birth_date'], page_id)
          @birth_place = StringField.new(prediction['birth_place'], page_id)
          @country_of_issue = StringField.new(prediction['country_of_issue'], page_id)
          @document_number = StringField.new(prediction['document_number'], page_id)
          @document_type = ClassificationField.new(prediction['document_type'], page_id)
          @expiry_date = DateField.new(prediction['expiry_date'], page_id)
          @given_names = []
          prediction['given_names'].each do |item|
            @given_names.push(StringField.new(item, page_id))
          end
          @issue_date = DateField.new(prediction['issue_date'], page_id)
          @mrz_line1 = StringField.new(prediction['mrz_line1'], page_id)
          @mrz_line2 = StringField.new(prediction['mrz_line2'], page_id)
          @mrz_line3 = StringField.new(prediction['mrz_line3'], page_id)
          @nationality = StringField.new(prediction['nationality'], page_id)
          @personal_number = StringField.new(prediction['personal_number'], page_id)
          @sex = StringField.new(prediction['sex'], page_id)
          @state_of_issue = StringField.new(prediction['state_of_issue'], page_id)
          @surnames = []
          prediction['surnames'].each do |item|
            @surnames.push(StringField.new(item, page_id))
          end
        end

        # @return [String]
        def to_s
          surnames = @surnames.join("\n #{' ' * 10}")
          given_names = @given_names.join("\n #{' ' * 13}")
          out_str = String.new
          out_str << "\n:Document Type: #{@document_type}".rstrip
          out_str << "\n:Document Number: #{@document_number}".rstrip
          out_str << "\n:Surnames: #{surnames}".rstrip
          out_str << "\n:Given Names: #{given_names}".rstrip
          out_str << "\n:Sex: #{@sex}".rstrip
          out_str << "\n:Birth Date: #{@birth_date}".rstrip
          out_str << "\n:Birth Place: #{@birth_place}".rstrip
          out_str << "\n:Nationality: #{@nationality}".rstrip
          out_str << "\n:Personal Number: #{@personal_number}".rstrip
          out_str << "\n:Country of Issue: #{@country_of_issue}".rstrip
          out_str << "\n:State of Issue: #{@state_of_issue}".rstrip
          out_str << "\n:Issue Date: #{@issue_date}".rstrip
          out_str << "\n:Expiration Date: #{@expiry_date}".rstrip
          out_str << "\n:Address: #{@address}".rstrip
          out_str << "\n:MRZ Line 1: #{@mrz_line1}".rstrip
          out_str << "\n:MRZ Line 2: #{@mrz_line2}".rstrip
          out_str << "\n:MRZ Line 3: #{@mrz_line3}".rstrip
          out_str[1..].to_s
        end
      end
    end
  end
end
