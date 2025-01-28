# frozen_string_literal: true

require 'stringio'
require 'marcel'

require_relative '../../pdf'
require_relative '../../image'

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

          raise Errors::MindeeMimeTypeError, @file_mimetype.to_s
        end

        # Attempts to fix pdf files if mimetype is rejected.
        # "Broken PDFs" are often a result of third-party injecting invalid headers.
        # This attempts to remove them and send the file
        # @param stream [StringIO]
        def rescue_broken_pdf(stream)
          stream.gets('%PDF-')
          raise Errors::MindeePDFError if stream.eof? || stream.pos > 500

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
        def compress!(quality: 85, max_width: nil, max_height: nil, force_source_text: false, disable_source_text: true)
          buffer = if pdf?
                     Mindee::PDF::PDFCompressor.compress_pdf(
                       @io_stream,
                       quality: quality,
                       force_source_text_compression: force_source_text,
                       disable_source_text: disable_source_text
                     )
                   else
                     Mindee::Image::ImageCompressor.compress_image(
                       @io_stream,
                       quality: quality,
                       max_width: max_width,
                       max_height: max_height
                     )
                   end
          @io_stream = buffer
          @io_stream.rewind
        end

        # Checks whether the file has source text if it is a pdf. False otherwise
        # @return [Boolean] True if the file is a PDF and has source text.
        def source_text?
          Mindee::PDF::PDFTools.source_text?(@io_stream)
        end
      end

      # Replaces non-ASCII characters by their UNICODE escape sequence.
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
