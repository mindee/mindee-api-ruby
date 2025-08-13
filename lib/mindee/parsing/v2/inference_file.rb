# frozen_string_literal: true

module Mindee
  module Parsing
    module V2
      # Information about a file returned in an inference.
      class InferenceFile
        # @return [String] File name.
        attr_reader :name
        # @return [String, nil] Optional alias for the file.
        attr_reader :file_alias
        # @return [Integer] Page count.
        attr_reader :page_count
        # @return [String] MIME type.
        attr_reader :mime_type

        # @param server_response [Hash] Raw JSON parsed into a Hash.
        def initialize(server_response)
          @name       = server_response['name']
          @file_alias = server_response['alias']
          @page_count = server_response['page_count']
          @mime_type  = server_response['mime_type']
        end

        # String representation.
        # @return [String]
        def to_s
          "File\n" \
            "====\n" \
            ":Name: #{@name}\n" \
            ":Alias:#{" #{@file_alias}" if @file_alias}\n" \
            ":Page Count: #{@page_count}\n" \
            ":MIME Type: #{@mime_type}\n"
        end
      end
    end
  end
end
