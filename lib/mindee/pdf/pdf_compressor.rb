# frozen_string_literal: true

require 'pdf-reader'
PDFReader = PDF

module Mindee
  module PDF
    # Image compressor module to handle PDF compression.
    module PDFCompressor
      def self.compress_pdf(
        pdf_data,
        quality: 85,
        force_source_text: false,
        disable_source_text: true
      )
        return pdf_data if !force_source_text && PDFTools.source_text?(pdf_data)

        pdf_data.rewind
        pdf = Origami::PDF.read(pdf_data)
        pages = []
        pdf.pages.each.with_index do |page, i|
          page = process_pdf_page(Mindee::PDF::PdfProcessor.get_page(pdf, i), i, quality, page[:MediaBox])
          pages.append(page)
        end

        output_pdf = Origami::PDF.new
        # The manual insertion of the xobject parameters into the PDF seems to put the last created page in the first
        # position. This fixes it.
        pages.push(pages.shift) unless pages.count < 2

        inject_text(pdf_data, pages) unless disable_source_text
        pages.each do |page|
          output_pdf.append_page(page)
        end

        pages.each

        output_stream = StringIO.new
        output_pdf.save(output_stream)
        output_stream
      end

      def self.inject_text(pdf_data, pages)
        reader = PDFReader::Reader.new(pdf_data)

        reader.pages.each_with_index do |original_page, index|
          break if index >= pages.length

          receiver = PDFReader::Reader::PageTextReceiver.new
          original_page.walk(receiver)

          receiver.runs.each do |text_run|
            x = text_run.origin.x
            y = text_run.origin.y
            text = text_run.text
            font_size = text_run.font_size

            content_stream = Origami::Stream.new
            content_stream.dictionary[:Filter] = :FlateDecode
            content_stream.data = "BT\n/F1 #{font_size} Tf\n#{x} #{y} Td\n(#{text}) Tj\nET\n"

            pages[index].Contents.data += content_stream.data
          end
        end
      end

      def self.process_pdf_page(page_stream, page_index, image_quality, media_box)
        new_page = Origami::Page.new
        compressed_image = compress_pdf_image(page_stream, image_quality)
        width, height = Mindee::Image::ImageUtils.calculate_dimensions(compressed_image, media_box)

        compressed_xobject = PDF::PDFTools.create_xobject(compressed_image)
        PDF::PDFTools.set_xobject_properties(compressed_xobject, compressed_image)

        xobject_name = "X#{page_index + 1}"
        PDF::PDFTools.add_content_to_page(new_page, xobject_name, width, height)
        new_page.add_xobject(compressed_xobject, xobject_name)

        PDF::PDFTools.set_page_dimensions(new_page, width, height)
        new_page
      end

      def self.compress_pdf_image(page_stream, image_quality)
        compressed_image = MiniMagick::Image.read(page_stream.read)
        compressed_image.format('jpg')
        compressed_image.quality image_quality.to_s
        compressed_image
      end
    end
  end
end
