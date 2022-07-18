#!/usr/bin/env ruby

require 'bundler/setup'
require 'optparse'

require 'mindee'

DOCUMENTS = {
  "invoice" => {
    help: 'Invoice',
    doc_type: "invoice",
  },
  "receipt" => {
    help: "Expense Receipt",
    doc_type: "receipt",
  },
  "passport" => {
    help: "Passport",
    doc_type: "passport",
  },
  "financial" => {
    help: "Financial Document (receipt or invoice)",
    doc_type: "financial_doc",
  },
  "custom" => {
    help: "Custom document type from API builder",
  },
}

options = {}

def ots_subcommand(command, options)
  OptionParser.new do |opt|
    opt.banner = "Usage: #{command} [options] FILE"
    opt.on('-k [KEY]', '--key [KEY]', 'API key for the endpoint') do |v|
      options[:api_key] = v
    end
    opt.on('-w', '--with-words', 'Include words in response') do |v|
      options[:include_words] = v
    end
    opt.on('-C', '--no-cut-pages', "Don't cut document pages") do |v|
      options[:include_words] = v
    end
  end
end

def custom_subcommand(options)
  OptionParser.new do |opt|
    opt.banner = "Usage: custom [options] DOC_TYPE FILE"
    opt.on('-w', '--with-words', 'Include words in response') do |v|
      options[:include_words] = v
    end
    opt.on('-C', '--no-cut-pages', "Don't cut document pages") do |v|
      options[:include_words] = v
    end
    opt.on('-k [KEY]', '--key [KEY]', 'API key for the endpoint') do |v|
      options[:api_key] = v
    end
    opt.on('-v [VERSION]', '--version [VERSION]', 'Model version for the API') do |v|
      options[:version] = v
    end
    opt.on('-u USER', '--user USER', 'API account name for the endpoint') do |v|
      options[:user] = v
    end
  end
end

def new_ots_client(options, command)
  raise_on_error = options[:no_raise_errors].nil? ? true : false
  mindee_client = Mindee::Client.new(
    api_key: options[:api_key], raise_on_error: raise_on_error
  )
  info = DOCUMENTS[command]
  mindee_client.send("config_#{info[:doc_type]}")
end

def new_custom_client(options, doc_type)
  raise_on_error = options[:no_raise_errors].nil? ? true : false
  mindee_client = Mindee::Client.new(
    api_key: options[:api_key], raise_on_error: raise_on_error
  )
  mindee_client.config_custom_doc(
    doc_type,
    options[:user],
    version: options[:version] || '1'
  )
end

global_parser = OptionParser.new do |opt|
  opt.banner = "Usage: #{$PROGRAM_NAME} [options] subcommand [options] FILE"
  opt.separator('')
  opt.separator("subcommands: #{DOCUMENTS.keys.join(', ')}")
  opt.separator('')
  opt.on('-E', '--no-raise-errors', "raise errors behavior") do |v|
    options[:no_raise_errors] = true
    end
end

subcommands = {
  'invoice' => ots_subcommand('invoice', options),
  'receipt' => ots_subcommand('receipt', options),
  'passport' => ots_subcommand('passport', options),
  'financial' => ots_subcommand('financial', options),
  'custom' => custom_subcommand(options),
}


begin
  global_parser.order!
  command = ARGV.shift
  subcommands[command].order!
rescue NoMethodError => e
  $stderr.puts global_parser
  exit(1)
end

if command == 'custom'
  if ARGV.length != 2
    $stderr.puts "The 'custom' command requires both DOC_TYPE and FILE arguments."
    exit(1)
  end
  doc_type = ARGV[0]
  file_path = ARGV[1]
  mindee_client = new_custom_client(options, doc_type)
else
  if ARGV.length != 1
    $stderr.puts 'No file specified.'
    exit(1)
  end
  mindee_client = new_ots_client(options, command)
  doc_type = DOCUMENTS[command][:doc_type]
  file_path = ARGV[0]
end

cut_pages = options[:no_cut_pages].nil? ? false : true
doc = mindee_client.doc_from_path(file_path, cut_pages: cut_pages)
puts doc.parse(doc_type).document
