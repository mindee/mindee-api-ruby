# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'resume_v1_social_networks_urls'
require_relative 'resume_v1_languages'
require_relative 'resume_v1_educations'
require_relative 'resume_v1_professional_experiences'
require_relative 'resume_v1_certificates'

module Mindee
  module Product
    module Resume
      # Resume API version 1.2 document data.
      class ResumeV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # The location information of the candidate, including city, state, and country.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :address
        # The list of certificates obtained by the candidate.
        # @return [Mindee::Product::Resume::ResumeV1Certificates]
        attr_reader :certificates
        # The ISO 639 code of the language in which the document is written.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :document_language
        # The type of the document sent.
        # @return [Mindee::Parsing::Standard::ClassificationField]
        attr_reader :document_type
        # The list of the candidate's educational background.
        # @return [Mindee::Product::Resume::ResumeV1Educations]
        attr_reader :education
        # The email address of the candidate.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :email_address
        # The candidate's first or given names.
        # @return [Array<Mindee::Parsing::Standard::StringField>]
        attr_reader :given_names
        # The list of the candidate's technical abilities and knowledge.
        # @return [Array<Mindee::Parsing::Standard::StringField>]
        attr_reader :hard_skills
        # The position that the candidate is applying for.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :job_applied
        # The list of languages that the candidate is proficient in.
        # @return [Mindee::Product::Resume::ResumeV1Languages]
        attr_reader :languages
        # The ISO 3166 code for the country of citizenship of the candidate.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :nationality
        # The phone number of the candidate.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :phone_number
        # The candidate's current profession.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :profession
        # The list of the candidate's professional experiences.
        # @return [Mindee::Product::Resume::ResumeV1ProfessionalExperiences]
        attr_reader :professional_experiences
        # The list of social network profiles of the candidate.
        # @return [Mindee::Product::Resume::ResumeV1SocialNetworksUrls]
        attr_reader :social_networks_urls
        # The list of the candidate's interpersonal and communication abilities.
        # @return [Array<Mindee::Parsing::Standard::StringField>]
        attr_reader :soft_skills
        # The candidate's last names.
        # @return [Array<Mindee::Parsing::Standard::StringField>]
        attr_reader :surnames

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @address = Parsing::Standard::StringField.new(
            prediction['address'],
            page_id
          )
          @certificates = Product::Resume::ResumeV1Certificates.new(prediction['certificates'], page_id)
          @document_language = Parsing::Standard::StringField.new(
            prediction['document_language'],
            page_id
          )
          @document_type = Parsing::Standard::ClassificationField.new(
            prediction['document_type'],
            page_id
          )
          @education = Product::Resume::ResumeV1Educations.new(prediction['education'], page_id)
          @email_address = Parsing::Standard::StringField.new(
            prediction['email_address'],
            page_id
          )
          @given_names = [] # : Array[Parsing::Standard::StringField]
          prediction['given_names'].each do |item|
            @given_names.push(Parsing::Standard::StringField.new(item, page_id))
          end
          @hard_skills = [] # : Array[Parsing::Standard::StringField]
          prediction['hard_skills'].each do |item|
            @hard_skills.push(Parsing::Standard::StringField.new(item, page_id))
          end
          @job_applied = Parsing::Standard::StringField.new(
            prediction['job_applied'],
            page_id
          )
          @languages = Product::Resume::ResumeV1Languages.new(prediction['languages'], page_id)
          @nationality = Parsing::Standard::StringField.new(
            prediction['nationality'],
            page_id
          )
          @phone_number = Parsing::Standard::StringField.new(
            prediction['phone_number'],
            page_id
          )
          @profession = Parsing::Standard::StringField.new(
            prediction['profession'],
            page_id
          )
          @professional_experiences = Product::Resume::ResumeV1ProfessionalExperiences.new(
            prediction['professional_experiences'], page_id
          )
          @social_networks_urls = Product::Resume::ResumeV1SocialNetworksUrls.new(
            prediction['social_networks_urls'], page_id
          )
          @soft_skills = [] # : Array[Parsing::Standard::StringField]
          prediction['soft_skills'].each do |item|
            @soft_skills.push(Parsing::Standard::StringField.new(item, page_id))
          end
          @surnames = [] # : Array[Parsing::Standard::StringField]
          prediction['surnames'].each do |item|
            @surnames.push(Parsing::Standard::StringField.new(item, page_id))
          end
        end

        # @return [String]
        def to_s
          given_names = @given_names.join("\n #{' ' * 13}")
          surnames = @surnames.join("\n #{' ' * 10}")
          social_networks_urls = social_networks_urls_to_s
          languages = languages_to_s
          hard_skills = @hard_skills.join("\n #{' ' * 13}")
          soft_skills = @soft_skills.join("\n #{' ' * 13}")
          education = education_to_s
          professional_experiences = professional_experiences_to_s
          certificates = certificates_to_s
          out_str = String.new
          out_str << "\n:Document Language: #{@document_language}".rstrip
          out_str << "\n:Document Type: #{@document_type}".rstrip
          out_str << "\n:Given Names: #{given_names}".rstrip
          out_str << "\n:Surnames: #{surnames}".rstrip
          out_str << "\n:Nationality: #{@nationality}".rstrip
          out_str << "\n:Email Address: #{@email_address}".rstrip
          out_str << "\n:Phone Number: #{@phone_number}".rstrip
          out_str << "\n:Address: #{@address}".rstrip
          out_str << "\n:Social Networks:"
          out_str << social_networks_urls
          out_str << "\n:Profession: #{@profession}".rstrip
          out_str << "\n:Job Applied: #{@job_applied}".rstrip
          out_str << "\n:Languages:"
          out_str << languages
          out_str << "\n:Hard Skills: #{hard_skills}".rstrip
          out_str << "\n:Soft Skills: #{soft_skills}".rstrip
          out_str << "\n:Education:"
          out_str << education
          out_str << "\n:Professional Experiences:"
          out_str << professional_experiences
          out_str << "\n:Certificates:"
          out_str << certificates
          out_str[1..].to_s
        end

        private

        # @param char [String]
        # @return [String]
        def social_networks_urls_separator(char)
          out_str = String.new
          out_str << '  '
          out_str << "+#{char * 22}"
          out_str << "+#{char * 52}"
          out_str << '+'
          out_str
        end

        # @return [String]
        def social_networks_urls_to_s
          return '' if @social_networks_urls.empty?

          line_items = @social_networks_urls.map(&:to_table_line).join("\n#{social_networks_urls_separator('-')}\n  ")
          out_str = String.new
          out_str << "\n#{social_networks_urls_separator('-')}"
          out_str << "\n  |"
          out_str << ' Name                 |'
          out_str << ' URL                                                |'
          out_str << "\n#{social_networks_urls_separator('=')}"
          out_str << "\n  #{line_items}"
          out_str << "\n#{social_networks_urls_separator('-')}"
          out_str
        end

        # @param char [String]
        # @return [String]
        def languages_separator(char)
          out_str = String.new
          out_str << '  '
          out_str << "+#{char * 10}"
          out_str << "+#{char * 22}"
          out_str << '+'
          out_str
        end

        # @return [String]
        def languages_to_s
          return '' if @languages.empty?

          line_items = @languages.map(&:to_table_line).join("\n#{languages_separator('-')}\n  ")
          out_str = String.new
          out_str << "\n#{languages_separator('-')}"
          out_str << "\n  |"
          out_str << ' Language |'
          out_str << ' Level                |'
          out_str << "\n#{languages_separator('=')}"
          out_str << "\n  #{line_items}"
          out_str << "\n#{languages_separator('-')}"
          out_str
        end

        # @param char [String]
        # @return [String]
        def education_separator(char)
          out_str = String.new
          out_str << '  '
          out_str << "+#{char * 17}"
          out_str << "+#{char * 27}"
          out_str << "+#{char * 11}"
          out_str << "+#{char * 10}"
          out_str << "+#{char * 27}"
          out_str << "+#{char * 13}"
          out_str << "+#{char * 12}"
          out_str << '+'
          out_str
        end

        # @return [String]
        def education_to_s
          return '' if @education.empty?

          line_items = @education.map(&:to_table_line).join("\n#{education_separator('-')}\n  ")
          out_str = String.new
          out_str << "\n#{education_separator('-')}"
          out_str << "\n  |"
          out_str << ' Domain          |'
          out_str << ' Degree                    |'
          out_str << ' End Month |'
          out_str << ' End Year |'
          out_str << ' School                    |'
          out_str << ' Start Month |'
          out_str << ' Start Year |'
          out_str << "\n#{education_separator('=')}"
          out_str << "\n  #{line_items}"
          out_str << "\n#{education_separator('-')}"
          out_str
        end

        # @param char [String]
        # @return [String]
        def professional_experiences_separator(char)
          out_str = String.new
          out_str << '  '
          out_str << "+#{char * 17}"
          out_str << "+#{char * 12}"
          out_str << "+#{char * 38}"
          out_str << "+#{char * 27}"
          out_str << "+#{char * 11}"
          out_str << "+#{char * 10}"
          out_str << "+#{char * 22}"
          out_str << "+#{char * 13}"
          out_str << "+#{char * 12}"
          out_str << '+'
          out_str
        end

        # @return [String]
        def professional_experiences_to_s
          return '' if @professional_experiences.empty?

          line_items = @professional_experiences.map(&:to_table_line).join(
            "\n#{professional_experiences_separator('-')}\n  "
          )
          out_str = String.new
          out_str << "\n#{professional_experiences_separator('-')}"
          out_str << "\n  |"
          out_str << ' Contract Type   |'
          out_str << ' Department |'
          out_str << ' Description                          |'
          out_str << ' Employer                  |'
          out_str << ' End Month |'
          out_str << ' End Year |'
          out_str << ' Role                 |'
          out_str << ' Start Month |'
          out_str << ' Start Year |'
          out_str << "\n#{professional_experiences_separator('=')}"
          out_str << "\n  #{line_items}"
          out_str << "\n#{professional_experiences_separator('-')}"
          out_str
        end

        # @param char [String]
        # @return [String]
        def certificates_separator(char)
          out_str = String.new
          out_str << '  '
          out_str << "+#{char * 12}"
          out_str << "+#{char * 32}"
          out_str << "+#{char * 27}"
          out_str << "+#{char * 6}"
          out_str << '+'
          out_str
        end

        # @return [String]
        def certificates_to_s
          return '' if @certificates.empty?

          line_items = @certificates.map(&:to_table_line).join("\n#{certificates_separator('-')}\n  ")
          out_str = String.new
          out_str << "\n#{certificates_separator('-')}"
          out_str << "\n  |"
          out_str << ' Grade      |'
          out_str << ' Name                           |'
          out_str << ' Provider                  |'
          out_str << ' Year |'
          out_str << "\n#{certificates_separator('=')}"
          out_str << "\n  #{line_items}"
          out_str << "\n#{certificates_separator('-')}"
          out_str
        end
      end
    end
  end
end
