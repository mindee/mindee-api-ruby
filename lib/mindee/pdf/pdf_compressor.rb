# frozen_string_literal: true

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
        output_pdf = Origami::PDF.new

        pdf.each_page.with_index do |page, i|
          process_pdf_page(page, output_pdf, i + 1, quality, disable_source_text)
        end

        output_stream = StringIO.new
        output_pdf.save(output_stream)
        output_stream
      end

      def self.process_pdf_page(page, output_doc, _page_index, image_quality, disable_source_text)
        new_page = Origami::Page.new
        content_stream = Origami::ContentStream.new

        media_box = page[:MediaBox] || output_doc.pages.first[:MediaBox]
        page_width = media_box[2] - media_box[0]
        page_height = media_box[3] - media_box[1]

        page.each_xobject do |name, xobject|
          if xobject[:Subtype] == :Image
            io_stream = StringIO.new
            io_stream << xobject.to_image_file(bypass_dct: true)[1].to_s
            io_stream.rewind
            compressed_image = Mindee::Image::ImageCompressor.compress_image(
              io_stream,
              quality: image_quality
            )
            compressed_image.rewind
            compressed_xobject = Origami::Graphics::ImageXObject.from_image_file(compressed_image, 'jpg')

            width = xobject.dictionary[:Width]
            height = xobject.dictionary[:Height]
            compressed_xobject.dictionary[:Subtype] = xobject.dictionary[:Subtype]
            compressed_xobject.dictionary[:Width] = width
            compressed_xobject.dictionary[:Height] = height
            compressed_xobject.dictionary[:ColorSpace] = :DeviceRGB
            compressed_xobject.dictionary[:BitsPerComponent] = xobject.dictionary[:BitsPerComponent]
            compressed_xobject.dictionary[:Filter] = :DCTDecode
            content_stream.draw_image(name, x: 0, y: 0, w: page_width, h: page_height)
            new_page.add_xobject(compressed_xobject, name)
          else
            new_page.add_xobject(xobject, name)
          end
        end

        unless disable_source_text
          new_page[:Contents] = page[:Contents]
        end
        new_page[:Contents] = content_stream
        output_doc.append_page new_page.copy

      end

      def self.process_image_xobject(image_data, image_quality, width, height)
        compressed_data = Image::ImageCompressor.compress_image(
          image_data,
          quality: image_quality,
          max_width: width,
          max_height: height
        )

        new_image = Origami::Graphics::ImageXObject.new
        new_image.data = compressed_data
        new_image.Width = width
        new_image.Height = height
        new_image.ColorSpace = :DeviceRGB
        new_image.BitsPerComponent = 8

        new_image
      end
    end
  end
end
