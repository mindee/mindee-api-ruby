#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'optparse'
require 'mindee'

require_relative 'cli_products'

options = {}

# Initializes universal-specific options
# @param cli_parser [OptionParser]
def custom_subcommand(cli_parser, options)
  cli_parser.on('-v [VERSION]', '--version [VERSION]', 'Model version for the API') do |v|
    options[:endpoint_version] = v
  end
  cli_parser.on('-a ACCOUNT_NAME', '--account ACCOUNT_NAME', 'API account name for the endpoint') do |v|
    options[:account_name] = v
  end
end

product_parser = {}
PRODUCTS.each do |doc_key, doc_value|
  product_parser[doc_key] = OptionParser.new do |opts|
    opts.on('-w', '--all-words', 'Include words in response') do |v|
      options[:all_words] = v
    end
    opts.on('-c', '--cut-pages', "Cut document pages") do |v|
      options[:cut_pages] = v
    end
    opts.on('-k [KEY]', '--key [KEY]', 'API key for the endpoint') do |v|
      options[:api_key] = v
    end
    opts.on('-f', '--full', "Print the full data, including pages") do |v|
      options[:print_full] = true
    end
    opts.on('-F', '--fix-pdf', "Attempts to fix broken PDF files before sending them to the server.") do |v|
      options[:repair_pdf] = true
    end
    if doc_key != 'universal'
      opts.banner = "#{doc_value[:description]}. \nUsage: \nmindee.rb universal [options] endpoint_name file\nor\nmindee.rb universal [options] endpoint_name file"
      custom_subcommand(opts, options)
    end
    if doc_value[:async]
      if doc_value[:sync]
        opts.on("-A", "--async", "Call asynchronously") do |v|
          options[:parse_async] = v
        end
      end
    end
  end
end

global_parser = OptionParser.new do |opts|
  opts.banner = "Usage: mindee.rb product [options] file"
  opts.separator "Available products:"
  opts.separator "  #{PRODUCTS.keys.join("\n  ")}"
end

command = ARGV.shift
unless PRODUCTS.include?(command)
  abort(global_parser.help)
end
doc_class = PRODUCTS[command][:doc_class]
product_parser[command].parse!

if command == 'universal'
  if ARGV.length < 2
    $stderr.puts "The '#{command}' command requires both ENDPOINT_NAME and file arguments."
    abort(product_parser[command].help)
  end
  endpoint_name = ARGV[0]
  options[:file_path] = ARGV[1]
else
  if ARGV.length < 1
    $stderr.puts "file missing"
    abort(product_parser[command].help)
  end
  endpoint_name = nil
  options[:file_path] = ARGV[0]
end

mindee_client = Mindee::Client.new(api_key: options[:api_key])
if options[:file_path].start_with?("https://")
  input_source = mindee_client.source_from_url(options[:file_path])
else
  input_source = mindee_client.source_from_path(options[:file_path], repair_pdf: options[:repair_pdf])
end

if command == 'universal'
  custom_endpoint = mindee_client.create_endpoint(
    endpoint_name: endpoint_name,
    account_name: options[:account_name],
    version: options[:endpoint_version].nil? ? "1" : options[:endpoint_version]
  )
else
  custom_endpoint = nil
end

if options[:cut_pages].nil? || !options[:cut_pages].is_a?(Integer) || options[:cut_pages] < 0
  page_options = options[:cut_pages].nil?
else
  page_options = Mindee::PageOptions.new(params: {
    page_indexes: (0..options[:cut_pages].to_i).to_a,
    operation: :KEEP_ONLY,
    on_min_pages: 0,
  })
end

if options[:parse_async].nil?
  if !PRODUCTS[command][:sync]
    options[:parse_async] = true
  else
    options[:parse_async] = false
  end
end
result = mindee_client.parse(
  input_source,
  doc_class,
  options: { endpoint: custom_endpoint,
             options: Mindee::ParseOptions.new(params: { page_options: page_options }), enqueue: options[:parse_async] }
)

if options[:print_full]
  puts result.document
else
  puts result.document.inference.prediction
end
