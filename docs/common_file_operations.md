---
title: Ruby Common File Operations
category: 622b805aaec68102ea7fcbc2
slug: ruby-common-file-operations
parentDoc: 6294d97ee723f1008d2ab28e
---

## Parsing operations

Operations pertaining to the Client's `parse()` method. The parsing process supports both synchronous and asynchronous modes, and you can fine-tune its behavior using several options.

### Polling options

When performing an asynchronous parse (i.e. when the document is enqueued), the client will poll the API for the result. The following options control the polling behavior:

- `initial_delay_sec`: The initial delay (in seconds) before the first polling attempt.
- `delay_sec`: The delay (in seconds) between subsequent polls.
- `max_retries`: The maximum number of polling attempts before timing out.

These parameters ensure that the client does not overload the API with too-frequent requests and also avoid premature timeouts.

Example:
```ruby
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
> ⚠️ Warning: Setting `delay_sec` too low might lead to insufficient wait time between polls, causing the server to block your API calls for a short time.

### Page operations

When parsing PDFs, you can preprocess the document using page operations. Using the `page_options` parameter, you can specify which pages to keep or remove even before the file is sent to the server. This is especially useful if your document contains extraneous pages that you do not want to process.

The available options are:
* `page_indexes`: An array of zero-based page indexes.
* `operation`: The operation to perform—either:
  * `:KEEP_ONLY` (keep only the specified pages)
  * `:REMOVE` (remove the specified pages).
* `on_min_pages`: Apply the operation only if the document has at least the specified number of pages.

Example:
```ruby
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
> ⚠️ Warning: Page operations alter the document's content. Ensure that this behavior is acceptable for your use case, as there is no undo once the pages are modified.

## Workflow operations

Workflow operations are similar to parsing operations, but they apply to calls made through the workflow feature.

Example:
```ruby
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

## File operations

> ❗️ Disclaimer: the file operations listed below do not directly manipulate the files you will pass to the library, 
they will instead create a copy before applying any operations, 
> which means that the file you send may not be an exact copy of the file the server will receive.
> To avoid any unexpected or unwanted result, you can save a copy of the created file locally to inspect it visually before sending it.

### Image operations

Image operations mainly include the compression functionality for image files (JPEG, PNG, etc.) via the `compress!` method available on a LocalInputSource.
This method allows you to reduce file size by specifying quality and dimension constraints.

Example:

```ruby
# Compress an image with custom parameters.
input_source.compress!(quality: 85, max_width: 1024, max_height: 768)
```
> ⚠️ Warning: Compression alters the original image data.
> We strongly advise you inspect a compressed file before sending it:
> ```ruby
> # Compress using a quality of 50%:
> input_source.compress!(quality: 50)
> input_source.write_to_file('path/to/my/compressed/file_50.jpg')
> ```

For reference, here's what the following levels of compression on this image will look like:

Original:
![Invoice sample](https://github.com/mindee/client-lib-test-data/blob/main/products/invoices/default_sample.jpg?raw=true)


85% compressed:
![85% sample](https://github.com/mindee/client-lib-test-data/blob/main/file_operations/compression/compressed_ruby_85.jpg?raw=true)

50% compressed:
![50% sample](https://github.com/mindee/client-lib-test-data/blob/main/file_operations/compression/compressed_ruby_50.jpg?raw=true)

10% compressed:
![10% sample](https://github.com/mindee/client-lib-test-data/blob/main/file_operations/compression/compressed_ruby_10.jpg?raw=true)


### PDF operations

PDF operations include both compression and fixing features.
These are specifically designed to handle challenges associated with PDF files, such as large file sizes and formatting issues.

#### PDF compression

> 🧪 PDF compression is an **experimental** feature that rasterizes each page of the PDF (similar to how images are compressed) to reduce its overall size.
> Because the process involves re-rendering the PDF’s contents, some source text may be lost or rendered differently.
> Use this feature with caution.


```ruby
# Load a local input source.
input_file_path = "path/to/your/file.pdf"
output_file_path = "path/to/the/compressed/file.pdf"
pdf_input = Mindee::Input::Source::PathInputSource.new(input_file_path)

# We advise you test the quality value yourself, as results may vary greatly depending on the input file
pdf_input.compress!(quality: 50)

# Write the output file locally for visual checking:
File.write(output_file_path, pdf_input.io_stream.read)
```

> 🚧 Be warned that the source text (the text embedded in the PDF itself) might not render properly,
> and so source PDFs will be ignored by default.
> You can bypass this using:

```ruby
pdf_input.compress!(quality: 50, force_source_text: true)
```

Or alternatively, you can try to approximate the re-rendering of the source-text using:

```ruby
pdf_input.compress!(quality: 50, force_source_text: true, disable_source_text: false)
```

#### PDF fixing

The PDF fixing feature helps to rescue PDFs with invalid or broken header information.
This can sometimes help when files get rejected by the server.

Example:
```ruby
# Load a PDF file with the fix_pdf flag enabled.
input_source = mindee_client.source_from_file(file, "document.pdf", fix_pdf: true)
```

> ⚠️ Warning: PDF fixing alters the input file by re-writing header information.
> Use this feature only when required, as it might affect the integrity of the document file.

---

Feel free to expand these examples and adjust the parameters as needed for your projects. For further details on authentication and usage, you can refer to the [Getting Started Guide](getting_started.md).
