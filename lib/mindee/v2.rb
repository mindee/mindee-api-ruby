# frozen_string_literal: true

require_relative 'v2/client'
require_relative 'v2/http'
require_relative 'v2/file_operation' if Mindee::Dependency.heavy_available?
require_relative 'v2/parsing'
require_relative 'v2/product'
