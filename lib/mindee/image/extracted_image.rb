# frozen_string_literal: true

require_relative '../input/sources'
require_relative '../logging'

module Mindee
  # Image Extraction Module.
  module Image
    # Generic class for image extraction.
    class ExtractedImage
      # ID of the page the image was extracted from.
      attr_reader :page_id

      # ID of the element on a given page.
      attr_reader :element_id

      # Buffer object of the file's content.
      attr_reader :buffer

      # Internal name for the file.
      attr_reader :filename

      # Initializes the ExtractedImage with a buffer and an internal file name.
      #
      # @param input_source [LocalInputSource, BytesInputSource] Local source for input.
      # @param page_id [Integer] ID of the page the element was found on.
      # @param element_id [Integer, nil] ID of the element in a page.
      # @param preserve_input_filename [Boolean] If true, keep the input source filename as-is.
      def initialize(input_source, page_id, element_id, preserve_input_filename: false)
        @buffer = StringIO.new(input_source.io_stream.read.to_s)
        @buffer.rewind

        @filename = if preserve_input_filename
                      input_source.filename.to_s
                    else
                      extension = if input_source.pdf?
                                    '.jpg'
                                  else
                                    File.extname(input_source.filename)
                                  end
                      base_name = File.basename(input_source.filename, File.extname(input_source.filename))
                      "#{base_name}_p#{page_id}_#{element_id}#{extension}"
                    end
        @page_id = page_id
        @element_id = element_id.nil? ? 0 : element_id
      end

      # Saves the document to a file.
      #
      # @param output_path [String] Path to save the file to.
      # @param file_format [String, nil] Optional MiniMagick-compatible format for the file. Inferred from file
      # extension if not provided.
      # @raise [MindeeError] If an invalid path or filename is provided.
      def write_to_file(output_path, file_format = nil)
        resolved_path = Pathname.new(File.expand_path(output_path))
        if file_format.nil?
          raise Error::MindeeImageError, 'Invalid file format.' if resolved_path.extname.delete('.').empty?

          file_format = resolved_path.extname.delete('.').upcase
        end
        begin
          @buffer.rewind
          image = MiniMagick::Image.read(@buffer)
          image.format file_format.to_s.downcase
          image.write resolved_path.to_s
          logger.info("File saved successfully to '#{resolved_path}'")
        rescue StandardError
          raise Error::MindeeImageError, "Could not save file '#{output_path}'. " \
                                         'Is the provided file path valid?.'
        end
      end

      # Return the file as a Mindee-compatible BufferInput source.
      #
      # @return [FileInputSource] A BufferInput source.
      def as_source
        @buffer.rewind
        Mindee::Input::Source::BytesInputSource.new(@buffer.read || '', @filename)
      end

      # Return the file as a Mindee-compatible BufferInput source.
      #
      # @return [FileInputSource] A BufferInput source.
      def as_input_source
        as_source
      end
    end
  end
end
