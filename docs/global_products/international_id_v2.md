---
title: International ID
category: 622b805aaec68102ea7fcbc2
slug: ruby-international-id-ocr
parentDoc: 67b49df15b843f3fa9cd622b
---
The Ruby Client Library supports the [International ID API](https://platform.mindee.com/mindee/international_id).


> 📝 Product Specs
>
> | Specification                  | Details                                            |
> | ------------------------------ | -------------------------------------------------- |
> | Endpoint Name                  | `international_id`                                 |
> | Recommended Version            | `v2.1`                                             |
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


Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/international_id/default_sample.jpg),
we are going to illustrate how to extract the data that we want using the Ruby Client Library.
![International ID sample](https://github.com/mindee/client-lib-test-data/blob/main/products/international_id/default_sample.jpg?raw=true)

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
  Mindee::Product::InternationalId::InternationalIdV2
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
:Mindee ID: cfa20a58-20cf-43b6-8cec-9505fa69d1c2
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/international_id v2.0
:Rotation applied: No

Prediction
==========
:Document Type: IDENTIFICATION_CARD
:Document Number: 12345678A
:Surnames: MUESTRA
           MUESTRA
:Given Names: CARMEN
:Sex: F
:Birth Date: 1980-01-01
:Birth Place: CAMPO DE CRIPTANA CIUDAD REAL ESPANA
:Nationality: ESP
:Personal Number: BAB1834284<44282767Q0
:Country of Issue: ESP
:State of Issue: MADRID
:Issue Date:
:Expiration Date: 2030-01-01
:Address: C/REAL N13, 1 DCHA COLLADO VILLALBA MADRID MADRID MADRID
:MRZ Line 1: IDESPBAB1834284<44282767Q0<<<<
:MRZ Line 2: 8001010F1301017ESP<<<<<<<<<<<3
:MRZ Line 3: MUESTRA<MUESTRA<<CARMEN<<<<<<<
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


### Classification Field
The classification field `ClassificationField` does not implement all the basic `Field` attributes. It only implements
**value**, **confidence** and **page_id**.

> Note: a classification field's `value is always a `String`.

### Date Field
Aside from the basic `Field` attributes, the date field `DateField` also implements the following:

* **date_object** (`Date`): an accessible representation of the value as a JavaScript object.

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

# Attributes
The following fields are extracted for International ID V2:

## Address
**address** ([StringField](#string-field)): The physical address of the document holder.

```rb
puts result.document.inference.prediction.address.value
```

## Birth Date
**birth_date** ([DateField](#date-field)): The date of birth of the document holder.

```rb
puts result.document.inference.prediction.birth_date.value
```

## Birth Place
**birth_place** ([StringField](#string-field)): The place of birth of the document holder.

```rb
puts result.document.inference.prediction.birth_place.value
```

## Country of Issue
**country_of_issue** ([StringField](#string-field)): The country where the document was issued.

```rb
puts result.document.inference.prediction.country_of_issue.value
```

## Document Number
**document_number** ([StringField](#string-field)): The unique identifier assigned to the document.

```rb
puts result.document.inference.prediction.document_number.value
```

## Document Type
**document_type** ([ClassificationField](#classification-field)): The type of personal identification document.

#### Possible values include:
 - IDENTIFICATION_CARD
 - PASSPORT
 - DRIVER_LICENSE
 - VISA
 - RESIDENCY_CARD
 - VOTER_REGISTRATION

```rb
puts result.document.inference.prediction.document_type.value
```

## Expiration Date
**expiry_date** ([DateField](#date-field)): The date when the document becomes invalid.

```rb
puts result.document.inference.prediction.expiry_date.value
```

## Given Names
**given_names** (Array<[StringField](#string-field)>): The list of the document holder's given names.

```rb
result.document.inference.prediction.given_names do |given_names_elem|
  puts given_names_elem.value
end
```

## Issue Date
**issue_date** ([DateField](#date-field)): The date when the document was issued.

```rb
puts result.document.inference.prediction.issue_date.value
```

## MRZ Line 1
**mrz_line1** ([StringField](#string-field)): The Machine Readable Zone, first line.

```rb
puts result.document.inference.prediction.mrz_line1.value
```

## MRZ Line 2
**mrz_line2** ([StringField](#string-field)): The Machine Readable Zone, second line.

```rb
puts result.document.inference.prediction.mrz_line2.value
```

## MRZ Line 3
**mrz_line3** ([StringField](#string-field)): The Machine Readable Zone, third line.

```rb
puts result.document.inference.prediction.mrz_line3.value
```

## Nationality
**nationality** ([StringField](#string-field)): The country of citizenship of the document holder.

```rb
puts result.document.inference.prediction.nationality.value
```

## Personal Number
**personal_number** ([StringField](#string-field)): The unique identifier assigned to the document holder.

```rb
puts result.document.inference.prediction.personal_number.value
```

## Sex
**sex** ([StringField](#string-field)): The biological sex of the document holder.

```rb
puts result.document.inference.prediction.sex.value
```

## State of Issue
**state_of_issue** ([StringField](#string-field)): The state or territory where the document was issued.

```rb
puts result.document.inference.prediction.state_of_issue.value
```

## Surnames
**surnames** (Array<[StringField](#string-field)>): The list of the document holder's family names.

```rb
result.document.inference.prediction.surnames do |surnames_elem|
  puts surnames_elem.value
end
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
