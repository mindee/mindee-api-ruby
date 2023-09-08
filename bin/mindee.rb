# frozen_string_literal: true
#!/usr/bin/env ruby

require 'bundler/setup'
require 'optparse'
require 'mindee'

DOCUMENTS = {
  "custom" => {
    description: "Custom document type from API builder",
    doc_class: Mindee::Product::Custom::CustomV1,
    sync: true,
    async: false,
  },
  "proof-of-address" => {
    description: 'Proof of Address',
    doc_class: Mindee::Product::ProofOfAddress::ProofOfAddressV1,
    sync: true,
    async: false,
  },
  "cropper" => {
    description: 'Cropper',
    doc_class: Mindee::Product::Cropper::CropperV1,
    sync: true,
    async: false,
  },
  "financial-document" => {
    description: 'Financial Document',
    doc_class: Mindee::Product::FinancialDocument::FinancialDocumentV1,
    sync: true,
    async: false,
  },
  "invoice" => {
    description: 'Invoice',
    doc_class: Mindee::Product::Invoice::InvoiceV4,
    sync: true,
    async: false,
  },
  "receipt" => {
    description: "Expense Receipt",
    doc_class: Mindee::Product::Receipt::ReceiptV5,
    sync: true,
    async: false,
  },
  "passport" => {
    description: "Passport",
    doc_class: Mindee::Product::Passport::PassportV1,
    sync: true,
    async: false,
  },
  "eu-license-plate" => {
    description: "EU License Plate",
    doc_class: Mindee::Product::EU::LicensePlate::LicensePlateV1,
    sync: true,
    async: false,
  },
  "fr-bank-account-details" => {
    description: "FR Bank Account Details",
    doc_class: Mindee::Product::FR::BankAccountDetails::BankAccountDetailsV2,
    sync: true,
    async: false,
  },
  "fr-carte-vitale" => {
    description: "FR Carte Vitale",
    doc_class: Mindee::Product::FR::CarteVitale::CarteVitaleV1,
    sync: true,
    async: false,
  },
  "fr-id-card" => {
    description: "FR ID Card",
    doc_class: Mindee::Product::FR::IdCard::IdCardV2,
    sync: true,
    async: false,
  },
  "us-bank-check" => {
    description: "US Bank Check",
    doc_class: Mindee::Product::US::BankCheck::BankCheckV1,
    sync: true,
    async: false,
  },
  "us-driver-license" => {
    description: "US Driver License",
    doc_class: Mindee::Product::US::DriverLicense::DriverLicenseV1,
    sync: true,
    async: false,
  },
  "invoice-splitter" => {
    description: "US Bank Check",
    doc_class: Mindee::Product::InvoiceSplitter::InvoiceSplitterV1,
    sync: false,
    async: true,
  },
}

options = {}
DEFAULT_CUTTING = {
  page_indexes: [0, 1, 2, 3, 4],
  operation: :KEEP_ONLY,
  on_min_pages: 0,
}

# Initializes custom-specific options
# @param cli_parser [OptionParser]
def custom_subcommand(cli_parser)
  cli_parser.on('-v [VERSION]', '--version [VERSION]', 'Model version for the API') do |v|
    options[:version] = v
  end
  cli_parser.on('-a ACCOUNT_NAME', '--account ACCOUNT_NAME', 'API account name for the endpoint') do |v|
    options[:account_name] = v
  end
end

product_parser = {}
DOCUMENTS.each do |doc_key, doc_value|
  product_parser[doc_key] = OptionParser.new do | opts |
    opts.on('-w', '--all-words', 'Include words in response') do |v|
      options[:all_words] = v
    end
    opts.on('-c', '--cut-pages', "Don't cut document pages") do |v|
      options[:cut_pages] = v
    end
    opts.on('-k [KEY]', '--key [KEY]', 'API key for the endpoint') do |v|
      options[:api_key] = v
    end
    opts.on('-f', '--full', "Print the full data, including pages") do |v|
      options[:print_full] = true
    end
    if (doc_key != 'custom')
      opts.banner = "Product: #{doc_value[:description]}. \nUsage: mindee.rb #{doc_key} [options] file"
      if doc_value[:async]
        if doc_value[:sync]
          opts.on("-A", "--async", "Call asynchronously") do |v|
            options[:parse_async] = v
          end
        end
      else
      end
    else
      opts.banner = "#{doc_value[:description]}. \nUsage: mindee.rb custom [options] endpoint_name file"
      custom_subcommand(opts)
    end
  end
end
options[:parse_async] = false

global_parser = OptionParser.new do | opts |
  opts.banner = "Usage: mindee.rb product [options] file"
  opts.separator "Available products:"
  opts.separator "  #{DOCUMENTS.keys.join("\n  ")}"
end

command = ARGV.shift
if !DOCUMENTS.has_key?(command)
  abort(global_parser.help)
end
doc_class = DOCUMENTS[command][:doc_class]
product_parser[command].parse!

if command == 'custom'
  if ARGV.length < 2
    $stderr.puts "The 'custom' command requires both ENDPOINT_NAME and file arguments."
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
if (options[:file_path].start_with?("https://"))
  input_source = mindee_client.source_from_url(options[:file_path])
else
  input_source = mindee_client.source_from_path(options[:file_path])
end

if command == 'custom'
  endpoint_name = 'endpoint_name'
  custom_endpoint = mindee_client.create_endpoint(
    account_name: endpoint_name,
    endpoint_name: options[:account_name],
    endpoint_version: options[:endpoint_version].nil? ? "1" : options[:endpoint_version]
  )
else
  custom_endpoint = nil
end

page_options = options[:cut_pages].nil? ? nil : default_cutting
if options[:parse_async]
  result = mindee_client.enqueue_and_parse(
    input_source,
    DOCUMENTS[command][:doc_class],
    endpoint: custom_endpoint,
    page_options: page_options,
  )
else
  result = mindee_client.parse(
    input_source,
    DOCUMENTS[command][:doc_class],
    endpoint: custom_endpoint,
    page_options: page_options,
  )
end

if options[:print_full]
  puts result.document
else
  puts result.document.inference.prediction
end
