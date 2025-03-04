---
title: Document Loading
category: 622b805aaec68102ea7fcbc2
slug: ruby-document-loading
parentDoc: 6294d97ee723f1008d2ab28e
---

## Calling the Mindee API using webhooks

> 🚧 This feature is only available for compatible products.
> 
> See the `Supports Polling/Webhooks` section on the product's documentation.

After [setting up a webhook for your account](https://developers.mindee.com/docs/webhooks), you can send a document,  
and then retrieve the results from an API call in the following fashion:

```rb
# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')

# Send the file to the server
enqueue_response = mindee_client.enqueue(
        input_source,
        Mindee::Product::Receipt::ReceiptV5 # ReceiptV5 supports asynchronous polling
)
```

Once your prediction is ready, the server will send it to your webhook. You can then use the payload as a regular  
prediction:

```rb
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
        Mindee::Product::Receipt::ReceiptV5, # The prediction type must match the initial enqueuing to work properly.
        local_response
)

# Print a summary of the parsed data in RST format
puts result.document
```

## Parsing operations

Operations pertaining to the Client's `parse()` method.
The parsing process supports both synchronous and asynchronous modes, and you can fine-tune its behavior using several options.

### Polling options

When performing an asynchronous parse (i.e. when the document is enqueued), the client will poll the API for the result.
The following options control the polling behavior:

* `initial_delay_sec`: The initial delay (in seconds) before the first polling attempt.
* `delay_sec`: The delay (in seconds) between subsequent polls.
* `max_retries`: The maximum number of polling attempts before timing out.

These parameters ensure that the client does not overload the API with too-frequent requests and also avoid premature  
timeouts.

Example:

```rb
result = mindee_client.parse(
  input_source,
  Mindee::Product::Invoice::InvoiceV4,
  options: {
    initial_delay_sec: 2,   # Wait 2 seconds before the first poll.
    delay_sec: 1.5,         # Wait 1.5 seconds between polls.
    max_retries: 80         # Try polling a maximum of 80 times.
  }
)
```

> ⚠️ Warning: Setting `delay_sec` too low might lead to insufficient wait time between polls.
> 
> This will cause the server to block your API calls for a short time (HTTP 429 errors).

### Page operations

When parsing PDFs, you can preprocess the document using page operations.
Using the `page_options` parameter, you can specify which pages to keep or remove even before the file is sent to the server.
This is especially useful if your document contains extraneous pages that you do not want to process.

The available options are:

* `page_indexes`: An array of zero-based page indexes.
* `operation`: The operation to perform—either:
  * `:KEEP_ONLY` (keep only the specified pages)
  * `:REMOVE` (remove the specified pages).
* `on_min_pages`: Apply the operation only if the document has at least the specified number of pages.

Example:

```rb
page_options = {
  page_indexes:[1, 3],    # Only target pages 1 and 3.
  operation: :KEEP_ONLY,  # Remove all other pages.
  on_min_pages: 3         # Only apply if the document has at least 3 pages.
}

result = mindee_client.parse(
  input_source,
  Mindee::Product::Invoice::InvoiceV4,
  options: {
    page_options: page_options
  }
)
```

> ⚠️ Warning: Page operations alter the document's content.
> 
> Ensure that this behavior is acceptable for your use case, as there is no undo once the pages are modified.

## Workflow operations

Workflow operations are similar to parsing operations, but they apply to calls made through the workflow feature.

Example:

```rb
workflow_options = {
    document_alias: "my_document",
    priority: :high,
    page_options: {
          page_indexes:[0, 1],
          operation: :REMOVE
    }
  }

result = mindee_client.execute_workflow(
  input_source,
  "workflow_id",
  options: workflow_options
)
```

## Enqueueing and polling manually

> ❗️ We _strongly_ recommend you use a webhook setup, or a simple`parse()` call for most operations.
> 
> Only use manual polling if you are **certain** that it is the best solution for you.

> 🚧 This feature is only available for compatible products.
> 
> See the `Supports Polling/Webhooks` section on the product's documentation.

Instead of relying on the `parse()` method, you can enqueue documents and poll  
the server manually:

```rb
# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')

# Send the file to the server
enqueue_response = mindee_client.enqueue(
  input_source,
  Mindee::Product::Invoice::InvoiceV4 # InvoiceV4 supports asynchronous polling
)

job_id = enqueue_response.job.id

queue_res = parse_queued(job_id, Mindee::Product::Invoice::InvoiceV4, endpoint: endpoint)
polling_attempts = 0

while [Mindee::Parsing::Common::JobStatus::PROCESSING, Mindee::Parsing::Common::JobStatus::WAITING].include?(
        queue_res.job.status) && polling_attempts < 80 # Recommended amounts of total retries for asynchronous polling.
  sleep(1.5) # Recommended waiting time for re-attempts
  queue_res = parse_queued(job_id, Mindee::Product::Invoice::InvoiceV4)
  polling_attempts += 1
end

# If all went well, print a short summary of the result.
if queue_res.job.status == Mindee::Parsing::Common::JobStatus::COMPLETED
  puts queue_res.document
end
```

## Loading a Document File

Before sending a document to Mindee’s API, you first need to load the file into one of our input source wrappers.  
These wrappers not only validate the file type (using a trusted MIME type check) but also give you access the following helper methods:

* [image compression](https://developers.mindee.com/docs/ruby-advanced-file-operations#image-compression)
* [pdf compression](https://developers.mindee.com/docs/ruby-advanced-file-operations#pdf-compression)
* [PDF fixing](https://developers.mindee.com/docs/ruby-advanced-file-operations#pdf-fixing)

> 📘 Regardless of how a document is loaded, the subsequent parsing or workflow operations remain the same.

Mindee’s Ruby client supports several methods for loading a document.

These can either be done locally:

* Loading from a [local path](#loading-from-a-local-path)
* Loading from a [File object](#loading-from-a-file-object)
* Loading from a [Base64-encoded string](#loading-from-a-base64-encoded-string)
* Loading from a [raw sequence of bytes](#loading-from-raw-bytes)

These four methods inherit from the `LocalInputSource` class, which provides a few common utility features described  
[here](#under-the-hood---local-input-source-details).

Or loading from a [URL](#loading-by-url).

### Loading from a Local Path

The most straightforward way of loading a document: load a file directly from disk by providing its path.

Example:

```rb
# Initialize the client.
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk using its absolute path.
input_source = mindee_client.source_from_path('/absolute/path/to/file.ext')
```

### Loading from a File Object

When you already have an open file (in binary mode), you can pass it along with its original filename.

Example:

```rb
File.open('invoice.jpg', 'rb') do |file_obj|
    # Creating a local input source from the file object.
    input_source = mindee_client.source_from_file(file_obj, "invoice.jpg")
    # Parsing happens similarly.
end
```

### Loading from a Base64-Encoded String

For cases where you have file data encoded in Base64, load the document by providing the encoded string along with the  
original filename. This converts the Base64 string into a local input source for further processing.

Example:

```rb
b64_string = "/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAgGBgcGB..." # Example dummy b64_string.

input_source = mindee_client.source_from_b64string(b64_string, "receipt.jpg")
```

### Loading from Raw Bytes

If you have the file’s raw binary data (as bytes), create an input source by passing the bytes and the original  
filename.

Example:

```rb
raw_bytes = b"%PDF-1.3\n%\xbf\xf7\xa2\xfe\n1 0 obj..." # Example dummy raw bytes sequence.

input_source = mindee_client.source_from_bytes(raw_bytes, "invoice.pdf")
```

### Loading by URL

For remote documents, you can load a file through its URL. The server will accept direct urls if:

* They begin with "https\://".
* They point to a valid file.
* They do not redirect the request (e.g. Google Drive documents or proxies).

Under the hood, the  
[Mindee::Input::Source::URLInputSource](https://mindee.github.io/mindee-api-ruby/Mindee/Input/Source/URLInputSource.html)  
class validates the URL, but won't perform an HTTP GET request unless specifically requested (using Ruby’s Net::HTTP).

Example:

```rb
input_source = mindee_client.source_from_url("https://www.example.com/invoice.pdf")
result = mindee_client.parse(input_source, Mindee::Product::Invoice::InvoiceV4)
```

To download the files before sending them, you can use the `as_local_input_source` method.
It allows to follow redirects, and supports optional authentication (via basic auth or JWT tokens).
You can optionally download and save the file locally or convert it into a local input source for further processing—thus benefiting from the same processing methods as local files.

Additional URL features include:

* Validation: The URLInputSource throws an error if the URL does not start with “https\://”.
* Authentication: You can supply basic authentication (username/password) or a bearer token.
* Local Conversion: Methods such as `write_to_file` let you download and inspect the file locally. Alternatively,
* `as_local_input_source` converts the downloaded content into a LocalInputSource so you can apply operations like
* compression.

Example:

```rb
# Load the URL input normally:
remote_input_source = mindee_client.source_from_url("https://www.example.com/invoice.pdf")

# Download the file and convert it to a `BytesInputSource` (type of `LocalInputSource`):
local_input_source = remote_input_source.as_local_input_source(filename: 'my_downloaded_invoice.pdf')

# Download the file and save it to the specified directory:
local_downloaded_file_path = remote_input_source.write_to_file("path/to/my/downloaded/invoice.pdf")
```

### Under the Hood - Local Input Source Details

When loading using from either a path, file, raw byte sequence or base64 string, the created object inherits from  
[Mindee::Input::Source::LocalInputSource](https://mindee.github.io/mindee-api-ruby/Mindee/Input/Source/LocalInputSource.html). Key features include:

* Automatic MIME Type Validation using Marcel to check for server file format compliance. 
* An option ([repair_pdf](https://mindee.github.io/mindee-api-ruby/Mindee/Input/Source/LocalInputSource.html#initialize-instance_method)) to attempt recovery of PDFs with broken header information.
* File Operations:
  * [compress!](https://mindee.github.io/mindee-api-ruby/Mindee/Input/Source/LocalInputSource.html#compress!-instance_method) – Compresses the file by invoking either the PDFCompressor for PDFs or the ImageCompressor for images. Parameters such as quality, max dimensions, and options to force or disable source text (for PDFs) are available.  
  * `write_to_file` ([URLInputSource version](https://mindee.github.io/mindee-api-ruby/Mindee/Input/Source/URLInputSource.html#write_to_file-instance_method), [LocalInputSource version](https://mindee.github.io/mindee-api-ruby/Mindee/Input/Source/LocalInputSource.html#write_to_file-instance_method)) – Saves the current state of the input (after possible operations) to disk. This is handy for inspection before parsing.
  * [count_pages](https://mindee.github.io/mindee-api-ruby/Mindee/Input/Source/LocalInputSource.html#count_pages-instance_method) – For PDF files, returns the total page count; by default, non-PDF files are assumed to be single-page documents.

## Questions?

[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
