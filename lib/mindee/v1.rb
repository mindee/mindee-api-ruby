# frozen_string_literal: true

require_relative 'v1/client'
require_relative 'v1/extraction' if Mindee::Dependencies.all_deps_available?
require_relative 'v1/http'
require_relative 'v1/parsing'
require_relative 'v1/product'
