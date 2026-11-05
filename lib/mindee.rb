# frozen_string_literal: true

require 'mindee/logging'
require 'mindee/page_options'
require 'mindee/v1'
require 'mindee/v2'

module Mindee
  # Dependency management
  module Dependencies
  end

  # Mindee internal error module.
  module Error
  end

  # Custom geometry module
  module Geometry
  end

  # Mindee internal http module.
  module HTTP
  end

  module Image
    # Miscellaneous image operations.
    module ImageUtils
    end

    # Image compressor module to handle image compression.
    module ImageCompressor
    end
  end

  # Document handling.
  module Input
    # Document source handling.
    module Source
    end
  end

  # Logging
  module Logging
  end

  # PDF-specific operations.
  module PDF
  end

  # V1-specific module.
  module V1
    # Custom extraction for V1.
    module Extraction
    end

    # HTTP module for V1.
    module HTTP
    end

    # Parsing internals and fields.
    module Parsing
      # Common fields and functions.
      module Common
      end

      # Standard fields and functions.
      module Standard
      end

      # Universal fields and functions.
      module Universal
      end
    end

    # V1-specific products.
    module Product
      # French products.
      module FR
      end
    end
  end

  # V2-specific module.
  module V2
    # File operations.
    module FileOperation
      # Crop operations.
      module Crop
      end

      # Split operations.
      module Split
      end
    end

    # HTTP module for V2.
    module HTTP
    end

    # V2 parsing module.
    module Parsing
      # V2 search module.
      module Search
      end
    end

    # Product-specific module.
    module Product
    end

    # V2 search module.
    module Search
    end
  end
end

# Shorthand to call the logger from anywhere.
def logger
  Mindee::Logging.logger
end
