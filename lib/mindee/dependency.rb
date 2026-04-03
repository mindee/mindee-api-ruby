# frozen_string_literal: true

module Mindee
  # Centralized check for optional heavy dependencies
  module Dependency
    def self.check_all_dependencies
      require 'origami'
      require 'mini_magick'
      require 'pdf-reader'
      true
    rescue LoadError
      false
    end

    @all_deps_available = check_all_dependencies

    def self.all_deps_available?
      check_all_dependencies
    end

    def self.require_full_deps!
      raise LoadError, MINDEE_DEPENDENCIES_LOAD_ERROR unless all_deps_available?
    end

    MINDEE_DEPENDENCIES_LOAD_ERROR = 'Attempted to load Mindee PDF/Image tools without required dependencies. ' \
                                     "If you need to process local files, please replace the 'mindee-lite' gem " \
                                     "with the standard 'mindee' gem in your Gemfile."
  end
end
