---
title: Getting Started
category: 622b805aaec68102ea7fcbc2
slug: ruby-getting-started
parentDoc: 6294d97ee723f1008d2ab28e
---
This guide will help you get the most out of the Mindee Ruby client library to easily extract data from your documents.

## Installation

### Requirements
The following Ruby versions are tested and supported: 3.0, 3.1, 3.2, 3.3

### Standard Installation
To quickly get started with the Ruby Client Library, Install by adding this line to your application's Gemfile:

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
The `Client` automatically connects to the default endpoints for each product (or creates one with given parameters for
Universal APIs).

The `Client` requires your [API key](https://developers.mindee.com/docs/make-your-first-request#create-an-api-key).

You can either pass these directly to the constructor or through environment variables.


### Pass the API key directly
```rb
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
```rb
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

There are a few different ways of loading a document file, depending on your use case, you can use a:

* [File path](https://developers.mindee.com/docs/ruby-document-loading#loading-from-a-local-path): using the Mindee Client's `source_from_path()` method.
* [File Object](https://developers.mindee.com/docs/ruby-document-loading#loading-from-a-file-object): using the Mindee Client's `source_from_file()` method.
* [Base64 String](https://developers.mindee.com/docs/ruby-document-loading#loading-from-a-base64-encoded-string): using the Mindee Client's `source_from_b64string()` method.
* [Raw Byte sequence](https://developers.mindee.com/docs/ruby-document-loading#loading-from-raw-bytes): using the Mindee Client's `source_from_bytes()` method.
* [URL](https://developers.mindee.com/docs/ruby-document-loading#loading-by-url): using the Mindee Client's `source_from_url()` method.

More details about file loading on the [dedicated page](https://developers.mindee.com/docs/ruby-document-loading).

## Sending a File
To send a file to the API, we need to specify how to process the document.
This will determine which API endpoint is used and how the API return will be handled internally by the library.

More specifically, we need to set a `Mindee::Product` class as the first parameter of the `create_endpoint` method.

This is because the `Endpoint`'s urls will be set according to it

Each document type available in the library has its corresponding class, which inherit from the base
`Mindee::Parsing::Common::Predict` class.

This is detailed in each document-specific guide.

### Off-the-Shelf Documents
Simply setting the correct class is enough:

```rb

result = mindee_client.parse(
  input_source,
  Mindee::Product::Invoice::InvoiceV4
)
```

#### Specific call method
Some products, such as InvoiceV4, ReceiptV5 & FinancialDocumentV1 support both asynchronous polling and synchronous
HTTP calls.
We recommend letting the client library decide which is better by default, but you can override the behavior by setting
the `enqueue` parameter to `true` or `false`.

```rb

result = mindee_client.parse(
  input_source,
  Mindee::Product::Invoice::InvoiceV4,
  enqueue: false
)
```

> 🚧 WARNING: this feature is not available for all products, and may result in errors if used inappropriately.
> Only use it if you are certain of what you are doing.
### Universal Documents (docTI)
For custom documents, the endpoint to use must also be set, and it must take in an `endpoint_name`:

```rb
endpoint = mindee_client.create_endpoint(endpoint_name: 'wnine', account_name: 'my-account')

result = mindee_client.parse(
  input_source,
  Mindee::Product::Universal::Universal,
  endpoint: endpoint
)
```

This is because the `Universal` class is enough to handle the return processing, but the actual endpoint needs to be
specified.

## Process the Result
The response object is common to all documents, including custom documents (using the Universal product). The main
properties are:

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

```rb
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
```rb
response.document.inference.pages.each do |page|
    # as an object, complete
    pp page.prediction

    # as a string, summary in RST format
    puts page.prediction
end
```

#### Page Orientation
The orientation field is only available at the page level as it describes whether the page image should be rotated to
be upright.

If the page requires rotation for correct display, the orientation field gives a prediction among these 3 possible
outputs:

* 0 degrees: the page is already upright
* 90 degrees: the page must be rotated clockwise to be upright
* 270 degrees: the page must be rotated counterclockwise to be upright

```rb
response.document.inference.pages.each do |page|
  puts page.orientation.value
end
```


## Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
