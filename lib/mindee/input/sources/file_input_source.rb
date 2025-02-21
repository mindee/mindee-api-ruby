# frozen_string_literal: true

require 'stringio'

module Mindee
  module Input
    module Source
      # Load a document from a file handle.
      class FileInputSource < LocalInputSource
        # @param input_file [File]
        # @param filename [String]
        # @param repair_pdf [bool]
        def initialize(input_file, filename, repair_pdf: false)
          io_stream = input_file
          super(io_stream, filename, repair_pdf: repair_pdf)
        end
      end
    end
  end
end
