---
title: Ruby Client Library - Passport
category: 622b805aaec68102ea7fcbc2
slug: ruby-passport-ocr
parentDoc: 67b49df15b843f3fa9cd622b
---
The Ruby Client Library supports the [Passport API](https://platform.mindee.com/mindee/passport).


> 📝 Product Specs
>
> | Specification                  | Details                                            |
> | ------------------------------ | -------------------------------------------------- |
> | Endpoint Name                  | `passport`                                         |
> | Recommended Version            | `v1.1`                                             |
> | Supports Polling/Webhooks      | ❌ No                                              |
> | Support Synchronous HTTP Calls | ✔️ Yes                                             |
> | Geography                      | 🌐 Global                                          |


Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/passport/default_sample.jpg),
we are going to illustrate how to extract the data that we want using the Ruby Client Library.
![Passport sample](https://github.com/mindee/client-lib-test-data/blob/main/products/passport/default_sample.jpg?raw=true)

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
  Mindee::Product::Passport::PassportV1
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
:Mindee ID: 18e41f6c-16cd-4f8e-8cd2-00ca02a35764
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/passport v1.0
:Rotation applied: Yes

Prediction
==========
:Country Code: GBR
:ID Number: 707797979
:Given Name(s): HENERT
:Surname: PUDARSAN
:Date of Birth: 1995-05-20
:Place of Birth: CAMTETH
:Gender: M
:Date of Issue: 2012-04-22
:Expiry Date: 2017-04-22
:MRZ Line 1: P<GBRPUDARSAN<<HENERT<<<<<<<<<<<<<<<<<<<<<<<
:MRZ Line 2: 7077979792GBR9505209M1704224<<<<<<<<<<<<<<00

Page Predictions
================

Page 0
------
:Country Code: GBR
:ID Number: 707797979
:Given Name(s): HENERT
:Surname: PUDARSAN
:Date of Birth: 1995-05-20
:Place of Birth: CAMTETH
:Gender: M
:Date of Issue: 2012-04-22
:Expiry Date: 2017-04-22
:MRZ Line 1: P<GBRPUDARSAN<<HENERT<<<<<<<<<<<<<<<<<<<<<<<
:MRZ Line 2: 7077979792GBR9505209M1704224<<<<<<<<<<<<<<00
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
The following fields are extracted for Passport V1:

## Date of Birth
**birth_date** ([DateField](#date-field)): The date of birth of the passport holder.

```rb
puts result.document.inference.prediction.birth_date.value
```

## Place of Birth
**birth_place** ([StringField](#string-field)): The place of birth of the passport holder.

```rb
puts result.document.inference.prediction.birth_place.value
```

## Country Code
**country** ([StringField](#string-field)): The country's 3 letter code (ISO 3166-1 alpha-3).

```rb
puts result.document.inference.prediction.country.value
```

## Expiry Date
**expiry_date** ([DateField](#date-field)): The expiry date of the passport.

```rb
puts result.document.inference.prediction.expiry_date.value
```

## Gender
**gender** ([StringField](#string-field)): The gender of the passport holder.

```rb
puts result.document.inference.prediction.gender.value
```

## Given Name(s)
**given_names** (Array<[StringField](#string-field)>): The given name(s) of the passport holder.

```rb
result.document.inference.prediction.given_names do |given_names_elem|
  puts given_names_elem.value
end
```

## ID Number
**id_number** ([StringField](#string-field)): The passport's identification number.

```rb
puts result.document.inference.prediction.id_number.value
```

## Date of Issue
**issuance_date** ([DateField](#date-field)): The date the passport was issued.

```rb
puts result.document.inference.prediction.issuance_date.value
```

## MRZ Line 1
**mrz1** ([StringField](#string-field)): Machine Readable Zone, first line

```rb
puts result.document.inference.prediction.mrz1.value
```

## MRZ Line 2
**mrz2** ([StringField](#string-field)): Machine Readable Zone, second line

```rb
puts result.document.inference.prediction.mrz2.value
```

## Surname
**surname** ([StringField](#string-field)): The surname of the passport holder.

```rb
puts result.document.inference.prediction.surname.value
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
