---
title: Barcode Reader OCR Ruby
---
The Ruby OCR SDK supports the [Barcode Reader API](https://platform.mindee.com/mindee/barcode_reader).

Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/barcode_reader/default_sample.jpg), we are going to illustrate how to extract the data that we want using the OCR SDK.
![Barcode Reader sample](https://github.com/mindee/client-lib-test-data/blob/main/products/barcode_reader/default_sample.jpg?raw=true)

# Quick-Start
```rb
require 'mindee'

# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')

# Parse the file
result = mindee_client.parse(
  input_source,
  Mindee::Product::BarcodeReader::BarcodeReaderV1
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
:Mindee ID: f9c48da1-a306-4805-8da8-f7231fda2d88
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/barcode_reader v1.0
:Rotation applied: Yes

Prediction
==========
:Barcodes 1D: Mindee
:Barcodes 2D: https://developers.mindee.com/docs/barcode-reader-ocr
              I love paperwork! - Said no one ever

Page Predictions
================

Page 0
------
:Barcodes 1D: Mindee
:Barcodes 2D: https://developers.mindee.com/docs/barcode-reader-ocr
              I love paperwork! - Said no one ever
```

# Field Types
## Standard Fields
These fields are generic and used in several products.

### Basic Field
Each prediction object contains a set of fields that inherit from the generic `Field` class.
A typical `Field` object will have the following attributes:

* **value** (`String`, `Float`, `Integer`, `Boolean`): corresponds to the field value. Can be `nil` if no value was extracted.
* **confidence** (Float, nil): the confidence score of the field prediction.
* **bounding_box** (`Mindee::Geometry::Quadrilateral`, `nil`): contains exactly 4 relative vertices (points) coordinates of a right rectangle containing the field in the document.
* **polygon** (`Mindee::Geometry::Polygon`, `nil`): contains the relative vertices coordinates (`Point`) of a polygon containing the field in the image.
* **page_id** (`Integer`, `nil`): the ID of the page, is `nil` when at document-level.
* **reconstructed** (`Boolean`): indicates whether an object was reconstructed (not extracted as the API gave it).


Aside from the previous attributes, all basic fields have access to a `to_s` method that can be used to print their value as a string.

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

# Attributes
The following fields are extracted for Barcode Reader V1:

## Barcodes 1D
**codes_1d** (Array<[StringField](#string-field)>): List of decoded 1D barcodes.

```rb
for codes_1d_elem in result.document.inference.prediction.codes_1d do
  puts codes_1d_elem.value
end
```

## Barcodes 2D
**codes_2d** (Array<[StringField](#string-field)>): List of decoded 2D barcodes.

```rb
for codes_2d_elem in result.document.inference.prediction.codes_2d do
  puts codes_2d_elem.value
end
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)
