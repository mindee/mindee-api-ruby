# frozen_string_literal: true

module Mindee
  # Centralized check for optional heavy dependencies
  module Dependencies
    # Checks the presence of dependencies.
    def self.check_all_dependencies
      require 'origami'
      require 'mini_magick'
      require 'pdf-reader'
      true
    rescue LoadError
      false
    end

    # Memoized check.
    @all_deps_available = check_all_dependencies

    # Checks whether all dependencies are available.
    def self.all_deps_available?
      check_all_dependencies
    end

    # Raises an error if dependencies are not available.
    def self.require_all_deps!
      raise LoadError, MINDEE_DEPENDENCIES_LOAD_ERROR unless all_deps_available?
    end

    # Error message to display when dependencies are not available.
    MINDEE_DEPENDENCIES_LOAD_ERROR = 'Attempted to load Mindee PDF/Image tools without required dependencies. ' \
                                     "If you need to process local files, please replace the 'mindee-lite' gem " \
                                     "with the standard 'mindee' gem in your Gemfile."
  end
end
