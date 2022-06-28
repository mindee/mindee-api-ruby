# frozen_string_literal: true

require 'stringio'
require 'origami'
require 'marcel'

# Monkey-patching for Origami
module PDFTools
  def to_io_stream(params = {})
    options = {
      delinearize: true,
      recompile: true,
      decrypt: false,
    }
    options.update(params)

    if frozen? # incompatible flags with frozen doc (signed)
      options[:recompile] = nil
      options[:rebuild_xrefs] = nil
      options[:noindent] = nil
      options[:obfuscate] = false
    end
    load_all_objects unless @loaded

    intents_as_pdfa1 if options[:intent] =~ %r{pdf[/-]?A1?/i}
    delinearize! if options[:delinearize] && linearized?
    compile(options) if options[:recompile]

    io_stream = StringIO.new(output(options))
    io_stream.set_encoding Encoding::BINARY
    io_stream
  end
end

Origami::PDF.class_eval { include PDFTools }

module Mindee
  ALLOWED_MIME_TYPES = [
    'application/pdf',
    'image/heic',
    'image/png',
    'image/jpeg',
    'image/tiff',
    'image/webp',
  ].freeze

  MAX_DOC_PAGES = 3

  # Base class for loading documents.
  class InputDocument
    # @return [String]
    attr_reader :filename
    # @return [String]
    attr_reader :filepath
    # @return [String]
    attr_reader :file_mimetype

    # @param cut_pages [Boolean]
    # @param max_pages [Integer]
    def initialize(cut_pages, max_pages)
      @file_mimetype = Marcel::MimeType.for @io_stream, name: @filename

      unless ALLOWED_MIME_TYPES.include? @file_mimetype
        raise "File type not allowed, must be one of #{ALLOWED_MIME_TYPES.join(', ')}"
      end

      merge_pdf_pages(max_pages) if cut_pages && pdf?
    end

    def pdf?
      @file_mimetype == 'application/pdf'
    end

    # @return [Integer]
    def page_count
      if pdf?
        current_pdf = open_pdf
        return current_pdf.pages.size
      end
      1
    end

    # @param close [Boolean]
    def read_document(close: true)
      @io_stream.seek(0)
      data = @io_stream.read
      @io_stream.close if close
      [data].pack('m')
    end

    private

    # @param max_pages [Integer]
    def merge_pdf_pages(max_pages)
      current_pdf = open_pdf
      return if current_pdf.pages.size <= MAX_DOC_PAGES

      new_pdf = Origami::PDF.new

      to_insert = [current_pdf.pages[0], current_pdf.pages[-2], current_pdf.pages[-1]].take(max_pages)
      to_insert.each_with_index do |page, idx|
        new_pdf.insert_page(idx, page)
      end
      @io_stream = new_pdf.to_io_stream
    end

    # @return [Origami::PDF]
    def open_pdf
      pdf_parser = Origami::PDF::LinearParser.new({})
      @io_stream.seek(0)
      pdf_parser.parse(@io_stream)
    end
  end

  # Load a document from a path.
  class PathDocument < InputDocument
    def initialize(filepath, cut_pages, max_pages: MAX_DOC_PAGES)
      @io_stream = File.open(filepath, 'rb')
      @filepath = filepath
      super(cut_pages, max_pages)
    end
  end

  # Load a document from a base64 string.
  class Base64Document < InputDocument
    def initialize(base64_string, filename, cut_pages, max_pages: 3)
      @io_stream = StringIO.new(base64_string.unpack1('m*'))
      @io_stream.set_encoding Encoding::BINARY
      @filename = filename
      super(cut_pages, max_pages)
    end
  end

  # Load a document from raw bytes.
  class BytesDocument < InputDocument
    def initialize(raw_bytes, filename, cut_pages, max_pages: MAX_DOC_PAGES)
      @io_stream = StringIO.new(raw_bytes)
      @io_stream.set_encoding Encoding::BINARY
      @filename = filename
      super(cut_pages, max_pages)
    end
  end

  # Load a document from a file handle.
  class FileDocument < InputDocument
    def initialize(file_handle, filename, cut_pages, max_pages: MAX_DOC_PAGES)
      @io_stream = file_handle
      @filename = filename
      super(cut_pages, max_pages)
    end
  end
end
