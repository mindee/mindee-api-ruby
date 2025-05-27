---
title: Invoice Splitter
category: 622b805aaec68102ea7fcbc2
slug: ruby-invoice-splitter-ocr
parentDoc: 67b49df15b843f3fa9cd622b
---
The Ruby Client Library supports the [Invoice Splitter API](https://platform.mindee.com/mindee/invoice_splitter).


> 📝 Product Specs
>
> | Specification                  | Details                                            |
> | ------------------------------ | -------------------------------------------------- |
> | Endpoint Name                  | `invoice_splitter`                                 |
> | Recommended Version            | `v1.4`                                             |
> | Supports Polling/Webhooks      | ✔️ Yes                                             |
> | Support Synchronous HTTP Calls | ❌ No                                              |
> | Geography                      | 🌐 Global                                          |

> 🔐 Polling Limitations
>
> | Setting                         | Parameter name          | Default Value |
> | ------------------------------- | ----------------------- | ------------- |
> | Initial Delay Before Polling    | `initial_delay_seconds` | 2 seconds     |
> | Default Delay Between Calls     | `delay_sec`             | 1.5 seconds   |
> | Polling Attempts Before Timeout | `max_retries`           | 80 retries    |


Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/invoice_splitter/default_sample.pdf),
we are going to illustrate how to extract the data that we want using the Ruby Client Library.
![Invoice Splitter sample](https://github.com/mindee/client-lib-test-data/blob/main/products/invoice_splitter/default_sample.pdf?raw=true)

# Quick-Start
```rb
#
# Install the Ruby client library by running:
# gem install mindee
#

require 'mindee'

# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')

# Parse the file
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
:Product: mindee/invoice_splitter v1.2
:Rotation applied: No

Prediction
==========
:Invoice Page Groups:
  +--------------------------------------------------------------------------+
  | Page Indexes                                                             |
  +==========================================================================+
  | 0                                                                        |
  +--------------------------------------------------------------------------+
  | 1                                                                        |
  +--------------------------------------------------------------------------+
```

# Field Types
## Standard Fields
These fields are generic and used in several products.

### Basic Field
Each prediction object contains a set of fields that inherit from the generic `Field` class.
A typical `Field` object will have the following attributes:

* **value** (`String`, `Float`, `Integer`, `bool`): corresponds to the field value. Can be `nil` if no value was extracted.
* **confidence** (Float, nil): the confidence score of the field prediction.
* **bounding_box** (`Mindee::Geometry::Quadrilateral`, `nil`): contains exactly 4 relative vertices (points) coordinates of a right rectangle containing the field in the document.
* **polygon** (`Mindee::Geometry::Polygon`, `nil`): contains the relative vertices coordinates (`Point`) of a polygon containing the field in the image.
* **page_id** (`Integer`, `nil`): the ID of the page, always `nil` when at document-level.
* **reconstructed** (`bool`): indicates whether an object was reconstructed (not extracted as the API gave it).


Aside from the previous attributes, all basic fields have access to a `to_s` method that can be used to print their value as a string.

## Specific Fields
Fields which are specific to this product; they are not used in any other product.

### Invoice Page Groups Field
List of page groups. Each group represents a single invoice within a multi-invoice document.

A `InvoiceSplitterV1InvoicePageGroup` implements the following attributes:

* `page_indexes` (Array<Integer>): List of page indexes that belong to the same invoice (group).

# Attributes
The following fields are extracted for Invoice Splitter V1:

## Invoice Page Groups
**invoice_page_groups** (Array<[InvoiceSplitterV1InvoicePageGroup](#invoice-page-groups-field)>): List of page groups. Each group represents a single invoice within a multi-invoice document.

```rb
result.document.inference.prediction.invoice_page_groups do |invoice_page_groups_elem|
  puts invoice_page_groups_elem.value
end
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
