# frozen_string_literal: true

require 'mindee/logging'
require 'mindee/page_options'
require 'mindee/v1'
require 'mindee/v2'

module Mindee
  # Mindee internal error module.
  module Error
  end

  # Custom extraction module
  module Extraction
  end

  # Mindee internal http module.
  module HTTP
  end

  # PDF-specific operations.
  module PDF
  end

  # Document handling.
  module Input
    # Document source handling.
    module Source
    end
  end

  module Image
    # Miscellaneous image operations.
    module ImageUtils
    end

    # Image compressor module to handle image compression.
    module ImageCompressor
    end
  end

  # Logging
  module Logging
  end

  # Document input-related internals.
  module Input
  end

  # Collection of all internal products.
  module Product
    # Europe-specific products.
    module EU
    end

    # France-specific products.
    module FR
    end

    # Indian-specific products.
    module IND
    end

    # US-specific products.
    module US
    end
  end

  # V1-specific module.
  module V1
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
    # Mindee internal http module.
    module HTTP
    end

    # File operations.
    module FileOperation
      # Crop operations.
      module Crop
      end

      # Split operations.
      module Split
      end
    end

    # Product-specific module.
    module Product
    end

    # V2 parsing module.
    module Parsing
      # V2 search module.
      module Search
      end
    end
  end
end

# Shorthand to call the logger from anywhere.
def logger
  Mindee::Logging.logger
end
