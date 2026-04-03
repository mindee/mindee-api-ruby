# frozen_string_literal: true

module Mindee
  # Centralized check for optional heavy dependencies
  module Dependency
    def self.check_heavy_dependencies
      require 'origami'
      require 'mini_magick'
      require 'pdf-reader'
      true
    rescue LoadError
      false
    end

    @heavy_available = check_heavy_dependencies

    def self.heavy_available?
      check_heavy_dependencies
    end

    def self.require_heavy!
      raise LoadError, MINDEE_LITE_LOAD_ERROR unless heavy_available?
    end

    MINDEE_LITE_LOAD_ERROR = 'Attempted to load Mindee PDF/Image tools without required dependencies. ' \
                             "If you need to process local files, please replace the 'mindee-lite' gem " \
                             "with the standard 'mindee' gem in your Gemfile."
  end
end
