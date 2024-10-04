# frozen_string_literal: true

require 'stringio'
require 'marcel'

require_relative '../pdf'
require_relative '../image'

module Mindee
  module Input
    # Document source handling.
    module Source
      # Mime types accepted by the server.
      ALLOWED_MIME_TYPES = [
        'application/pdf',
        'image/heic',
        'image/png',
        'image/jpeg',
        'image/tiff',
        'image/webp',
      ].freeze

      # Standard error for invalid mime types
      class MimeTypeError < StandardError
      end

      # Error sent if the file's mimetype isn't allowed
      class InvalidMimeTypeError < MimeTypeError
        # @return [String]
        attr_reader :invalid_mimetype

        # @param mime_type [String]
        def initialize(mime_type)
          @invalid_mimetype = mime_type
          super("'#{@invalid_mimetype}' mime type not allowed, must be one of #{ALLOWED_MIME_TYPES.join(', ')}")
        end
      end

      # Error sent if a pdf file couldn't be fixed
      class UnfixablePDFError < MimeTypeError
        def initialize
          super("Corrupted PDF couldn't be repaired.")
        end
      end

      # Base class for loading documents.
      class LocalInputSource
        # @return [String]
        attr_reader :filename
        # @return [String]
        attr_reader :file_mimetype
        # @return [StringIO]
        attr_reader :io_stream

        # @param io_stream [StringIO]
        # @param filename [String]
        # @param fix_pdf [Boolean]
        def initialize(io_stream, filename, fix_pdf: false)
          @io_stream = io_stream
          @filename = filename
          @file_mimetype = if fix_pdf
                             Marcel::MimeType.for @io_stream
                           else
                             Marcel::MimeType.for @io_stream, name: @filename
                           end
          return if ALLOWED_MIME_TYPES.include? @file_mimetype

          if filename.end_with?('.pdf') && fix_pdf
            rescue_broken_pdf(@io_stream)
            @file_mimetype = Marcel::MimeType.for @io_stream

            return if ALLOWED_MIME_TYPES.include? @file_mimetype
          end

          raise InvalidMimeTypeError, @file_mimetype.to_s
        end

        # Attempts to fix pdf files if mimetype is rejected.
        # "Broken PDFs" are often a result of third-party injecting invalid headers.
        # This attempts to remove them and send the file
        # @param stream [StringIO]
        def rescue_broken_pdf(stream)
          stream.gets('%PDF-')
          raise UnfixablePDFError if stream.eof? || stream.pos > 500

          stream.pos = stream.pos - 5
          data = stream.read
          @io_stream.close

          @io_stream = StringIO.new
          @io_stream << data
        end

        # Shorthand for pdf mimetype validation.
        def pdf?
          @file_mimetype.to_s == 'application/pdf'
        end

        # Parses a PDF file according to provided options.
        # @param options [Hash, nil] Page cutting/merge options:
        #
        #  * `:page_indexes` Zero-based list of page indexes.
        #  * `:operation` Operation to apply on the document, given the `page_indexes specified:
        #      * `:KEEP_ONLY` - keep only the specified pages, and remove all others.
        #      * `:REMOVE` - remove the specified pages, and keep all others.
        #  * `:on_min_pages` Apply the operation only if document has at least this many pages.
        def process_pdf(options)
          @io_stream.seek(0)
          @io_stream = PdfProcessor.parse(@io_stream, options)
        end

        # Reads a document.
        # @param close [Boolean]
        # @return [Array<String, [String, aBinaryString ], [Hash, nil] >]
        def read_document(close: true)
          @io_stream.seek(0)
          # Avoids needlessly re-packing some files
          data = @io_stream.read
          @io_stream.close if close
          ['document', data, { filename: Mindee::Input::Source.convert_to_unicode_escape(@filename) }]
        end

        def count_pdf_pages
          return 1 unless pdf?

          @io_stream.seek(0)
          pdf_processor = Mindee::PDF::PdfProcessor.open_pdf(@io_stream)
          pdf_processor.pages.size
        end

        # Compresses the file, according to the provided info.
        # @param [Integer] quality Quality of the output file.
        # @param [Integer, nil] max_width Maximum width (Ignored for PDFs).
        # @param [Integer, nil] max_height Maximum height (Ignored for PDFs).
        # @param [Boolean] force_source_text Whether to force the operation on PDFs with source text.
        #   This will attempt to re-render PDF text over the rasterized original. If disabled, ignored the operation.
        #   WARNING: this operation is strongly discouraged.
        # @param [Boolean] disable_source_text If the PDF has source text, whether to re-apply it to the original or
        #   not. Needs force_source_text to work.
        def compress(quality: 85, max_width: nil, max_height: nil, force_source_text: false, disable_source_text: true)
          if pdf?
            puts "TODO #{force_source_text}|#{disable_source_text}"
          else
            @io_stream.rewind
            buffer = Mindee::Image::ImageCompressor.compress_image(
              @io_stream,
              quality: quality,
              max_width: max_width,
              max_height: max_height
            )
            @io_stream = buffer
          end
        end
      end

      # Load a document from a path.
      class PathInputSource < LocalInputSource
        # @param filepath [String]
        # @param fix_pdf [Boolean]
        def initialize(filepath, fix_pdf: false)
          io_stream = File.open(filepath, 'rb')
          super(io_stream, File.basename(filepath), fix_pdf: fix_pdf)
        end
      end

      # Load a document from a base64 string.
      class Base64InputSource < LocalInputSource
        # @param base64_string [String]
        # @param filename [String]
        # @param fix_pdf [Boolean]
        def initialize(base64_string, filename, fix_pdf: false)
          io_stream = StringIO.new(base64_string.unpack1('m*'))
          io_stream.set_encoding Encoding::BINARY
          super(io_stream, filename, fix_pdf: fix_pdf)
        end

        # Overload of the same function to prevent a base64 from being re-encoded.
        # @param close [Boolean]
        # @return [Array<String, [String, aBinaryString ], [Hash, nil] >]
        def read_document(close: true)
          @io_stream.seek(0)
          data = @io_stream.read
          @io_stream.close if close
          ['document', [data].pack('m'), { filename: Source.convert_to_unicode_escape(@filename) }]
        end
      end

      # Load a document from raw bytes.
      class BytesInputSource < LocalInputSource
        # @param raw_bytes [String]
        # @param filename [String]
        # @param fix_pdf [Boolean]
        def initialize(raw_bytes, filename, fix_pdf: false)
          io_stream = StringIO.new(raw_bytes)
          io_stream.set_encoding Encoding::BINARY
          super(io_stream, filename, fix_pdf: fix_pdf)
        end
      end

      # Load a document from a file handle.
      class FileInputSource < LocalInputSource
        # @param input_file [File]
        # @param filename [String]
        # @param fix_pdf [Boolean]
        def initialize(input_file, filename, fix_pdf: false)
          io_stream = input_file
          super(io_stream, filename, fix_pdf: fix_pdf)
        end
      end

      # Load a remote document from a file url.
      class UrlInputSource
        # @return [String]
        attr_reader :url

        def initialize(url)
          raise 'URL must be HTTPS' unless url.start_with? 'https://'

          @url = url
        end
      end

      # Replaces non-ASCII characters by their unicode escape sequence.
      # Keeps other characters as is.
      # @return A clean String.
      def self.convert_to_unicode_escape(string)
        unicode_escape_string = ''.dup
        string.each_char do |char|
          unicode_escape_string << if char.bytesize > 1
                                     "\\u#{char.unpack1('U').to_s(16).rjust(4, '0')}"
                                   else
                                     char
                                   end
        end
        unicode_escape_string
      end
    end
  end
end
