#!/usr/bin/env ruby

require 'bundler/setup'
require 'optparse'

require 'mindee'

DOCUMENTS = {
  "invoice" => {
    help: 'Invoice',
    required_keys: ["invoice"],
    doc_type: "invoice",
  },
  "receipt" => {
    help: "Expense Receipt",
    required_keys: ["receipt"],
    doc_type: "receipt",
  },
  "passport" => {
    help: "Passport",
    required_keys: ["passport"],
    doc_type: "passport",
  },
  "financial" => {
    help: "Financial Document (receipt or invoice)",
    required_keys: ["invoice", "receipt"],
    doc_type: "financial_doc",
  },
  "custom" => {
    help: "Custom document type from API builder",
  },
}

options = {}

def ots_subcommand(command, options)
  OptionParser.new do |opt|
    info = DOCUMENTS[command]
    opt.banner = "Usage: #{command} [options] FILE"
    info[:required_keys].each do |key_name|
      opt.on("--#{key_name}-key [KEY]", "API key for #{key_name} document endpoint") do |v|
        options["#{key_name}_api_key"] = v
      end
      opt.on('-w', '--with-words', 'Include words in response') do |v|
        options[:include_words] = v
      end
    end
  end
end

def new_client(options, command)
  raise_on_error = options[:no_raise_errors].nil? ? true : false
  mindee_client = Mindee::Client.new(raise_on_error: raise_on_error)
  info = DOCUMENTS[command]
  kwargs = {}
  if info[:required_keys].length > 1
    info[:required_keys].each do |key|
      key_name = "#{key}_api_key"
      kwargs[key_name.to_sym] = options[key_name]
    end
  else
    kwargs[:api_key] = options["#{info[:required_keys][0]}_api_key"]
  end
  mindee_client.send("config_#{info[:doc_type]}", **kwargs)
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
#end.parse!

subcommands = {
  'invoice' => ots_subcommand('invoice', options),
  'receipt' => ots_subcommand('receipt', options),
  'passport' => ots_subcommand('passport', options),
}


begin
  global_parser.order!
  command = ARGV.shift
  subcommands[command].order!
rescue NoMethodError => e
  $stderr.puts global_parser
  exit(1)
end

unless ARGV.length == 1
  $stderr.puts 'No file specified'
  exit(1)
end

# puts "Command: #{command}"
# puts "Options: #{options}"

mindee_client = new_client(options, command)
file_path = ARGV[0]
doc = mindee_client.doc_from_path(file_path)
puts doc.parse(command).document
