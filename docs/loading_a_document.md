---
title: Document Loading
category: 622b805aaec68102ea7fcbc2
slug: ruby-document-loading
parentDoc: 6294d97ee723f1008d2ab28e
---

Before sending a document to Mindee’s API, you first need to load the file into one of our input source wrappers. These wrappers not only validate the file type (using a trusted MIME type check) but also give you access the following helper methods:
* [image compression](https://developers.mindee.com/docs/ruby-common-file-operations#image-compression)
* [pdf compression](https://developers.mindee.com/docs/ruby-common-file-operations#pdf-compression)
* [PDF fixing](https://developers.mindee.com/docs/ruby-common-file-operations#pdf-fixing)

> 📘 Regardless of how a document is loaded, the subsequent parsing or workflow operations remain the same.

## Loading a Document File

Mindee’s Ruby client supports several methods for loading a document.


These can either be done locally:
* Loading from a [local path](#loading-from-a-local-path)
* Loading from a [File object](#loading-from-a-file-object)
* Loading from a [Base64-encoded string](#loading-from-a-base64-encoded-string)
* Loading from a [raw sequence of bytes](#loading-from-raw-bytes)

These four methods inherit from the `LocalInputSource` class, which provides a few common utility features described [here](#under-the-hood---local-input-source-details).

Or loading from a [URL](#loading-by-url).

### Loading from a Local Path

The most straightforward way of loading a document: load a file directly from disk by providing its path.

Example:
```ruby
# Initialize the client.
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk using its absolute path.
input_source = mindee_client.source_from_path('/absolute/path/to/file.ext')
```

### Loading from a File Object

When you already have an open file (in binary mode), you can pass it along with its original filename.

Example:

```ruby
File.open('invoice.jpg', 'rb') do |file_obj|
    # Creating a local input source from the file object.
    input_source = mindee_client.source_from_file(file_obj, "invoice.jpg")
    # Parsing happens similarly.
end
```


### Loading from a Base64-Encoded String

For cases where you have file data encoded in Base64, load the document by providing the encoded string along with the original filename. This converts the Base64 string into a local input source for further processing.

Example:

```ruby
b64_string = "/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAgGBgcGB..." # Example dummy b64_string.

input_source = mindee_client.source_from_b64string(b64_string, "receipt.jpg")
```


### Loading from Raw Bytes

If you have the file’s raw binary data (as bytes), create an input source by passing the bytes and the original filename.

Example:

```ruby
raw_bytes = b"%PDF-1.3\n%\xbf\xf7\xa2\xfe\n1 0 obj..." # Example dummy raw bytes sequence.

input_source = mindee_client.source_from_bytes(raw_bytes, "invoice.pdf")
```

### Loading by URL

For remote documents, you can load a file through its URL. The server will accept direct urls if:
* They begin with "https://".
* They point to a valid file.
* They do not redirect the request (e.g. Google Drive documents or proxies).

Under the hood, the [Mindee::Input::Source::URLInputSource](https://mindee.github.io/mindee-api-ruby/Mindee/Input/Source/URLInputSource.html) class validates the URL, but won't perform an HTTP GET request unless specifically requested (using Ruby’s Net::HTTP).

Example:
```ruby
input_source = mindee_client.source_from_url("https://www.example.com/invoice.pdf")
result = mindee_client.parse(input_source, Mindee::Product::Invoice::InvoiceV4)
```

To download the files before sending them, you can use the `as_local_input_source` method. It allows to follow redirects, and supports optional authentication (via basic auth or JWT tokens). You can optionally download and save the file locally or convert it into a local input source for further processing—thus benefiting from the same processing methods as local files.

Additional URL features include:

* Validation: The URLInputSource throws an error if the URL does not start with “https://”.
* Authentication: You can supply basic authentication (username/password) or a bearer token.
* Local Conversion: Methods such as `write_to_file` let you download and inspect the file locally. Alternatively, `as_local_input_source` converts the downloaded content into a LocalInputSource so you can apply operations like compression.

Example:
```ruby
# Load the URL input normally:
remote_input_source = mindee_client.source_from_url("https://www.example.com/invoice.pdf")

# Download the file and convert it to a `BytesInputSource` (type of `LocalInputSource`):
local_input_source = remote_input_source.as_local_input_source(filename: 'my_downloaded_invoice.pdf')

# Download the file and save it to the specified directory:
local_downloaded_file_path = remote_input_source.write_to_file("path/to/my/downloaded/invoice.pdf")
```

### Under the Hood - Local Input Source Details

When loading using from either a path, file, raw byte sequence or base64 string, the created object inherits from [Mindee::Input::Source::LocalInputSource](https://mindee.github.io/mindee-api-ruby/Mindee/Input/Source/LocalInputSource.html). Key features include:

* Automatic MIME Type Validation using Marcel to check for server file format compliance. 
* An option ([fix_pdf](https://mindee.github.io/mindee-api-ruby/Mindee/Input/Source/LocalInputSource.html#initialize-instance_method)) to attempt recovery of PDFs with broken header information.
* File Operations:
  * [compress!](https://mindee.github.io/mindee-api-ruby/Mindee/Input/Source/LocalInputSource.html#compress!-instance_method) – Compresses the file by invoking either the PDFCompressor for PDFs or the ImageCompressor for images. Parameters such as quality, max dimensions, and options to force or disable source text (for PDFs) are available.  
  * `write_to_file` ([URLInputSource version](https://mindee.github.io/mindee-api-ruby/Mindee/Input/Source/URLInputSource.html#write_to_file-instance_method), [LocalInputSource version](https://mindee.github.io/mindee-api-ruby/Mindee/Input/Source/LocalInputSource.html#write_to_file-instance_method)) – Saves the current state of the input (after possible operations) to disk. This is handy for inspection before parsing.
  * [count_pages](https://mindee.github.io/mindee-api-ruby/Mindee/Input/Source/LocalInputSource.html#count_pages-instance_method) – For PDF files, returns the total page count; by default, non-PDF files are assumed to be single-page documents.

## Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
