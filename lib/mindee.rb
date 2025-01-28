# frozen_string_literal: true

require 'mindee/client'

module Mindee
  # Mindee internal error module.
  module Errors
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

  # Parsing internals and fields.
  module Parsing
    # Common fields and functions.
    module Common
    end

    # Custom fields and functions.
    module Custom
    end

    # Standard fields and functions.
    module Standard
    end

    # Generated fields and functions.
    module Generated
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

    # US-specific products.
    module US
    end
  end
end
