---
title: Driver License OCR Ruby
category: 622b805aaec68102ea7fcbc2
slug: ruby-driver-license-ocr
parentDoc: 67b49df15b843f3fa9cd622b
---
The Ruby OCR SDK supports the [Driver License API](https://platform.mindee.com/mindee/driver_license).

Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/driver_license/default_sample.jpg), we are going to illustrate how to extract the data that we want using the OCR SDK.
![Driver License sample](https://github.com/mindee/client-lib-test-data/blob/main/products/driver_license/default_sample.jpg?raw=true)

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
  Mindee::Product::DriverLicense::DriverLicenseV1
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
:Mindee ID: fbdeae38-ada3-43ac-aa58-e01a3d47e474
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/driver_license v1.0
:Rotation applied: Yes

Prediction
==========
:Country Code: USA
:State: AZ
:ID: D12345678
:Category: D
:Last Name: Sample
:First Name: Jelani
:Date of Birth: 1957-02-01
:Place of Birth:
:Expiry Date: 2018-02-01
:Issued Date: 2013-01-10
:Issuing Authority:
:MRZ:
:DD Number: DD1234567890123456
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

### Date Field
Aside from the basic `Field` attributes, the date field `DateField` also implements the following: 

* **date_object** (`Date`): an accessible representation of the value as a JavaScript object.

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

# Attributes
The following fields are extracted for Driver License V1:

## Category
**category** ([StringField](#string-field)): The category or class of the driver license.

```rb
puts result.document.inference.prediction.category.value
```

## Country Code
**country_code** ([StringField](#string-field)): The alpha-3 ISO 3166 code of the country where the driver license was issued.

```rb
puts result.document.inference.prediction.country_code.value
```

## Date of Birth
**date_of_birth** ([DateField](#date-field)): The date of birth of the driver license holder.

```rb
puts result.document.inference.prediction.date_of_birth.value
```

## DD Number
**dd_number** ([StringField](#string-field)): The DD number of the driver license.

```rb
puts result.document.inference.prediction.dd_number.value
```

## Expiry Date
**expiry_date** ([DateField](#date-field)): The expiry date of the driver license.

```rb
puts result.document.inference.prediction.expiry_date.value
```

## First Name
**first_name** ([StringField](#string-field)): The first name of the driver license holder.

```rb
puts result.document.inference.prediction.first_name.value
```

## ID
**id** ([StringField](#string-field)): The unique identifier of the driver license.

```rb
puts result.document.inference.prediction.id.value
```

## Issued Date
**issued_date** ([DateField](#date-field)): The date when the driver license was issued.

```rb
puts result.document.inference.prediction.issued_date.value
```

## Issuing Authority
**issuing_authority** ([StringField](#string-field)): The authority that issued the driver license.

```rb
puts result.document.inference.prediction.issuing_authority.value
```

## Last Name
**last_name** ([StringField](#string-field)): The last name of the driver license holder.

```rb
puts result.document.inference.prediction.last_name.value
```

## MRZ
**mrz** ([StringField](#string-field)): The Machine Readable Zone (MRZ) of the driver license.

```rb
puts result.document.inference.prediction.mrz.value
```

## Place of Birth
**place_of_birth** ([StringField](#string-field)): The place of birth of the driver license holder.

```rb
puts result.document.inference.prediction.place_of_birth.value
```

## State
**state** ([StringField](#string-field)): Second part of the ISO 3166-2 code, consisting of two letters indicating the US State.

```rb
puts result.document.inference.prediction.state.value
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
