#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'optparse'
require_relative 'v1/parser'
require_relative 'v2/parser'

def root_help
  help = "Usage: mindee command [options]\n\nAvailable commands:\n"
  help += "  #{'v1'.ljust(50)}Use Version 1 of the Mindee API\n"

  MindeeCLI::V2SearchCommands::V2_SEARCH_COMMANDS.each do |search_command, search_values|
    help += "  #{search_command.ljust(50)}#{search_values[:description]}\n"
  end

  V2_PRODUCTS.each do |product_key, product_values|
    help += "  #{product_key.ljust(50)}#{product_values[:description]}\n"
  end

  help
end

def setup_main_parser
  main_command = ARGV.first

  if main_command == 'v1'
    ARGV.shift
    MindeeCLI::V1Parser.new(ARGV).execute
  elsif main_command.nil? || %w[help -h --help].include?(main_command)
    abort(root_help)
  else
    ARGV.shift if main_command == 'v2'
    MindeeCLI::V2Parser.new(ARGV, command_prefix: 'mindee').execute
  end
end

setup_main_parser
