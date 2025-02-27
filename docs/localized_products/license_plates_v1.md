---
title: EU License Plate
category: 622b805aaec68102ea7fcbc2
slug: ruby-eu-license-plate-ocr
parentDoc: 67b49e29a2cd6f08d69a40d8
---
The Ruby Client Library supports the [License Plate API](https://platform.mindee.com/mindee/license_plates).


> 📝 Product Specs
>
> | Specification                  | Details                                            |
> | ------------------------------ | -------------------------------------------------- |
> | Endpoint Name                  | `license_plates`                                   |
> | Recommended Version            | `v1.1`                                             |
> | Supports Polling/Webhooks      | ❌ No                                              |
> | Support Synchronous HTTP Calls | ✔️ Yes                                             |
> | Geography                      | 🇪🇺 Europe                                          |


Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/license_plates/default_sample.jpg),
we are going to illustrate how to extract the data that we want using the Ruby Client Library.
![License Plate sample](https://github.com/mindee/client-lib-test-data/blob/main/products/license_plates/default_sample.jpg?raw=true)

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
  Mindee::Product::EU::LicensePlate::LicensePlateV1
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
:Mindee ID: f0f48232-2c80-4473-9c6f-88a09111b84d
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/license_plates v1.0
:Rotation applied: No

Prediction
==========
:License Plates: BY-323-YB

Page Predictions
================

Page 0
------
:License Plates: BY-323-YB
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

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

# Attributes
The following fields are extracted for License Plate V1:

## License Plates
**license_plates** (Array<[StringField](#string-field)>): List of all license plates found in the image.

```rb
result.document.inference.prediction.license_plates do |license_plates_elem|
  puts license_plates_elem.value
end
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
