[![License: MIT](https://img.shields.io/github/license/mindee/mindee-api-ruby)](https://opensource.org/licenses/MIT) [![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/mindee/mindee-api-ruby/test.yml)](https://github.com/mindee/mindee-api-ruby) [![Gem Version](https://img.shields.io/gem/v/mindee)](https://rubygems.org/gems/mindee) [![Downloads](https://img.shields.io/gem/dt/mindee.svg)](https://rubygems.org/gems/mindee)

# Mindee API Helper Library for Ruby

Quickly and easily connect to Mindee's API services using Ruby.

## Requirements

The following Ruby versions are tested and supported: 3.0, 3.1, 3.2, 3.3

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

### Environment Variables

This library offers customizable features through environment variables. While there may be instances where you need to
rely on them, it's crucial to exercise caution when modifying them to avoid unintended consequences.

If you're unsure whether you need to adjust these variables, it's advisable to refrain from doing so unless you have a
specific reason. Accidentally overwriting them can lead to unexpected behavior.

Before making any changes, we recommend reviewing the following information to understand the purpose and potential
impact of each environment variable:

* `MINDEE_API_KEY`: 
  * **Description**: Your personal Mindee API Key as shown on the platform. Be careful not to show this publicly!
  * **Default Value**: `nil`
* `MINDEE_BASE_URL`:
  * **Description**: The default base URL of the API endpoint. Use this variable to specify the root URL for API requests. Modify as needed for proxy configurations or changes in API endpoint location.
  * **Default Value**: `https://api.mindee.net/v1`
* `MINDEE_REQUEST_TIMEOUT`:
  * **Description**: The default timeout for HTTP requests (in seconds).
  * **Default Value**: `120`

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

### Universal - All Other Documents

The Universal product acts as a catch-all for every and any API if it doesn't have an assigned product name.

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

result = mindee_client.enqueue_and_parse(
  input_source,
  Mindee::Product::Universal::Universal,
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
## Asynchronously Parsing a File

This allows for easier handling of bursts of documents sent.

Some products are only available asynchronously, check the example code
directly on the Mindee platform.


### Enqueue and Parse a Webhook Response
This is an optional way of handling asynchronous APIs.

```rb
require 'mindee'

# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')


# Parse the file
enqueue_response = mindee_client.enqueue(
  input_source,
  Mindee::Product::InternationalId::InternationalIdV2
)

job_id = enqueue_response.job.id

# Load the JSON string sent by the Mindee webhook POST callback.
# Reading the callback data will vary greatly depending on your HTTP server.
# This is therefore beyond the scope of this example.

local_response = Mindee::Input::LocalResponse.new(request.body.string)

# You can also use a File object as the input.
# FILE_PATH = File.join('path', 'to', 'file.json').freeze
# local_response = Mindee::Input::LocalResponse.new(FILE_PATH);

# Optional: verify the HMAC signature.
unless local_response.valid_hmac_signature?(my_secret_key, 'invalid signature')
  raise "Invalid HMAC signature!"
end


# Deserialize the response:
result = mindee_client.load_prediction(
        Mindee::Product::InternationalId::InternationalIdV2,
        local_response
)

# Print a full summary of the parsed data in RST format
puts result.document
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

* [Ruby Overview](https://developers.mindee.com/docs/ruby-getting-started)
* [Universal API Ruby](https://developers.mindee.com/docs/ruby-universal-ocr)
* [Invoice OCR Ruby](https://developers.mindee.com/docs/ruby-invoice-ocr)
* [International Id OCR Ruby](https://developers.mindee.com/docs/ruby-international-id-ocr)
* [Financial Document OCR Ruby](https://developers.mindee.com/docs/ruby-financial-document-ocr)
* [Passport OCR Ruby](https://developers.mindee.com/docs/ruby-passport-ocr)
* [Proof of Address OCR Ruby](https://developers.mindee.com/docs/ruby-proof-of-address-ocr)
* [Receipt OCR Ruby](https://developers.mindee.com/docs/ruby-receipt-ocr)
* [Resume OCR Ruby](https://developers.mindee.com/docs/ruby-resume-ocr)
* [EU License Plate OCR Ruby](https://developers.mindee.com/docs/ruby-eu-license-plate-ocr)
* [EU Driver License OCR Ruby](https://developers.mindee.com/docs/ruby-eu-driver-license-ocr)
* [FR Bank Account Details OCR Ruby](https://developers.mindee.com/docs/ruby-fr-bank-account-details-ocr)
* [FR Bank Statement OCR Ruby](https://developers.mindee.com/docs/ruby-fr-bank-statement-ocr)
* [FR Health Card OCR Ruby](https://developers.mindee.com/docs/ruby-fr-health-card-ocr)
* [FR ID Card OCR Ruby](https://developers.mindee.com/docs/ruby-fr-carte-nationale-didentite-ocr)
* [US Bank Check OCR Ruby](https://developers.mindee.com/docs/ruby-us-bank-check-ocr)
* [US Driver License OCR Ruby](https://developers.mindee.com/docs/ruby-us-driver-license-ocr)
* [US W9 API Ruby](https://developers.mindee.com/docs/ruby-us-w9-ocr)
* [Barcode Reader API Ruby](https://developers.mindee.com/docs/ruby-barcode-reader-ocr)
* [Cropper API Ruby](https://developers.mindee.com/docs/ruby-cropper-ocr)
* [Invoice Splitter API Ruby](https://developers.mindee.com/docs/ruby-invoice-splitter-ocr)
* [Multi Receipts Detector API Ruby](https://developers.mindee.com/docs/ruby-multi-receipts-detector-ocr)

You can also take a look at the
[Reference Documentation](https://mindee.github.io/mindee-api-ruby/).

## License

Copyright © Mindee, SA

Available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Questions?

[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
