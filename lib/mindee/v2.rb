# frozen_string_literal: true

require_relative 'v2/client'
require_relative 'v2/http'
require_relative 'v2/file_operations' if Mindee::Dependencies.all_deps_available?
require_relative 'v2/parsing'
require_relative 'v2/product'
