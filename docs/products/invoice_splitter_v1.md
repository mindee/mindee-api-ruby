---
title: Invoice Splitter API Ruby
category: 622b805aaec68102ea7fcbc2
slug: ruby-invoice-splitter-ocr
parentDoc: 6294d97ee723f1008d2ab28e
---
The Ruby OCR SDK supports the [Invoice Splitter API](https://platform.mindee.com/mindee/invoice_splitter).

Using [this sample](https://github.com/mindee/client-lib-test-data/blob/main/products/invoice_splitter/default_sample.pdf), we are going to illustrate how to detect the pages of multiple invoices within the same document.

# Quick-Start

```rb
require 'mindee'

# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')

result = mindee_client.parse(
  input_source,
  Mindee::Product::InvoiceSplitter::InvoiceSplitterV1
)

# Print a full summary of the parsed data in RST format
puts result.document

# Print the document-level parsed data
# puts result.document.inference.prediction
```

**Output (RST):**
```rst
########
Document
########
:Mindee ID: 15ad7a19-7b75-43d0-b0c6-9a641a12b49b
:Filename: default_sample.pdf

Inference
#########
:Product: mindee/invoice_splitter v1.1
:Rotation applied: No

Prediction
==========
:Invoice Page Groups:
  :Page indexes: 0
  :Page indexes: 1

Page Predictions
================

Page 0
------
:Invoice Page Groups:

Page 1
------
:Invoice Page Groups:
```

# Field Types
## Specific Fields
### Invoice Splitter V1 Page Group
List of page group indexes.

An `InvoiceSplitterV1PageGroup` implements the following attributes:

* **page_indexes** (Array<`Integer`>): List of indexes of the pages of a single invoice.
* **confidence** (`Float`): The confidence of the prediction.

# Attributes
The following fields are extracted for Invoice Splitter V1:

## Invoice Page Groups
**invoice_page_groups** (Array<[InvoiceSplitterV1PageGroup](#invoice-splitter-v1-page-group)>): List of page indexes that belong to the same invoice in the PDF.

```rb
for invoice_page_groups_elem in result.document.inference.prediction.invoice_page_groups do 
  puts invoice_page_groups_elem.page_indexes.join(', ')
end
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
