---
title: EU Driver License OCR Ruby
---
The Ruby OCR SDK supports the [Driver License API](https://platform.mindee.com/mindee/eu_driver_license).

Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/eu_driver_license/default_sample.jpg), we are going to illustrate how to extract the data that we want using the OCR SDK.
![Driver License sample](https://github.com/mindee/client-lib-test-data/blob/main/products/eu_driver_license/default_sample.jpg?raw=true)

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
  Mindee::Product::EU::DriverLicense::DriverLicenseV1
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
:Mindee ID: b19cc32e-b3e6-4ff9-bdc7-619199355d54
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/eu_driver_license v1.0
:Rotation applied: Yes

Prediction
==========
:Country Code: FR
:Document ID: 13AA00002
:Driver License Category: AM A1 B1 B D BE DE
:Last Name: MARTIN
:First Name: PAUL
:Date Of Birth: 1981-07-14
:Place Of Birth: Utopiacity
:Expiry Date: 2018-12-31
:Issue Date: 2013-01-01
:Issue Authority: 99999UpiaCity
:MRZ: D1FRA13AA000026181231MARTIN<<9
:Address:

Page Predictions
================

Page 0
------
:Photo: Polygon with 4 points.
:Signature: Polygon with 4 points.
:Country Code: FR
:Document ID: 13AA00002
:Driver License Category: AM A1 B1 B D BE DE
:Last Name: MARTIN
:First Name: PAUL
:Date Of Birth: 1981-07-14
:Place Of Birth: Utopiacity
:Expiry Date: 2018-12-31
:Issue Date: 2013-01-01
:Issue Authority: 99999UpiaCity
:MRZ: D1FRA13AA000026181231MARTIN<<9
:Address:
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

### Date Field
Aside from the basic `Field` attributes, the date field `DateField` also implements the following: 

* **date_object** (`Date`): an accessible representation of the value as a JavaScript object.


### Position Field
The position field `PositionField` does not implement all the basic `Field` attributes, only **bounding_box**, **polygon** and **page_id**. On top of these, it has access to:

* **rectangle** (`Mindee::Geometry::Quadrilateral`): a Polygon with four points that may be oriented (even beyond canvas).
* **quadrangle** (`Mindee::Geometry::Quadrilateral`): a free polygon made up of four points.

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

## Page-Level Fields
Some fields are constrained to the page level, and so will not be retrievable to through the document.

# Attributes
The following fields are extracted for Driver License V1:

## Address
**address** ([StringField](#string-field)): EU driver license holders address

```rb
puts result.document.inference.prediction.address.value
```

## Driver License Category
**category** ([StringField](#string-field)): EU driver license holders categories

```rb
puts result.document.inference.prediction.category.value
```

## Country Code
**country_code** ([StringField](#string-field)): Country code extracted as a string.

```rb
puts result.document.inference.prediction.country_code.value
```

## Date Of Birth
**date_of_birth** ([DateField](#date-field)): The date of birth of the document holder

```rb
puts result.document.inference.prediction.date_of_birth.value
```

## Document ID
**document_id** ([StringField](#string-field)): ID number of the Document.

```rb
puts result.document.inference.prediction.document_id.value
```

## Expiry Date
**expiry_date** ([DateField](#date-field)): Date the document expires

```rb
puts result.document.inference.prediction.expiry_date.value
```

## First Name
**first_name** ([StringField](#string-field)): First name(s) of the driver license holder

```rb
puts result.document.inference.prediction.first_name.value
```

## Issue Authority
**issue_authority** ([StringField](#string-field)): Authority that issued the document

```rb
puts result.document.inference.prediction.issue_authority.value
```

## Issue Date
**issue_date** ([DateField](#date-field)): Date the document was issued

```rb
puts result.document.inference.prediction.issue_date.value
```

## Last Name
**last_name** ([StringField](#string-field)): Last name of the driver license holder.

```rb
puts result.document.inference.prediction.last_name.value
```

## MRZ
**mrz** ([StringField](#string-field)): Machine-readable license number

```rb
puts result.document.inference.prediction.mrz.value
```

## Photo
[📄](#page-level-fields "This field is only present on individual pages.")**photo** ([PositionField](#position-field)): Has a photo of the EU driver license holder

```rb
for photo_elem in result.document.photo do
  puts photo_elem.polygon
end
```

## Place Of Birth
**place_of_birth** ([StringField](#string-field)): Place where the driver license holder was born

```rb
puts result.document.inference.prediction.place_of_birth.value
```

## Signature
[📄](#page-level-fields "This field is only present on individual pages.")**signature** ([PositionField](#position-field)): Has a signature of the EU driver license holder

```rb
for signature_elem in result.document.signature do
  puts signature_elem.polygon
end
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)
