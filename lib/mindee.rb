# frozen_string_literal: true

require 'mindee/client'
require 'mindee/logging'

module Mindee
  # Mindee internal error module.
  module Errors
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
end

# Shorthand to call the logger from anywhere.
def logger
  Mindee::Logging.logger
end
