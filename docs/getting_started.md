---
title: Ruby Getting Started
---
This guide will help you get the most out of the Mindee Ruby client library to easily extract data from your documents.

## Installation

### Requirements
The following Ruby versions are tested and supported: 2.6, 2.7, 3.0, 3.1, 3.2

### Standard Installation
To quickly get started with the Ruby OCR SDK, Install by adding this line to your application's Gemfile:

```shell
gem 'mindee'
```
And then execute:

```shell
bundle install
```
Or you can install it like this:

```shell
gem install mindee
```
Finally, Ruby away!

### Development Installation
If you'll be modifying the source code, you'll need to install the required libraries to get started.

We recommend using [Bundler](https://bundler.io/).

1. First clone the repo.

```shell
git clone git@github.com:mindee/mindee-api-ruby.git
```

2. Navigate to the cloned directory and install all required libraries.

```shell
cd mindee-api-ruby
bundle install
```

### Updating the Library
It is important to always check the version of the Mindee OCR SDK you are using, as new and updated
features won’t work on older versions.

To get the latest version of your OCR SDK:

```shell
gem install mindee
```

To install a specific version of Mindee:

```shell
gem install mindee@<version>
```

## Usage

Using Mindee's APIs can be broken down into the following steps:

1. [Initialize a Client](#initializing-the-client)
2. [Load a File](#loading-a-document-file)
3. [Send the File](#sending-a-file) to Mindee's API
4. [Process the Result](#process-the-result) in some way

Let's take a deep dive into how this works.

## Initializing the Client
The `Client` automatically connects to the default endpoints for each product (or creates one with given parameters for Custom APIs).

The `Client` requires your [API key](https://developers.mindee.com/docs/make-your-first-request#create-an-api-key).

You can either pass these directly to the constructor or through environment variables.


### Pass the API key directly
```ruby
# Init a new client and passing the key directly
mindee_client = Mindee::Client.new(api_key: 'my-api-key')
```

### Set the API key in the environment
API keys should be set as environment variables, especially for any production deployment.

The following environment variable will set the global API key:
```shell
MINDEE_API_KEY=my-api-key
```
 
Then in your code:
```ruby
# Init a new client without an API key
mindee_client = Mindee::Client.new
```

### Setting the Request Timeout
The request timeout can be set using an environment variable:
```shell
MINDEE_REQUEST_TIMEOUT=200
```


## Loading a Document File
Before being able to send a document to the API, it must first be loaded.

You don't need to worry about different MIME types, the library will take care of handling
all supported types automatically.

Once a document is loaded, interacting with it is done in exactly the same way, regardless
of how it was loaded.

There are a few different ways of loading a document file, depending on your use case:

* [Path](#path)
* [File Object](#file-object)
* [Base64](#base64)
* [Bytes](#bytes)
* [Urls](#url)

### Path
Load from a file directly from disk. Requires an absolute path, as a string.

```ruby
# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')

# Parse the file
result = mindee_client.parse(
  input_source,
  Mindee::Product::Invoice::InvoiceV4
)
# Print a full summary of the parsed data in RST format
puts result.document
```

### File Object
A normal Ruby file object with a path. Must be in binary mode.

**Note**: The original filename is required when calling the method.

```ruby
File.open(INVOICE_FILE, 'rb') do |fo|
  input_source = mindee_client.source_from_file(fo, "invoice.jpg")
end

result = mindee_client.parse(
  input_source,
  Mindee::Product::Invoice::InvoiceV4
)
```

### Base64
Load file contents from a base64-encoded string.

**Note**: The original filename is required when calling the method.

```ruby
b64_string = "/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLD...."

input_source = mindee_client.source_from_b64string(b64_string, "receipt.jpg")

result = mindee_client.parse(
  input_source,
  Mindee::Product::Receipt::ReceiptV5
)
```

### Bytes
Requires raw bytes.

**Note**: The original filename is required when calling the method.

```ruby
raw_bytes = b"%PDF-1.3\n%\xbf\xf7\xa2\xfe\n1 0 ob..."
input_source = mindee_client.source_from_bytes(raw_bytes, "invoice.pdf")

result = mindee_client.parse(
  input_source,
  Mindee::Product::Invoice::InvoiceV4
)
```

### URL
Requires an url as a String.

**Note**: the url must start with `https://`.
```ruby
input_source = mindee_client.source_from_url("https://www.example.com/invoice.pdf")

result = mindee_client.parse(
  input_source,
  Mindee::Product::Invoice::InvoiceV4
)
```

## Sending a File
To send a file to the API, we need to specify how to process the document.
This will determine which API endpoint is used and how the API return will be handled internally by the library.

More specifically, we need to set a `Mindee::Product` class as the first parameter of the `create_endpoint` method.

This is because the `Endpoint`'s urls will be set according to it

Each document type available in the library has its corresponding class, which inherit from the base `Mindee::Parsing::Common::Predict` class.
This is detailed in each document-specific guide.

### Off-the-Shelf Documents
Simply setting the correct class is enough:
```ruby

result = mindee_client.parse(
  input_source,
  Mindee::Product::Invoice::InvoiceV4
)
```

### Custom Documents
For custom documents, the endpoint to use must also be set, and it must take in an `endpoint_name`:

```ruby
endpoint = mindee_client.create_endpoint(endpoint_name: 'wnine')

result = mindee_client.parse(
  input_source,
  Mindee::Product::Custom::CustomV1,
  endpoint: endpoint
)
```

This is because the `CustomV1` class is enough to handle the return processing, but the actual endpoint needs to be specified.

## Process the Result
The response object is common to all documents, including custom documents. The main properties are:

* `id` — Mindee ID of the document
* `name` — Filename sent to the API
* `inference` — [Inference](#inference)

### Inference
Regroups the predictions at the page level, as well as predictions for the entire document.

* `prediction` — [Document level prediction](#document-level-prediction)
* `pages` — [Page level prediction](#page-level-prediction)

#### Document level prediction
The `prediction` attribute is a `Prediction` object specific to the type of document being processed.
It contains the data extracted from the entire document, all pages combined.

It's possible to have the same field in various pages, but at the document level,
only the highest confidence field data will be shown (this is all done automatically at the API level).

```ruby
# as an object, complete
pp result.document.inference.prediction

# as a string, summary in RST format
puts result.document.inference.prediction
```

#### Page level prediction
The `pages` attribute is a list of `Prediction` objects.

Each page element contains the data extracted for a particular page of the document.
The order of the elements in the array matches the order of the pages in the document.

All response objects have this property, regardless of the number of pages.
Single page documents will have a single entry.

Iteration is done like any Ruby array:
```ruby
response.document.inference.pages.each do |page|
    # as an object, complete
    pp page.prediction

    # as a string, summary in RST format
    puts page.prediction
end
```

#### Page Orientation
The orientation field is only available at the page level as it describes whether the page image should be rotated to be upright.

If the page requires rotation for correct display, the orientation field gives a prediction among these 3 possible outputs:

* 0 degrees: the page is already upright
* 90 degrees: the page must be rotated clockwise to be upright
* 270 degrees: the page must be rotated counterclockwise to be upright

```ruby
response.document.inference.pages.each do |page|
  puts page.orientation.value
end
```

## 🧪 Experimental Features

### PDF repair

Some pdf files might appear fine on your computer, but not on the server.
This _experimental_ feature attempts to fix the file's header information before sending it to the server.

> ⚠️ **Warning**: This feature copies your file and then **alters** it. The original file will be left alone, but the copy might get partially corrupted, and improperly parsed as a result. Use at your own discretion.

To enable it, simply set the `fix_pdf` flag to `true` during source creation:

```rb
input_source = mindee_client.source_from_file(input_file, "name-of-my-file.ext", fix_pdf: true)
```

Alternatively, you can use it through the CLI by setting the `-F` or `--fix-pdf` flag.

Note: Not applicable for documents sent through url.

## Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)
