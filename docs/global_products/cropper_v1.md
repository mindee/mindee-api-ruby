---
title: Ruby Client Library - Cropper
category: 622b805aaec68102ea7fcbc2
slug: ruby-cropper-ocr
parentDoc: 67b49df15b843f3fa9cd622b
---
The Ruby Client Library supports the [Cropper API](https://platform.mindee.com/mindee/cropper).


> 📝 Product Specs
>
> | Specification                  | Details                                            |
> | ------------------------------ | -------------------------------------------------- |
> | Endpoint                       | `cropper`                                          |
> | Recommended Version            | `v1.1`                                             |
> | Supports Polling/Webhooks      | ❌ No                                              |
> | Support Synchronous HTTP Calls | ✔️ Yes                                             |
> | Geography                      | 🌐 Global                                          |


Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/cropper/default_sample.jpg), we are going to illustrate how to extract the data that we want using the
Ruby Client Library.
![Cropper sample](https://github.com/mindee/client-lib-test-data/blob/main/products/cropper/default_sample.jpg?raw=true)

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
  Mindee::Product::Cropper::CropperV1
)

# Print a full summary of the parsed data in RST format
puts result.document
```

**Output (RST):**
```rst
########
Document
########
:Mindee ID: 149ce775-8302-4798-8649-7eda9fb84a1a
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/cropper v1.0
:Rotation applied: No

Prediction
==========

Page Predictions
================

Page 0
------
:Document Cropper: Polygon with 26 points.
                   Polygon with 25 points.
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


### Position Field
The position field `PositionField` does not implement all the basic `Field` attributes, only **bounding_box**,
**polygon** and **page_id**. On top of these, it has access to:

* **rectangle** (`Mindee::Geometry::Quadrilateral`): a Polygon with four points that may be oriented (even beyond
canvas).
* **quadrangle** (`Mindee::Geometry::Quadrilateral`): a free polygon made up of four points.

## Page-Level Fields
Some fields are constrained to the page level, and so will not be retrievable at document level.

# Attributes
The following fields are extracted for Cropper V1:

## Document Cropper
[📄](#page-level-fields "This field is only present on individual pages.")**cropping** (Array<[PositionField](#position-field)>): List of documents found in the image.

```rb
  result.document.inference.pages do |page|
    page.prediction.cropping do |cropping_elem|
      puts cropping_elem.polygon.to_s
    puts cropping_elem.quadrangle.to_s
    puts cropping_elem.rectangle.to_s
    puts cropping_elem.boundingBox.to_s
    end
  end
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
