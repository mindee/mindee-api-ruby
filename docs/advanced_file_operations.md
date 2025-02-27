---
title: Advanced File Operations
category: 622b805aaec68102ea7fcbc2
slug: ruby-advanced-file-operations
parentDoc: 6294d97ee723f1008d2ab28e
---

> ❗️ Disclaimer: the file operations listed below do not directly manipulate the files you will pass to the library,
they will instead create a copy before applying any operations, which means that the file you send may not be an
exact copy of the file the server will receive.
> To avoid any unexpected or unwanted result, you can save a copy of the created file locally to inspect it visually
before sending it.

## Image compression

The compression functionality for image files (JPEG, PNG, etc.) via the `compress!` method available on a
LocalInputSource. This method allows you to reduce file size by specifying quality and dimension constraints.

Example:

```rb
# Compress an image with custom parameters.
input_source.compress!(quality: 85, max_width: 1024, max_height: 768)
```
> ⚠️ Warning: Compression alters the original image data.
> We strongly advise you inspect a compressed file before sending it:
> ```rb
> # Compress using a quality of 50%:
> input_source.compress!(quality: 50)
> input_source.write_to_file('path/to/my/compressed/file_50.jpg')
> ```

For reference, here's what the following levels of compression on this image will look like:

**Original:**
![Invoice sample](https://github.com/mindee/client-lib-test-data/blob/main/products/invoices/default_sample.jpg?raw=true)

**85% compressed:**
![85% sample](https://github.com/mindee/client-lib-test-data/blob/main/file_operations/compression/compressed_ruby_85.jpg?raw=true)

**50% compressed:**
![50% sample](https://github.com/mindee/client-lib-test-data/blob/main/file_operations/compression/compressed_ruby_50.jpg?raw=true)

**10% compressed:**
![10% sample](https://github.com/mindee/client-lib-test-data/blob/main/file_operations/compression/compressed_ruby_10.jpg?raw=true)


## PDF operations

PDF operations include both compression and fixing features.
These are specifically designed to handle challenges associated with PDF files, such as large file sizes and formatting
issues.

### PDF compression

> 🧪 PDF compression is an **experimental** feature that rasterizes each page of the PDF (similar to how images are
> compressed) to reduce its overall size.
> 
> Because the process involves re-rendering the PDF’s contents, some source text may be lost or rendered differently.
> Use this feature with caution.


```rb
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
> 
> You can bypass this using:

```rb
pdf_input.compress!(quality: 50, force_source_text: true)
```

Or alternatively, you can try to approximate the re-rendering of the source-text using:

```rb
pdf_input.compress!(quality: 50, force_source_text: true, disable_source_text: false)
```

### PDF Repair

The PDF repair feature attempts to rescue PDFs with invalid or broken header information.
This can sometimes help when files get rejected by the server.

Example:
```rb
# Load a PDF file with the repair_pdf flag enabled.
input_source = mindee_client.source_from_file(file, "document.pdf", repair_pdf: true)
```

> ⚠️ Warning: PDF fixing alters the input file by re-writing header information.
> Use this feature only when required, as it might affect the integrity of the document file.

---

Feel free to expand these examples and adjust the parameters as needed for your projects. For further details on
authentication and usage, you can refer to the [Getting Started Guide](getting_started.md).

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
