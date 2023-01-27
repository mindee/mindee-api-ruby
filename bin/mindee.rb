#!/usr/bin/env ruby

require 'bundler/setup'
require 'optparse'

require 'mindee'

DOCUMENTS = {
  "custom" => {
    help: "Custom document type from API builder",
    prediction: Mindee::Prediction::CustomV1,
  },
  "financial-document" => {
    help: 'Financial Document',
    prediction: Mindee::Prediction::FinancialDocumentV1,
  },
  "invoice" => {
    help: 'Invoice',
    prediction: Mindee::Prediction::InvoiceV4,
  },
  "receipt" => {
    help: "Expense Receipt",
    prediction: Mindee::Prediction::ReceiptV4,
  },
  "passport" => {
    help: "Passport",
    prediction: Mindee::Prediction::PassportV1,
  },
  "shipping-container" => {
    help: "Shipping Container",
    prediction: Mindee::Prediction::ShippingContainerV1,
  },
  "eu-license-plate" => {
    help: "EU License Plate",
    prediction: Mindee::Prediction::EU::LicensePlateV1,
  },
  "fr-bank-account-details" => {
    help: "FR Bank Account Details",
    prediction: Mindee::Prediction::FR::BankAccountDetailsV1,
  },
  "fr-carte-vitale" => {
    help: "FR Carte Vitale",
    prediction: Mindee::Prediction::FR::CarteVitaleV1,
  },
  "fr-id-card" => {
    help: "FR ID Card",
    prediction: Mindee::Prediction::FR::IdCardV1,
  },
  "us-bank-check" => {
    help: "US Bank Check",
    prediction: Mindee::Prediction::US::BankCheckV1,
  },
}

options = {
  api_key: '',
  print_full: false,
}

def ots_subcommand(command, options)
  OptionParser.new do |opt|
    opt.banner = "Usage: #{command} [options] FILE"
    opt.on('-k [KEY]', '--key [KEY]', 'API key for the endpoint') do |v|
      options[:api_key] = v
    end
    opt.on('-w', '--with-words', 'Include words in response') do |v|
      options[:include_words] = v
    end
    opt.on('-c', '--cut-pages', "Cut document pages") do |v|
      options[:cut_pages] = v
    end
  end
end

def custom_subcommand(options)
  OptionParser.new do |opt|
    opt.banner = "Usage: custom [options] ENDPOINT_NAME FILE"
    opt.on('-w', '--with-words', 'Include words in response') do |v|
      options[:include_words] = v
    end
    opt.on('-c', '--cut-pages', "Don't cut document pages") do |v|
      options[:cut_pages] = v
    end
    opt.on('-k [KEY]', '--key [KEY]', 'API key for the endpoint') do |v|
      options[:api_key] = v
    end
    opt.on('-v [VERSION]', '--version [VERSION]', 'Model version for the API') do |v|
      options[:version] = v
    end
    opt.on('-a ACCOUNT_NAME', '--account ACCOUNT_NAME', 'API account name for the endpoint') do |v|
      options[:account_name] = v
    end
  end
end

global_parser = OptionParser.new do |opt|
  opt.banner = "Usage: #{$PROGRAM_NAME} [options] subcommand [options] FILE"
  opt.separator('')
  opt.separator("subcommands: #{DOCUMENTS.keys.join(', ')}")
  opt.separator('')
  opt.on('-f', '--full', "Print the full data, including pages") do |v|
    options[:print_full] = true
  end
end

global_parser.order!
command = ARGV.shift
if command == 'custom'
  custom_subcommand(options).order!
elsif DOCUMENTS.keys.include? command || ''
  ots_subcommand(command, options).order!
else
  $stderr.puts global_parser
  exit(1)
end

mindee_client = Mindee::Client.new(api_key: options[:api_key])

if command == 'custom'
  if ARGV.length != 2
    $stderr.puts "The 'custom' command requires both ENDPOINT_NAME and FILE arguments."
    exit(1)
  end
  doc_type = ARGV[0]
  file_path = ARGV[1]
  mindee_client.add_endpoint(
    options[:account_name], doc_type, version: options[:version] || '1',
  )
else
  if ARGV.length != 1
    $stderr.puts 'No file specified.'
    exit(1)
  end
  doc_type = ''
  file_path = ARGV[0]
end

default_cutting = {
  page_indexes: [0, 1, 2, 3, 4],
  operation: :KEEP_ONLY,
  on_min_pages: 0,
}
page_options = options[:cut_pages].nil? ? nil : default_cutting
doc = mindee_client.doc_from_path(file_path)
result = doc.parse(DOCUMENTS[command][:prediction], endpoint_name: doc_type, page_options: page_options)
if options[:print_full]
  puts result
else
  puts result.inference.prediction
end
