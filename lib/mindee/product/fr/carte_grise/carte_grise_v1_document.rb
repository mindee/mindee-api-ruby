# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module CarteGrise
        # Carte Grise API version 1.1 document data.
        class CarteGriseV1Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Standard
          # The vehicle's license plate number.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :a
          # The vehicle's first release date.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :b
          # The vehicle owner's full name including maiden name.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :c1
          # The vehicle owner's address.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :c3
          # Number of owners of the license certificate.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :c41
          # Mentions about the ownership of the vehicle.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :c4a
          # The vehicle's brand.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :d1
          # The vehicle's commercial name.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :d3
          # The Vehicle Identification Number (VIN).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :e
          # The vehicle's maximum admissible weight.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :f1
          # The vehicle's maximum admissible weight within the license's state.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :f2
          # The vehicle's maximum authorized weight with coupling.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :f3
          # The document's formula number.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :formula_number
          # The vehicle's weight with coupling if tractor different than category M1.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :g
          # The vehicle's national empty weight.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :g1
          # The car registration date of the given certificate.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :i
          # The vehicle's category.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :j
          # The vehicle's national type.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :j1
          # The vehicle's body type (CE).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :j2
          # The vehicle's body type (National designation).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :j3
          # Machine Readable Zone, first line.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :mrz1
          # Machine Readable Zone, second line.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :mrz2
          # The vehicle's owner first name.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :owner_first_name
          # The vehicle's owner surname.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :owner_surname
          # The vehicle engine's displacement (cm3).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :p1
          # The vehicle's maximum net power (kW).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :p2
          # The vehicle's fuel type or energy source.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :p3
          # The vehicle's administrative power (fiscal horsepower).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :p6
          # The vehicle's power to weight ratio.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :q
          # The vehicle's number of seats.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :s1
          # The vehicle's number of standing rooms (person).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :s2
          # The vehicle's sound level (dB).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :u1
          # The vehicle engine's rotation speed (RPM).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :u2
          # The vehicle's CO2 emission (g/km).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :v7
          # Next technical control date.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :x1
          # Amount of the regional proportional tax of the registration (in euros).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :y1
          # Amount of the additional parafiscal tax of the registration (in euros).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :y2
          # Amount of the additional CO2 tax of the registration (in euros).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :y3
          # Amount of the fee for managing the registration (in euros).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :y4
          # Amount of the fee for delivery of the registration certificate in euros.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :y5
          # Total amount of registration fee to be paid in euros.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :y6

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super(prediction, page_id)
            @a = Parsing::Standard::StringField.new(prediction['a'], page_id)
            @b = Parsing::Standard::DateField.new(prediction['b'], page_id)
            @c1 = Parsing::Standard::StringField.new(prediction['c1'], page_id)
            @c3 = Parsing::Standard::StringField.new(prediction['c3'], page_id)
            @c41 = Parsing::Standard::StringField.new(prediction['c41'], page_id)
            @c4a = Parsing::Standard::StringField.new(prediction['c4a'], page_id)
            @d1 = Parsing::Standard::StringField.new(prediction['d1'], page_id)
            @d3 = Parsing::Standard::StringField.new(prediction['d3'], page_id)
            @e = Parsing::Standard::StringField.new(prediction['e'], page_id)
            @f1 = Parsing::Standard::StringField.new(prediction['f1'], page_id)
            @f2 = Parsing::Standard::StringField.new(prediction['f2'], page_id)
            @f3 = Parsing::Standard::StringField.new(prediction['f3'], page_id)
            @formula_number = Parsing::Standard::StringField.new(prediction['formula_number'], page_id)
            @g = Parsing::Standard::StringField.new(prediction['g'], page_id)
            @g1 = Parsing::Standard::StringField.new(prediction['g1'], page_id)
            @i = Parsing::Standard::DateField.new(prediction['i'], page_id)
            @j = Parsing::Standard::StringField.new(prediction['j'], page_id)
            @j1 = Parsing::Standard::StringField.new(prediction['j1'], page_id)
            @j2 = Parsing::Standard::StringField.new(prediction['j2'], page_id)
            @j3 = Parsing::Standard::StringField.new(prediction['j3'], page_id)
            @mrz1 = Parsing::Standard::StringField.new(prediction['mrz1'], page_id)
            @mrz2 = Parsing::Standard::StringField.new(prediction['mrz2'], page_id)
            @owner_first_name = Parsing::Standard::StringField.new(prediction['owner_first_name'], page_id)
            @owner_surname = Parsing::Standard::StringField.new(prediction['owner_surname'], page_id)
            @p1 = Parsing::Standard::StringField.new(prediction['p1'], page_id)
            @p2 = Parsing::Standard::StringField.new(prediction['p2'], page_id)
            @p3 = Parsing::Standard::StringField.new(prediction['p3'], page_id)
            @p6 = Parsing::Standard::StringField.new(prediction['p6'], page_id)
            @q = Parsing::Standard::StringField.new(prediction['q'], page_id)
            @s1 = Parsing::Standard::StringField.new(prediction['s1'], page_id)
            @s2 = Parsing::Standard::StringField.new(prediction['s2'], page_id)
            @u1 = Parsing::Standard::StringField.new(prediction['u1'], page_id)
            @u2 = Parsing::Standard::StringField.new(prediction['u2'], page_id)
            @v7 = Parsing::Standard::StringField.new(prediction['v7'], page_id)
            @x1 = Parsing::Standard::StringField.new(prediction['x1'], page_id)
            @y1 = Parsing::Standard::StringField.new(prediction['y1'], page_id)
            @y2 = Parsing::Standard::StringField.new(prediction['y2'], page_id)
            @y3 = Parsing::Standard::StringField.new(prediction['y3'], page_id)
            @y4 = Parsing::Standard::StringField.new(prediction['y4'], page_id)
            @y5 = Parsing::Standard::StringField.new(prediction['y5'], page_id)
            @y6 = Parsing::Standard::StringField.new(prediction['y6'], page_id)
          end

          # @return [String]
          def to_s
            out_str = String.new
            out_str << "\n:a: #{@a}".rstrip
            out_str << "\n:b: #{@b}".rstrip
            out_str << "\n:c1: #{@c1}".rstrip
            out_str << "\n:c3: #{@c3}".rstrip
            out_str << "\n:c41: #{@c41}".rstrip
            out_str << "\n:c4a: #{@c4a}".rstrip
            out_str << "\n:d1: #{@d1}".rstrip
            out_str << "\n:d3: #{@d3}".rstrip
            out_str << "\n:e: #{@e}".rstrip
            out_str << "\n:f1: #{@f1}".rstrip
            out_str << "\n:f2: #{@f2}".rstrip
            out_str << "\n:f3: #{@f3}".rstrip
            out_str << "\n:g: #{@g}".rstrip
            out_str << "\n:g1: #{@g1}".rstrip
            out_str << "\n:i: #{@i}".rstrip
            out_str << "\n:j: #{@j}".rstrip
            out_str << "\n:j1: #{@j1}".rstrip
            out_str << "\n:j2: #{@j2}".rstrip
            out_str << "\n:j3: #{@j3}".rstrip
            out_str << "\n:p1: #{@p1}".rstrip
            out_str << "\n:p2: #{@p2}".rstrip
            out_str << "\n:p3: #{@p3}".rstrip
            out_str << "\n:p6: #{@p6}".rstrip
            out_str << "\n:q: #{@q}".rstrip
            out_str << "\n:s1: #{@s1}".rstrip
            out_str << "\n:s2: #{@s2}".rstrip
            out_str << "\n:u1: #{@u1}".rstrip
            out_str << "\n:u2: #{@u2}".rstrip
            out_str << "\n:v7: #{@v7}".rstrip
            out_str << "\n:x1: #{@x1}".rstrip
            out_str << "\n:y1: #{@y1}".rstrip
            out_str << "\n:y2: #{@y2}".rstrip
            out_str << "\n:y3: #{@y3}".rstrip
            out_str << "\n:y4: #{@y4}".rstrip
            out_str << "\n:y5: #{@y5}".rstrip
            out_str << "\n:y6: #{@y6}".rstrip
            out_str << "\n:Formula Number: #{@formula_number}".rstrip
            out_str << "\n:Owner's First Name: #{@owner_first_name}".rstrip
            out_str << "\n:Owner's Surname: #{@owner_surname}".rstrip
            out_str << "\n:MRZ Line 1: #{@mrz1}".rstrip
            out_str << "\n:MRZ Line 2: #{@mrz2}".rstrip
            out_str[1..].to_s
          end
        end
      end
    end
  end
end
