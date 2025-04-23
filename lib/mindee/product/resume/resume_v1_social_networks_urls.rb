# frozen_string_literal: true

require_relative 'resume_v1_social_networks_url'
require_relative 'resume_v1_language'
require_relative 'resume_v1_education'
require_relative 'resume_v1_professional_experience'
require_relative 'resume_v1_certificate'

module Mindee
  module Product
    module Resume
      # The list of social network profiles of the candidate.
      class ResumeV1SocialNetworksUrls < Array
        # Entries.
        # @return [Array<ResumeV1SocialNetworksUrl>]
        attr_reader :entries

        # @param prediction [Array]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          entries = prediction.map do |entry|
            Resume::ResumeV1SocialNetworksUrl.new(entry, page_id)
          end
          super(entries)
        end

        # Creates a line of rST table-compliant string separators.
        # @param char [String] Character to use as a separator.
        # @return [String]
        def self.line_items_separator(char)
          out_str = String.new
          out_str << "+#{char * 22}"
          out_str << "+#{char * 52}"
          out_str
        end

        # @return [String]
        def to_s
          return '' if empty?

          lines = map do |entry|
            "\n  #{entry.to_table_line}\n#{self.class.line_items_separator('-')}"
          end.join
          out_str = String.new
          out_str << "\n#{self.class.line_items_separator('-')}\n "
          out_str << ' | Name                '
          out_str << ' | URL                                               '
          out_str << " |\n#{self.class.line_items_separator('=')}"
          out_str + lines
        end
      end
    end
  end
end
