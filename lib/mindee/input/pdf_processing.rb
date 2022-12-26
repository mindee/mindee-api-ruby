# frozen_string_literal: true

require 'set'

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
  module Input
    # Class for PDF documents
    module PdfProcessor
      DEFAULT_OPTIONS = {
        page_indexes: [0],
        operation: :KEEP_ONLY,
        on_min_pages: 0,
      }.freeze

      # @param io_stream [StreamIO]
      # @param options [Hash]
      def self.parse(io_stream, options)
        options = DEFAULT_OPTIONS.merge(options)

        current_pdf = open_pdf(io_stream)
        pages_count = current_pdf.pages.size
        return if options[:on_min_pages] > pages_count

        all_pages = (0..pages_count - 1).to_a

        case options[:operation]
        when :KEEP_ONLY
          pages_to_keep = Set.new
          options[:page_indexes].each do |idx|
            pages_to_keep << all_pages[idx]
          end
        when :REMOVE
          pages_to_remove = Set.new
          options[:page_indexes].each do |idx|
            pages_to_remove << all_pages[idx]
          end
          pages_to_keep = all_pages.to_set - pages_to_remove
        else
          raise "operation must be one of :KEEP_ONLY or :REMOVE, sent '#{behavior}'"
        end

        grab_pages(current_pdf, pages_to_keep.to_a)
      end

      # @param current_pdf [Origami::PDF]
      # @param page_numbers [Array]
      def self.grab_pages(current_pdf, page_numbers)
        new_pdf = Origami::PDF.new

        to_insert = []
        page_numbers.each do |idx|
          to_insert.append(current_pdf.pages[idx])
        end
        to_insert.each do |page|
          new_pdf.append_page(page)
        end
        new_pdf.to_io_stream
      end

      # @param io_stream [StringIO]
      # @return [Origami::PDF]
      def self.open_pdf(io_stream)
        pdf_parser = Origami::PDF::LinearParser.new({})
        io_stream.seek(0)
        pdf_parser.parse(io_stream)
      end
    end
  end
end
