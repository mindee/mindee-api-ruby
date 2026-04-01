# frozen_string_literal: true

module Mindee
  module Error
    # Base class for all custom mindee error.
    class MindeeError < StandardError; end

    # Errors relating to library issues.
    class MindeeAPIError < MindeeError; end

    # Errors relating to misuse of the library.
    class MindeeConfigurationError < MindeeError; end

    # Errors relating to geometric manipulation issues.
    class MindeeGeometryError < MindeeError; end
  end
end
