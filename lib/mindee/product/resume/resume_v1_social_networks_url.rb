# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module Resume
      # The list of social network profiles of the candidate.
      class ResumeV1SocialNetworksUrl < Mindee::Parsing::Standard::FeatureField
        include Mindee::Parsing::Standard
        # The name of the social network.
        # @return [String]
        attr_reader :name
        # The URL of the social network.
        # @return [String]
        attr_reader :url

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super(prediction, page_id)
          @name = prediction['name']
          @url = prediction['url']
          @page_id = page_id
        end

        # @return [Hash]
        def printable_values
          printable = {}
          printable[:name] = format_for_display(@name, 20)
          printable[:url] = format_for_display(@url, 50)
          printable
        end

        # @return [String]
        def to_table_line
          printable = printable_values
          out_str = String.new
          out_str << format('| %- 21s', printable[:name])
          out_str << format('| %- 51s', printable[:url])
          out_str << '|'
        end

        # @return [String]
        def to_s
          printable = printable_values
          out_str = String.new
          out_str << "\n  :Name: #{printable[:name]}"
          out_str << "\n  :URL: #{printable[:url]}"
          out_str
        end
      end
    end
  end
end
