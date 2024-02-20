# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'resume_v1_social_networks_url'
require_relative 'resume_v1_language'
require_relative 'resume_v1_education'
require_relative 'resume_v1_professional_experience'
require_relative 'resume_v1_certificate'

module Mindee
  module Product
    module Resume
      # Resume V1 document prediction.
      class ResumeV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # The location information of the person, including city, state, and country.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :address
        # The list of certificates obtained by the candidate.
        # @return [Array<Mindee::Product::Resume::ResumeV1Certificate>]
        attr_reader :certificates
        # The ISO 639 code of the language in which the document is written.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :document_language
        # The type of the document sent, possible values being RESUME, MOTIVATION_LETTER and
        # RECOMMENDATION_LETTER.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :document_type
        # The list of values that represent the educational background of an individual.
        # @return [Array<Mindee::Product::Resume::ResumeV1Education>]
        attr_reader :education
        # The email address of the candidate.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :email_address
        # The list of names that represent a person's first or given names.
        # @return [Array<Mindee::Parsing::Standard::StringField>]
        attr_reader :given_names
        # The list of specific technical abilities and knowledge mentioned in a resume.
        # @return [Array<Mindee::Parsing::Standard::StringField>]
        attr_reader :hard_skills
        # The specific industry or job role that the applicant is applying for.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :job_applied
        # The list of languages that a person is proficient in, as stated in their resume.
        # @return [Array<Mindee::Product::Resume::ResumeV1Language>]
        attr_reader :languages
        # The ISO 3166 code for the country of citizenship or origin of the person.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :nationality
        # The phone number of the candidate.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :phone_number
        # The area of expertise or specialization in which the individual has professional experience and
        # qualifications.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :profession
        # The list of values that represent the professional experiences of an individual in their global
        # resume.
        # @return [Array<Mindee::Product::Resume::ResumeV1ProfessionalExperience>]
        attr_reader :professional_experiences
        # The list of URLs for social network profiles of the person.
        # @return [Array<Mindee::Product::Resume::ResumeV1SocialNetworksUrl>]
        attr_reader :social_networks_urls
        # The list of values that represent a person's interpersonal and communication abilities in a global
        # resume.
        # @return [Array<Mindee::Parsing::Standard::StringField>]
        attr_reader :soft_skills
        # The list of last names provided in a resume document.
        # @return [Array<Mindee::Parsing::Standard::StringField>]
        attr_reader :surnames

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super()
          @address = StringField.new(prediction['address'], page_id)
          @certificates = []
          prediction['certificates'].each do |item|
            @certificates.push(ResumeV1Certificate.new(item, page_id))
          end
          @document_language = StringField.new(prediction['document_language'], page_id)
          @document_type = StringField.new(prediction['document_type'], page_id)
          @education = []
          prediction['education'].each do |item|
            @education.push(ResumeV1Education.new(item, page_id))
          end
          @email_address = StringField.new(prediction['email_address'], page_id)
          @given_names = []
          prediction['given_names'].each do |item|
            @given_names.push(StringField.new(item, page_id))
          end
          @hard_skills = []
          prediction['hard_skills'].each do |item|
            @hard_skills.push(StringField.new(item, page_id))
          end
          @job_applied = StringField.new(prediction['job_applied'], page_id)
          @languages = []
          prediction['languages'].each do |item|
            @languages.push(ResumeV1Language.new(item, page_id))
          end
          @nationality = StringField.new(prediction['nationality'], page_id)
          @phone_number = StringField.new(prediction['phone_number'], page_id)
          @profession = StringField.new(prediction['profession'], page_id)
          @professional_experiences = []
          prediction['professional_experiences'].each do |item|
            @professional_experiences.push(ResumeV1ProfessionalExperience.new(item, page_id))
          end
          @social_networks_urls = []
          prediction['social_networks_urls'].each do |item|
            @social_networks_urls.push(ResumeV1SocialNetworksUrl.new(item, page_id))
          end
          @soft_skills = []
          prediction['soft_skills'].each do |item|
            @soft_skills.push(StringField.new(item, page_id))
          end
          @surnames = []
          prediction['surnames'].each do |item|
            @surnames.push(StringField.new(item, page_id))
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
