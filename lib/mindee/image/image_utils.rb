# frozen_string_literal: true

module Mindee
  # Image processing module.
  module Image
    # Miscellaneous image operations.
    module ImageUtils
      # @param image [MiniMagick::Image]
      # @param width [Integer]
      # @param height [Integer]
      def self.resize_image(image, width, height)
        if width && height
          image.resize "#{width}x#{height}"
        elsif width
          image.resize width.to_s
        elsif height
          image.resize "x#{height}"
        end
      end

      # @param image [MiniMagick::Image]
      # @param quality [Integer]
      def self.compress_image_quality(image, quality)
        image.quality quality.to_s
      end

      # Mostly here so that IDEs don't get confused on the type (@type annotation fails sometimes.)
      # @param [MiniMagick::Image, StringIO, File, Tempfile] image The input image
      # @return [MiniMagick::Image]
      def self.to_image(image)
        if image.respond_to?(:read) && image.respond_to?(:rewind)
          image.rewind
          MiniMagick::Image.read(image)
        elsif image.is_a?(MiniMagick::Image)
          image
        else
          raise "Expected an I/O object or a MiniMagick::Image. '#{image.class}' given instead."
        end
      end

      # Converts a StringIO containing an image into a MiniMagick image.
      def self.image_to_stringio(image, format = 'JPEG')
        image.format format
        blob = image.to_blob
        stringio = StringIO.new(blob)
        stringio.rewind

        stringio
      end

      # Computes the new dimensions for a given SKBitmap, and returns a scaled down version of it relative to the
      # provided bounds.
      # @param [MiniMagick::Image] original Input MiniMagick image.
      # @param max_width [Integer] Maximum width. If not specified, the horizontal ratio will remain the same.
      # @param max_height [Integer] Maximum height. If not specified, the vertical ratio will remain the same.
      def self.calculate_new_dimensions(original, max_width: nil, max_height: nil)
        raise 'Provided image could not be processed for resizing.' if original.nil?

        return [original.width, original.height] if max_width.nil? && max_height.nil?

        width_ratio = max_width ? max_width.to_f / original.width : Float::INFINITY
        height_ratio = max_height ? max_height.to_f / original.height : Float::INFINITY

        scale_factor = [width_ratio, height_ratio].min

        new_width = (original.width * scale_factor).to_i
        new_height = (original.height * scale_factor).to_i

        [new_width, new_height]
      end

      def self.calculate_dimensions(image, media_box)
        if media_box && !media_box.empty?
          [
            media_box[2]&.to_i || image[:width],
            media_box[3]&.to_i || image[:height],
          ]
        else
          [image[:width], image[:height]]
        end
      end
    end
  end
end
