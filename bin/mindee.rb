#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'optparse'
require_relative 'v1/parser'
require_relative 'v2/parser'

def setup_main_parser
  v1_parser = MindeeCLI::V1Parser.new(ARGV)
  v2_parser = MindeeCLI::V2Parser.new(ARGV)
  main_parser = OptionParser.new do |opts|
    opts.banner = "Usage: mindee [command]"
    opts.separator "Commands:"
    opts.separator "  v1    Use Version 1 of the Mindee API"
    opts.separator "  v2    Use Version 2 of the Mindee API"
  end
  main_command = ARGV.shift

  case main_command
  when 'v1'
    v1_parser.execute
  when 'v2'
    v2_parser.execute
  else
    abort(main_parser.help)
  end
end

setup_main_parser
