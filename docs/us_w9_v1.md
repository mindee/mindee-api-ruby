---
title: US W9 OCR Ruby
category: 622b805aaec68102ea7fcbc2
slug: ruby-us-w9-ocr
parentDoc: 6294d97ee723f1008d2ab28e
---
The Ruby OCR SDK supports the [W9 API](https://platform.mindee.com/mindee/us_w9).

Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/us_w9/default_sample.jpg), we are going to illustrate how to extract the data that we want using the OCR SDK.
![W9 sample](https://github.com/mindee/client-lib-test-data/blob/main/products/us_w9/default_sample.jpg?raw=true)

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
  Mindee::Product::US::W9::W9V1
)

# Print a full summary of the parsed data in RST format
puts result.document
```

**Output (RST):**
```rst
########
Document
########
:Mindee ID: d7c5b25f-e0d3-4491-af54-6183afa1aaab
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/us_w9 v1.0
:Rotation applied: Yes

Prediction
==========

Page Predictions
================

Page 0
------
:Name: Stephen W Hawking
:SSN: 560758145
:Address: Somewhere In Milky Way
:City State Zip: Probably Still At Cambridge P O Box CB1
:Business Name:
:EIN: 942203664
:Tax Classification: individual
:Tax Classification Other Details:
:W9 Revision Date: august 2013
:Signature Position: Polygon with 4 points.
:Signature Date Position:
:Tax Classification LLC:
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
* **page_id** (`Integer`, `nil`): the ID of the page, always `nil` when at document-level.
* **reconstructed** (`Boolean`): indicates whether an object was reconstructed (not extracted as the API gave it).


Aside from the previous attributes, all basic fields have access to a `to_s` method that can be used to print their value as a string.


### Position Field
The position field `PositionField` does not implement all the basic `Field` attributes, only **bounding_box**, **polygon** and **page_id**. On top of these, it has access to:

* **rectangle** (`Mindee::Geometry::Quadrilateral`): a Polygon with four points that may be oriented (even beyond canvas).
* **quadrangle** (`Mindee::Geometry::Quadrilateral`): a free polygon made up of four points.

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

## Page-Level Fields
Some fields are constrained to the page level, and so will not be retrievable at document level.

# Attributes
The following fields are extracted for W9 V1:

## Address
[📄](#page-level-fields "This field is only present on individual pages.")**address** ([StringField](#string-field)): The street address (number, street, and apt. or suite no.) of the applicant.

```rb
for address_elem in result.document.address do
  puts address_elem.value
end
```

## Business Name
[📄](#page-level-fields "This field is only present on individual pages.")**business_name** ([StringField](#string-field)): The business name or disregarded entity name, if different from Name.

```rb
for business_name_elem in result.document.business_name do
  puts business_name_elem.value
end
```

## City State Zip
[📄](#page-level-fields "This field is only present on individual pages.")**city_state_zip** ([StringField](#string-field)): The city, state, and ZIP code of the applicant.

```rb
for city_state_zip_elem in result.document.city_state_zip do
  puts city_state_zip_elem.value
end
```

## EIN
[📄](#page-level-fields "This field is only present on individual pages.")**ein** ([StringField](#string-field)): The employer identification number.

```rb
for ein_elem in result.document.ein do
  puts ein_elem.value
end
```

## Name
[📄](#page-level-fields "This field is only present on individual pages.")**name** ([StringField](#string-field)): Name as shown on the applicant's income tax return.

```rb
for name_elem in result.document.name do
  puts name_elem.value
end
```

## Signature Date Position
[📄](#page-level-fields "This field is only present on individual pages.")**signature_date_position** ([PositionField](#position-field)): Position of the signature date on the document.

```rb
for signature_date_position_elem in result.document.signature_date_position do
  puts signature_date_position_elem.polygon
end
```

## Signature Position
[📄](#page-level-fields "This field is only present on individual pages.")**signature_position** ([PositionField](#position-field)): Position of the signature on the document.

```rb
for signature_position_elem in result.document.signature_position do
  puts signature_position_elem.polygon
end
```

## SSN
[📄](#page-level-fields "This field is only present on individual pages.")**ssn** ([StringField](#string-field)): The applicant's social security number.

```rb
for ssn_elem in result.document.ssn do
  puts ssn_elem.value
end
```

## Tax Classification
[📄](#page-level-fields "This field is only present on individual pages.")**tax_classification** ([StringField](#string-field)): The federal tax classification, which can vary depending on the revision date.

```rb
for tax_classification_elem in result.document.tax_classification do
  puts tax_classification_elem.value
end
```

## Tax Classification LLC
[📄](#page-level-fields "This field is only present on individual pages.")**tax_classification_llc** ([StringField](#string-field)): Depending on revision year, among S, C, P or D for Limited Liability Company Classification.

```rb
for tax_classification_llc_elem in result.document.tax_classification_llc do
  puts tax_classification_llc_elem.value
end
```

## Tax Classification Other Details
[📄](#page-level-fields "This field is only present on individual pages.")**tax_classification_other_details** ([StringField](#string-field)): Tax Classification Other Details.

```rb
for tax_classification_other_details_elem in result.document.tax_classification_other_details do
  puts tax_classification_other_details_elem.value
end
```

## W9 Revision Date
[📄](#page-level-fields "This field is only present on individual pages.")**w9_revision_date** ([StringField](#string-field)): The Revision month and year of the W9 form.

```rb
for w9_revision_date_elem in result.document.w9_revision_date do
  puts w9_revision_date_elem.value
end
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
