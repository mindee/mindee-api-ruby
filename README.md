[![License: MIT](https://img.shields.io/github/license/mindee/mindee-api-ruby)](https://opensource.org/licenses/MIT) [![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/mindee/mindee-api-ruby/test.yml)](https://github.com/mindee/mindee-api-ruby) [![Gem Version](https://img.shields.io/gem/v/mindee)](https://rubygems.org/gems/mindee) [![Downloads](https://img.shields.io/gem/dt/mindee.svg)](https://rubygems.org/gems/mindee)

# Mindee API Helper Library for Ruby
Quickly and easily connect to Mindee's API services using Ruby.

## Requirements
The following Ruby versions are tested and supported: 2.6, 2.7, 3.0, 3.1, 3.2

## Quick Start
Here's the TL;DR of getting started.

First, get an [API Key](https://developers.mindee.com/docs/create-api-key)

Install by adding this line to your application's Gemfile:

```ruby
gem 'mindee'
```

And then execute:
```sh
bundle install
```

Finally, Ruby away!

### Loading a File and Parsing It

#### Global Documents
```ruby
require 'mindee'

# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')
result = mindee_client.parse(
  input_source,
  Mindee::Product::Invoice::InvoiceV4
)

# Print a full summary of the parsed data in RST format
puts result.document
```

**Note:** Files can also be loaded from:

A URL (`https`):
```rb
input_source = mindee_client.source_from_url("https://my-url")
```

A bytes input stream:
```rb
input_source = mindee_client.source_from_bytes('/path/to/the/file.ext', "name-of-my-file.ext")
```

A base64 encoded string:
```rb
input_source = mindee_client.source_from_b64string('/path/to/the/file.ext', "name-of-my-file.ext")
```

A ruby `file` object:
```rb
input_source = mindee_client.source_from_file(input_file, "name-of-my-file.ext")
```

#### Region-Specific Documents
```ruby
require 'mindee'

# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')

result = mindee_client.parse(
  input_source,
  Mindee::Product::EU::LicensePlate::LicensePlateV1
)

# Print a full summary of the parsed data in RST format
puts result.document
```

### Custom Document (API Builder)
```ruby
require 'mindee'

# Init a new client and configure your custom document
mindee_client = Mindee::Client.new(api_key: 'my-api-key')
endpoint = mindee_client.create_endpoint(
  endpoint_name: 'my-endpoint',
  account_name: 'my-account'
)

# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')

result = mindee_client.parse(
  input_source,
  Mindee::Product::Custom::CustomV1,
  endpoint: endpoint
)

# Print a full summary of the parsed data in RST format
puts result.document

# Looping over all prediction values
result.document.inference.prediction.fields.each do |field_name, field_data|
  puts field_name
  puts field_data.values
  puts field_data.to_s
end
```

## CLI Tool

A command-line interface tool is available to quickly test documents:
```sh
ruby ./bin/mindee.rb invoice path/to/your/file.ext
```


Using the ruby bundler:
```sh
bundle exec ruby ./bin/mindee.rb invoice path/to/your/file.ext
```

## Further Reading
There's more to it than that for those that need more features, or want to
customize the experience.

* [Ruby Overview](https://developers.mindee.com/docs/getting-started-ocr-ruby)
* [Custom OCR Ruby](https://developers.mindee.com/docs/api-builder-ocr-ruby)
* [Generated API Ruby](https://developers.mindee.com/docs/generated-api-ruby)
* [Invoice OCR Ruby](https://developers.mindee.com/docs/invoice-ocr-ruby)
* [International Id OCR Ruby](https://developers.mindee.com/docs/international-id-ocr-ruby)
* [Financial Document OCR Ruby](https://developers.mindee.com/docs/financial-document-ocr-ruby)
* [Passport OCR Ruby](https://developers.mindee.com/docs/passport-ocr-ruby)
* [Proof of Address OCR Ruby](https://developers.mindee.com/docs/proof-of-address-ocr-ruby)
* [Receipt OCR Ruby](https://developers.mindee.com/docs/receipt-ocr-ruby)
* [EU License Plate OCR Ruby](https://developers.mindee.com/docs/eu-license-plate-ocr-ruby)
* [EU Driver License OCR Ruby](https://developers.mindee.com/docs/eu-driver-license-ocr-ruby)
* [FR Bank Account Details OCR Ruby](https://developers.mindee.com/docs/fr-bank-account-details-ocr-ruby)
* [FR Bank Statement OCR Ruby](https://developers.mindee.com/docs/fr-bank-statement-ocr-ruby)
* [FR Carte Vitale OCR Ruby](https://developers.mindee.com/docs/fr-carte-vitale-ocr-ruby)
* [FR ID Card OCR Ruby](https://developers.mindee.com/docs/fr-id-card-ocr-ruby)
* [US Bank Check OCR Ruby](https://developers.mindee.com/docs/us-bank-check-ocr-ruby)
* [US Driver License OCR Ruby](https://developers.mindee.com/docs/us-driver-license-ocr-ruby)
* [US W9 API Ruby](https://developers.mindee.com/docs/us-w9-api-ruby)
* [Barcode Reader API Ruby](https://developers.mindee.com/docs/barcode-reader-api-ruby)
* [Cropper API Ruby](https://developers.mindee.com/docs/cropper-api-ruby)
* [Invoice Splitter API Ruby](https://developers.mindee.com/docs/invoice-splitter-api-ruby)
* [Multi Receipts Detector API Ruby](https://developers.mindee.com/docs/multi-receipts-detector-api-ruby)


You can also take a look at the
[Reference Documentation](https://mindee.github.io/mindee-api-ruby/).


## License
Copyright © Mindee, SA

Available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)
