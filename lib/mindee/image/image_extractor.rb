# frozen_string_literal: true

require 'mini_magick'
require 'origami'
require 'stringio'
require 'tempfile'
require_relative '../input/sources'
require_relative 'extracted_image'

module Mindee
  # Image Extraction Module.
  module Image
    # Image Extraction wrapper class.
    module ImageExtractor
      # Attaches an image as a new page in a PdfDocument object.
      #
      # @param [StringIO] input_buffer Input buffer. Only supports JPEG.
      # @return [Origami::PDF] A PdfDocument handle.
      def self.attach_image_as_new_file(input_buffer, format: 'jpg')
        magick_image = MiniMagick::Image.read(input_buffer)
        # NOTE: We force format consolidation to a single format to avoid frames being interpreted as the final output.
        magick_image.format(format)
        original_density = magick_image.resolution
        scale_factor = original_density[0].to_f / 4.166666 # Convert from default 300 DPI to 72.
        magick_image.format('pdf', 0, { density: scale_factor.to_s })
        Origami::PDF.read(StringIO.new(magick_image.to_blob))
      end

      # Extracts multiple images from a given local input source.
      #
      # @param [Input::Source::LocalInputSource] input_source
      # @param [Integer] page_id ID of the Page to extract from.
      # @param [Array<Array<Geometry::Point>>, Array<Geometry::Quadrilateral>] polygons List of coordinates to extract.
      # @return [Array<Image::ExtractedImage>] Extracted Images.
      def self.extract_multiple_images_from_source(input_source, page_id, polygons)
        new_stream = load_input_source_pdf_page_as_stringio(input_source, page_id)
        new_stream.seek(0)

        extract_images_from_polygons(input_source, new_stream, page_id, polygons)
      end

      # Extracts images from their positions on a file (as polygons).
      #
      # @param [Input::Source::LocalInputSource] input_source Local input source.
      # @param [StringIO] pdf_stream Buffer of the PDF.
      # @param [Integer] page_id Page ID.
      # @param [Array<Geometry::Point, Geometry::Polygon, Geometry::Quadrilateral>] polygons
      # @return [Array<Image::ExtractedImage>] Extracted Images.
      def self.extract_images_from_polygons(input_source, pdf_stream, page_id, polygons)
        extracted_elements = []

        polygons.each_with_index do |polygon, element_id|
          polygon = ImageUtils.normalize_polygon(polygon)
          page_content = ImageUtils.read_page_content(pdf_stream)

          min_max_x = Geometry.get_min_max_x([
                                               polygon.top_left,
                                               polygon.bottom_right,
                                               polygon.top_right,
                                               polygon.bottom_left,
                                             ])
          min_max_y = Geometry.get_min_max_y([
                                               polygon.top_left,
                                               polygon.bottom_right,
                                               polygon.top_right,
                                               polygon.bottom_left,
                                             ])
          file_extension = ImageUtils.determine_file_extension(input_source)
          cropped_image = ImageUtils.crop_image(page_content, min_max_x, min_max_y)
          if file_extension == 'pdf'
            cropped_image.format('jpg')
          else
            cropped_image.format(file_extension.to_s)
          end

          buffer = StringIO.new
          ImageUtils.write_image_to_buffer(cropped_image, buffer)
          file_name = "#{input_source.filename}_page#{page_id}-#{element_id}.#{file_extension}"

          extracted_elements << create_extracted_image(buffer, file_name, page_id, element_id)
        end

        extracted_elements
      end

      # Generates an ExtractedImage.
      #
      # @param [StringIO] buffer Buffer containing the image.
      # @param [String] file_name Name for the file.
      # @param [Integer] page_id ID of the page the file was universal from.
      # @param [Integer] element_id ID of the element of a given page.
      def self.create_extracted_image(buffer, file_name, page_id, element_id)
        buffer.rewind
        ExtractedImage.new(
          Input::Source::BytesInputSource.new(buffer.read.to_s, file_name),
          page_id,
          element_id
        )
      end

      # Loads a single_page from an image file or a pdf document.
      #
      # @param input_file [LocalInputSource] Local input.
      # @param [Integer] page_id Page ID.
      # @return [StringIO] A valid PdfDocument handle.
      def self.load_input_source_pdf_page_as_stringio(input_file, page_id)
        input_file.io_stream.rewind
        if input_file.pdf?
          PDF::PDFProcessor.get_page(Origami::PDF.read(input_file.io_stream), page_id)
        else
          input_file.io_stream
        end
      end
    end
  end
end
