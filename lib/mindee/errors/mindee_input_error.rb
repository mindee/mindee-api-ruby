# frozen_string_literal: true

module Mindee
  module Errors
    # Base class for errors relating to input documents.
    class MindeeInputError < MindeeError; end

    # Errors relating to sources (documents) handling.
    class MindeeSourceError < MindeeInputError; end

    # Errors relating to mime type issues.
    class MindeeMimeTypeError < MindeeSourceError
      # @return [String]
      attr_reader :invalid_mimetype

      # @param mime_type [String]
      def initialize(mime_type)
        @invalid_mimetype = mime_type
        super("'#{@invalid_mimetype}' mime type not allowed, must be one of " \
              "#{Mindee::Input::Source::ALLOWED_MIME_TYPES.join(', ')}")
      end
    end

    # Errors relating to the handling of images.
    class MindeeImageError < MindeeInputError; end

    # Errors relating to the handling of PDF documents.
    class MindeePDFError < MindeeInputError; end
  end
end
