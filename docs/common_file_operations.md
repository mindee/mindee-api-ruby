---
title: Ruby Common File Operations
category: 622b805aaec68102ea7fcbc2
slug: ruby-common-file-compression
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
result = mindee_client.execute_workflow(
  input_source,
  "workflow_id",
  options: {
    document_alias: "my_document",
    priority: :high,
    page_options: {
            page_indexes:[0, 1], 
            operation: :REMOVE
    }
  }
)
```

## Image operations

Image operations mainly include the compression functionality for image files (JPEG, PNG, etc.) via the `compress!` method available on a LocalInputSource.
This method allows you to reduce file size by specifying quality and dimension constraints.

> 

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


## PDF operations

PDF operations include both compression and fixing features. These are specifically designed to handle challenges associated with PDF files, such as large file sizes and formatting issues.

### PDF compression

PDF compression is an experimental feature that essentially rasterizes each page of the PDF (similar to how images are compressed) to reduce its overall size. Because the process involves re-rendering the PDF’s contents, some source text may be lost or rendered differently. Use this feature with caution.

Example:

    pdf_input = mindee_client.source_from_path("/path/to/document.pdf")
    
    # Compress the PDF file (experimental feature).
    pdf_input.compress!(quality: 50)
    
    # Optionally, force the compression of source text (if necessary):
    # pdf_input.compress!(quality: 50, force_source_text: true, disable_source_text: false)
    > ⚠️ Warning: This experimental feature modifies the PDF file data. There is a risk that the re-rendered file might not accurately represent the original document, especially with regards to embedded text.

### PDF fixing

The PDF fixing feature helps to rescue PDFs with invalid or broken header information. This is particularly useful when third-party applications have injected invalid headers, leading to rejection by the server. The feature cleans up such issues so that the PDF can be processed correctly.

Example:

    # Load a PDF file with the fix_pdf flag enabled.
    input_source = mindee_client.source_from_file(file, "document.pdf", fix_pdf: true)
    > ⚠️ Warning: PDF fixing alters the input file by re-writing header information. Use this feature only when required, as it might affect the integrity of the original file.

---

Feel free to expand these examples and adjust the parameters as needed for your projects. For further details on authentication and usage, you can refer to the [Getting Started Guide](getting_started.md).
