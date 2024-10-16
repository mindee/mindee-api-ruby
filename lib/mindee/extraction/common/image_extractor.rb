# frozen_string_literal: true

require 'mini_magick'
require 'origami'
require 'stringio'
require 'tempfile'
require_relative '../../input/sources'
require_relative 'extracted_image'

module Mindee
  # Image Extraction Module.
  module Extraction
    # Image Extraction wrapper class.
    module ImageExtractor
      def self.attach_image_as_new_file(input_buffer, format: 'jpg')
        # Attaches an image as a new page in a PdfDocument object.
        #
        # @param [StringIO] input_buffer Input buffer. Only supports JPEG.
        # @return [Origami::PDF] A PdfDocument handle.

        magick_image = MiniMagick::Image.read(input_buffer)
        # NOTE: some jpeg images get rendered as three different versions of themselves per output if the format isn't
        # converted.
        magick_image.format(format)
        original_density = magick_image.resolution
        scale_factor = original_density[0].to_f / 4.166666 # No clue why the resolution needs to be reduced for
        # the pdf otherwise the resulting image shrinks.
        magick_image.format('pdf', 0, { density: scale_factor.to_s })
        Origami::PDF.read(StringIO.new(magick_image.to_blob))
      end

      # Extracts multiple images from a given local input source.
      #
      # @param [Mindee::Input::Source::LocalInputSource] input_source
      # @param [Integer] page_id ID of the Page to extract from.
      # @param [Array<Array<Mindee::Geometry::Point>>, Array<Mindee::Geometry::Quadrangle>] polygons List of coordinates
      # to extract.
      # @return [Array<Mindee::Extraction::ExtractedImage>] Extracted Images.
      def self.extract_multiple_images_from_source(input_source, page_id, polygons)
        new_stream = load_input_source_pdf_page_as_image(input_source, page_id)
        new_stream.seek(0)

        extract_images_from_polygons(input_source, new_stream, page_id, polygons)
      end

      # Extracts images from their positions on a file (as polygons).
      #
      # @param [Mindee::Input::Source::LocalInputSource] input_source Local input source.
      # @param [StringIO] pdf_stream Buffer of the PDF.
      # @param [Integer] page_id Page ID.
      # @param [Array<Mindee::Geometry::Point, Mindee::Geometry::Polygon, Mindee::Geometry::Quadrangle>] polygons
      # @return [Array<Mindee::Extraction::ExtractedImage>] Extracted Images.
      def self.extract_images_from_polygons(input_source, pdf_stream, page_id, polygons)
        extracted_elements = []

        polygons.each_with_index do |polygon, element_id|
          polygon = normalize_polygon(polygon)
          page_content = read_page_content(pdf_stream)

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
          file_extension = determine_file_extension(input_source)
          cropped_image = crop_image(page_content, min_max_x, min_max_y)
          if file_extension == 'pdf'
            cropped_image.format('jpg')
          else
            cropped_image.format(file_extension)
          end

          buffer = StringIO.new
          write_image_to_buffer(cropped_image, buffer)
          file_name = "#{input_source.filename}_page#{page_id}-#{element_id}.#{file_extension}"

          extracted_elements << create_extracted_image(buffer, file_name, page_id, element_id)
        end

        extracted_elements
      end

      # Retrieves the bounding box of a polygon.
      #
      # @param [Array<Point>, Mindee::Geometry::Polygon] polygon
      def self.normalize_polygon(polygon)
        if polygon.is_a?(Mindee::Geometry::Polygon)
          Mindee::Geometry.get_bounding_box(polygon)
        else
          polygon
        end
      end

      # Loads a buffer into a MiniMagick Image.
      #
      # @param [StringIO] pdf_stream Buffer containg the PDF
      # @return [MiniMagick::Image] a valid MiniMagick image handle.
      def self.read_page_content(pdf_stream)
        pdf_stream.rewind
        MiniMagick::Image.read(pdf_stream)
      end

      # Crops a MiniMagick Image from a the given bounding box.
      #
      # @param [MiniMagick::Image] image Input Image.
      # @param [Mindee::Geometry::MinMax] min_max_x minimum & maximum values for the x coordinates.
      # @param [Mindee::Geometry::MinMax] min_max_y minimum & maximum values for the y coordinates.
      def self.crop_image(image, min_max_x, min_max_y)
        width = image[:width].to_i
        height = image[:height].to_i

        image.format('jpg')
        new_width = (min_max_x.max - min_max_x.min) * width
        new_height = (min_max_y.max - min_max_y.min) * height
        image.crop("#{new_width}x#{new_height}+#{min_max_x.min * width}+#{min_max_y.min * height}")

        image
      end

      # Writes a MiniMagick::Image to a buffer.
      #
      # @param [MiniMagick::Image] image a valid MiniMagick image.
      # @param [StringIO] buffer
      def self.write_image_to_buffer(image, buffer)
        image.write(buffer)
      end

      # Retrieves the file extension from the main file to apply it to the extracted images. Note: coerces pdf as jpg.
      #
      # @param [Mindee::Input::Source::LocalInputSource] input_source Local input source.
      # @return [String] A valid file extension.
      def self.determine_file_extension(input_source)
        if input_source.pdf? || input_source.filename.downcase.end_with?('pdf')
          'jpg'
        else
          File.extname(input_source.filename).strip.downcase[1..]
        end
      end

      # Generates an ExtractedImage.
      #
      # @param [StringIO] buffer Buffer containing the image.
      # @param [String] file_name Name for the file.
      # @param [Object] page_id ID of the page the file was generated from.
      # @param [Object] element_id ID of the element of a given page.
      def self.create_extracted_image(buffer, file_name, page_id, element_id)
        buffer.rewind
        ExtractedImage.new(
          Mindee::Input::Source::BytesInputSource.new(buffer.read, file_name),
          page_id,
          element_id
        )
      end

      # Loads a single_page from an image file or a pdf document.
      #
      # @param input_file [LocalInputSource] Local input.
      # @param [Integer] page_id Page ID.
      # @return [MiniMagick::Image] A valid PdfDocument handle.
      def self.load_input_source_pdf_page_as_image(input_file, page_id)
        input_file.io_stream.rewind
        if input_file.pdf?
          Mindee::PDF::PdfProcessor.get_page(Origami::PDF.read(input_file.io_stream), page_id)
        else
          input_file.io_stream
        end
      end
    end
  end
end
