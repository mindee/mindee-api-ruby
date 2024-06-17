# frozen_string_literal: true

require 'mini_magick'
require 'origami'
require 'stringio'
require 'tempfile'
require_relative '../../input/sources'
require_relative 'extracted_image'

module Mindee
  # Image Extraction Module.
  module ImageExtraction
    def attach_image_as_new_file(input_buffer)
      # Attaches an image as a new page in a PdfDocument object.
      #
      # @param input_buffer [StringIO] Input buffer. Only supports JPEG.
      # @return [Origami::PDF] A PdfDocument handle.

      input_buffer.rewind
      magick_image = MiniMagick::Image.open(input_buffer)
      magick_image.format('pdf')
      io_buffer = StringIO.new
      magick_image.write(io_buffer)
      io_buffer.rewind
      Origami::PDF.read(io_buffer)
    end

    def extract_multiple_images_from_source(input_source, page_id, polygons)
      # Extracts elements from a page based on a list of bounding boxes.
      #
      # @param input_source [LocalInputSource] Local Input source to extract elements from.
      # @param page_id [Integer] ID of the page to extract from.
      # @param polygons [Array<Array<Point>>] List of coordinates to pull the elements from.
      # @return [Array<ExtractedImage>] List of byte arrays representing the extracted elements.
      pdf_doc = load_pdf_doc(input_source)
      stream = StringIO.new
      pdf_doc.save(stream)
      # NOTE: copying the page from the first PDF to the second does NOT work for this. Hence the call to the custom
      # OrigaMindee pdf processor.
      options = {
        page_indexes: [page_id - 1],
        operation: :KEEP_ONLY,
        on_min_pages: 0,
      }
      stream.rewind
      new_stream = Mindee::PDF::PdfProcessor.parse(stream, options)

      extracted_elements = []
      polygons.each_with_index do |polygon, element_id|
        new_stream.rewind
        page_content = MiniMagick::Image.read(new_stream)
        width = page_content[:width]
        height = page_content[:height]
        min_max_x = Geometry.get_min_max_x(
          [polygon.top_left, polygon.bottom_right, polygon.top_right, polygon.bottom_left]
        )
        min_max_y = Geometry.get_min_max_y(
          [polygon.top_left, polygon.bottom_right, polygon.top_right, polygon.bottom_left]
        )
        min_x = (min_max_x.min * width).to_i
        min_y = (min_max_y.min * height).to_i
        max_x = (min_max_x.max * width).to_i
        max_y = (min_max_y.max * height).to_i

        page_content.format('png')
        page_content.crop("#{max_x - min_x}x#{max_y - min_y}+#{min_x}+#{min_y}")

        buffer = StringIO.new
        page_content.write(buffer)
        buffer.rewind

        extracted_elements << ExtractedImage.new(
          Mindee::Input::Source::BytesInputSource.new(buffer.read,
                                                      "#{input_source.filename}_p#{page_id}_e#{element_id}.png"),
          page_id,
          element_id
        )
      end

      extracted_elements
    end

    def load_pdf_doc(input_file)
      # Loads a PDF document from a local input source.
      #
      # @param input_file [LocalInputSource] Local input.
      # @return [Origami::PDF] A valid PdfDocument handle.

      if input_file.pdf?
        input_file.io_stream.rewind
        Origami::PDF.read(input_file.io_stream)
      else
        attach_image_as_new_file(input_file.io_stream)
      end
    end
  end
end
