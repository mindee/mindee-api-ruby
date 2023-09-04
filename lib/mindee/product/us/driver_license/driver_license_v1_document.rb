# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module US
      module DriverLicense
        # Driver License V1 document prediction.
        class DriverLicenseV1Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Standard
          # US driver license holders address
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :address
          # US driver license holders date of birth
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :date_of_birth
          # Document Discriminator Number of the US Driver License
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :dd_number
          # US driver license holders class
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :dl_class
          # ID number of the US Driver License.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :driver_license_id
          # US driver license holders endorsements
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :endorsements
          # Date on which the documents expires.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :expiry_date
          # US driver license holders eye colour
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :eye_color
          # US driver license holders first name(s)
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :first_name
          # US driver license holders hair colour
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :hair_color
          # US driver license holders hight
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :height
          # Date on which the documents was issued.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :issued_date
          # US driver license holders last name
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :last_name
          # US driver license holders restrictions
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :restrictions
          # US driver license holders gender
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :sex
          # US State
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :state
          # US driver license holders weight
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :weight

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super()
            @address = StringField.new(prediction['address'], page_id)
            @date_of_birth = DateField.new(prediction['date_of_birth'], page_id)
            @dd_number = StringField.new(prediction['dd_number'], page_id)
            @dl_class = StringField.new(prediction['dl_class'], page_id)
            @driver_license_id = StringField.new(prediction['driver_license_id'], page_id)
            @endorsements = StringField.new(prediction['endorsements'], page_id)
            @expiry_date = DateField.new(prediction['expiry_date'], page_id)
            @eye_color = StringField.new(prediction['eye_color'], page_id)
            @first_name = StringField.new(prediction['first_name'], page_id)
            @hair_color = StringField.new(prediction['hair_color'], page_id)
            @height = StringField.new(prediction['height'], page_id)
            @issued_date = DateField.new(prediction['issued_date'], page_id)
            @last_name = StringField.new(prediction['last_name'], page_id)
            @restrictions = StringField.new(prediction['restrictions'], page_id)
            @sex = StringField.new(prediction['sex'], page_id)
            @state = StringField.new(prediction['state'], page_id)
            @weight = StringField.new(prediction['weight'], page_id)
          end

          # @return [String]
          def to_s
            out_str = String.new
            out_str << "\n:State: #{@state}".rstrip
            out_str << "\n:Driver License ID: #{@driver_license_id}".rstrip
            out_str << "\n:Expiry Date: #{@expiry_date}".rstrip
            out_str << "\n:Date Of Issue: #{@issued_date}".rstrip
            out_str << "\n:Last Name: #{@last_name}".rstrip
            out_str << "\n:First Name: #{@first_name}".rstrip
            out_str << "\n:Address: #{@address}".rstrip
            out_str << "\n:Date Of Birth: #{@date_of_birth}".rstrip
            out_str << "\n:Restrictions: #{@restrictions}".rstrip
            out_str << "\n:Endorsements: #{@endorsements}".rstrip
            out_str << "\n:Driver License Class: #{@dl_class}".rstrip
            out_str << "\n:Sex: #{@sex}".rstrip
            out_str << "\n:Height: #{@height}".rstrip
            out_str << "\n:Weight: #{@weight}".rstrip
            out_str << "\n:Hair Color: #{@hair_color}".rstrip
            out_str << "\n:Eye Color: #{@eye_color}".rstrip
            out_str << "\n:Document Discriminator: #{@dd_number}".rstrip
            out_str[1..].to_s
          end
        end
      end
    end
  end
end
