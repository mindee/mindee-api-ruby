# frozen_string_literal: true

require 'stringio'

module Mindee
  module Input
    module Source
      # Load a document from a base64 string.
      class Base64InputSource < LocalInputSource
        # @param base64_string [String]
        # @param filename [String]
        # @param repair_pdf [bool]
        def initialize(base64_string, filename, repair_pdf: false)
          io_stream = StringIO.new(base64_string.unpack1('m*').to_s)
          io_stream.set_encoding Encoding::BINARY
          super(io_stream, filename, repair_pdf: repair_pdf)
        end

        # Overload of the same function to prevent a base64 from being re-encoded.
        # @param close [bool]
        # @return [Array<[String, aBinaryString ], [Hash, nil] >]
        def read_contents(close: true)
          @io_stream.seek(0)
          data = @io_stream.read
          @io_stream.close if close
          [[data].pack('m'), { filename: Source.convert_to_unicode_escape(@filename) }]
        end
      end
    end
  end
end
