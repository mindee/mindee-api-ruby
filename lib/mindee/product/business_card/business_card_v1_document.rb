# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module BusinessCard
      # Business Card API version 1.0 document data.
      class BusinessCardV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # The address of the person.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :address
        # The company the person works for.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :company
        # The email address of the person.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :email
        # The Fax number of the person.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :fax_number
        # The given name of the person.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :firstname
        # The job title of the person.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :job_title
        # The lastname of the person.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :lastname
        # The mobile number of the person.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :mobile_number
        # The phone number of the person.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :phone_number
        # The social media profiles of the person or company.
        # @return [Array<Mindee::Parsing::Standard::StringField>]
        attr_reader :social_media
        # The website of the person or company.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :website

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @address = Parsing::Standard::StringField.new(
            prediction['address'],
            page_id
          )
          @company = Parsing::Standard::StringField.new(
            prediction['company'],
            page_id
          )
          @email = Parsing::Standard::StringField.new(prediction['email'], page_id)
          @fax_number = Parsing::Standard::StringField.new(
            prediction['fax_number'],
            page_id
          )
          @firstname = Parsing::Standard::StringField.new(
            prediction['firstname'],
            page_id
          )
          @job_title = Parsing::Standard::StringField.new(
            prediction['job_title'],
            page_id
          )
          @lastname = Parsing::Standard::StringField.new(
            prediction['lastname'],
            page_id
          )
          @mobile_number = Parsing::Standard::StringField.new(
            prediction['mobile_number'],
            page_id
          )
          @phone_number = Parsing::Standard::StringField.new(
            prediction['phone_number'],
            page_id
          )
          @social_media = [] # : Array[Parsing::Standard::StringField]
          prediction['social_media'].each do |item|
            @social_media.push(Parsing::Standard::StringField.new(item, page_id))
          end
          @website = Parsing::Standard::StringField.new(
            prediction['website'],
            page_id
          )
        end

        # @return [String]
        def to_s
          social_media = @social_media.join("\n #{' ' * 14}")
          out_str = String.new
          out_str << "\n:Firstname: #{@firstname}".rstrip
          out_str << "\n:Lastname: #{@lastname}".rstrip
          out_str << "\n:Job Title: #{@job_title}".rstrip
          out_str << "\n:Company: #{@company}".rstrip
          out_str << "\n:Email: #{@email}".rstrip
          out_str << "\n:Phone Number: #{@phone_number}".rstrip
          out_str << "\n:Mobile Number: #{@mobile_number}".rstrip
          out_str << "\n:Fax Number: #{@fax_number}".rstrip
          out_str << "\n:Address: #{@address}".rstrip
          out_str << "\n:Website: #{@website}".rstrip
          out_str << "\n:Social Media: #{social_media}".rstrip
          out_str[1..].to_s
        end
      end
    end
  end
end
