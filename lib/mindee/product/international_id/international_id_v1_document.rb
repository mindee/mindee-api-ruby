# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module InternationalId
      # International ID V1 document prediction.
      class InternationalIdV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # The physical location of the document holder's residence.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :address
        # The date of birth of the document holder.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :birth_date
        # The location where the document holder was born.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :birth_place
        # The country that issued the identification document.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :country_of_issue
        # The unique identifier assigned to the identification document.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :document_number
        # The type of identification document being used.
        # @return [Mindee::Parsing::Standard::ClassificationField]
        attr_reader :document_type
        # The date when the document will no longer be valid for use.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :expiry_date
        # The first names or given names of the document holder.
        # @return [Array<Mindee::Parsing::Standard::StringField>]
        attr_reader :given_names
        # The date when the document was issued.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :issue_date
        # First line of information in a standardized format for easy machine reading and processing.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :mrz1
        # Second line of information in a standardized format for easy machine reading and processing.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :mrz2
        # Third line of information in a standardized format for easy machine reading and processing.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :mrz3
        # Indicates the country of citizenship or nationality of the document holder.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :nationality
        # The document holder's biological sex, such as male or female.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :sex
        # The surnames of the document holder.
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
          @mrz1 = StringField.new(prediction['mrz1'], page_id)
          @mrz2 = StringField.new(prediction['mrz2'], page_id)
          @mrz3 = StringField.new(prediction['mrz3'], page_id)
          @nationality = StringField.new(prediction['nationality'], page_id)
          @sex = StringField.new(prediction['sex'], page_id)
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
          out_str << "\n:Country of Issue: #{@country_of_issue}".rstrip
          out_str << "\n:Surnames: #{surnames}".rstrip
          out_str << "\n:Given Names: #{given_names}".rstrip
          out_str << "\n:Gender: #{@sex}".rstrip
          out_str << "\n:Birth date: #{@birth_date}".rstrip
          out_str << "\n:Birth Place: #{@birth_place}".rstrip
          out_str << "\n:Nationality: #{@nationality}".rstrip
          out_str << "\n:Issue Date: #{@issue_date}".rstrip
          out_str << "\n:Expiry Date: #{@expiry_date}".rstrip
          out_str << "\n:Address: #{@address}".rstrip
          out_str << "\n:Machine Readable Zone Line 1: #{@mrz1}".rstrip
          out_str << "\n:Machine Readable Zone Line 2: #{@mrz2}".rstrip
          out_str << "\n:Machine Readable Zone Line 3: #{@mrz3}".rstrip
          out_str[1..].to_s
        end
      end
    end
  end
end
