# frozen_string_literal: true

require 'set'
require 'origami'
require_relative 'pdf_tools'

module Mindee
  module PDF
    # PDF document processing
    module PDFProcessor
      Origami::PDF.class_eval { include PDFTools }
      # @param io_stream [StreamIO]
      # @param options [PageOptions, Hash]
      # @return [StringIO]
      def self.parse(io_stream, options)
        current_pdf = open_pdf(io_stream)
        pages_count = current_pdf.pages.size
        return current_pdf.to_io_stream if options.on_min_pages.to_i > pages_count

        all_pages = (0..pages_count - 1).to_a

        if options.operation == :KEEP_ONLY
          pages_to_remove = indexes_from_keep(options.page_indexes, all_pages)
        elsif options.operation == :REMOVE
          pages_to_remove = indexes_from_remove(options.page_indexes, all_pages)
        else
          raise ArgumentError, "operation must be one of :KEEP_ONLY or :REMOVE, sent '#{options.operation}'"
        end

        current_pdf.delete_pages_at(pages_to_remove) if pages_to_remove.to_a != all_pages.to_a
        current_pdf.to_io_stream
      end

      # @param page_indexes [Array]
      # @param all_pages [Array]
      def self.indexes_from_keep(page_indexes, all_pages)
        pages_to_keep = Set.new
        page_indexes.each do |idx|
          idx = (all_pages.length - (idx + 2)) if idx.negative?
          page = all_pages[idx]
          next if page.nil?

          pages_to_keep << page
        end
        all_pages.to_set - pages_to_keep
      end

      # @param page_indexes [Array[Integer]]
      # @param all_pages [Array]
      def self.indexes_from_remove(page_indexes, all_pages)
        pages_to_remove = Set.new
        page_indexes.each do |idx|
          idx = (all_pages.length - (idx + 2)) if idx.negative?
          page = all_pages[idx]
          next if page.nil?

          pages_to_remove << page
        end
      end

      # @param io_stream [StringIO]
      # @return [Origami::PDF]
      def self.open_pdf(io_stream)
        pdf_parser = Origami::PDF::LinearParser.new({ verbosity: Origami::Parser::VERBOSE_QUIET })
        io_stream.seek(0)
        pdf_parser.parse(io_stream)
      end

      # Retrieves a PDF document's page.
      #
      # @param [Origami::PDF] pdf_doc Origami PDF handle.
      # @param [Integer] page_id Page ID.
      # @return [StringIO]
      def self.get_page(pdf_doc, page_id)
        stream = StringIO.new
        pdf_doc.save(stream)

        options = PageOptions.new(params: {
                                    page_indexes: [page_id - 1],
                                  })

        parse(stream, options)
      end
    end
  end
end
