# frozen_string_literal: true

module Mindee
  module Errors
    # Base class for all custom mindee errors.
    class MindeeError < StandardError; end

    # Errors relating to library issues.
    class MindeeAPIError < MindeeError; end

    # Errors relating to misuse of the library.
    class MindeeUserError < MindeeError; end

    # Errors relating to geometric manipulation issues.
    class MindeeGeometryError < MindeeError; end
  end
end
