# frozen_string_literal: true

module Mindee
  # Class for page options in parse calls.
  #
  # @!attribute page_indexes [Array[Integer]] Zero-based list of page indexes.
  # @!attribute operation [:KEEP_ONLY, :REMOVE] Operation to apply on the document, given the specified page indexes:
  #   * `:KEEP_ONLY` - keep only the specified pages, and remove all others.
  #   * `:REMOVE` - remove the specified pages, and keep all others.
  # @!attribute on_min_pages [Integer, nil] Apply the operation only if the document has at least this many pages.
  class PageOptions
    attr_accessor :page_indexes, :operation, :on_min_pages

    def initialize(params: {})
      params ||= {}
      params = params.transform_keys(&:to_sym)
      @page_indexes = params.fetch(
        :page_indexes,
        [] # : Array[Integer]
      )
      @operation = params.fetch(:operation, :KEEP_ONLY)
      @on_min_pages = params.fetch(:on_min_pages, nil)
    end
  end
end
