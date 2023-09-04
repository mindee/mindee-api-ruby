---
title: FR Carte Nationale d'Identité OCR Ruby
---
The Ruby OCR SDK supports the [Carte Nationale d'Identité API](https://platform.mindee.com/mindee/idcard_fr).

Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/idcard_fr/default_sample.jpg), we are going to illustrate how to extract the data that we want using the OCR SDK.
![Carte Nationale d'Identité sample](https://github.com/mindee/client-lib-test-data/blob/main/products/idcard_fr/default_sample.jpg?raw=true)

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
  Mindee::Product::FR::IdCard::IdCardV1
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
:Mindee ID: ef79c45b-1300-474f-af28-de65519cabd7
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/idcard_fr v1.0
:Rotation applied: Yes

Prediction
==========
:Identity Number: 175775H55790
:Given Name(s): VICTOR
:Surname: DAMBARD
:Date of Birth: 1994-04-24
:Place of Birth: LYON 4E ARRONDISSEMT
:Expiry Date: 2030-04-02
:Issuing Authority: SOUS-PREFECTURE DE BELLE (02)
:Gender:
:MRZ Line 1: IDFRADAMBARD<<<<<<<<<<<<<<<<<<075025
:MRZ Line 2: 170775H557903VICTOR<<MARIE<9404246M5

Page Predictions
================

Page 0
------
:Document Side: RECTO & VERSO
:Identity Number: 175775H55790
:Given Name(s): VICTOR
:Surname: DAMBARD
:Date of Birth: 1994-04-24
:Place of Birth: LYON 4E ARRONDISSEMT
:Expiry Date: 2030-04-02
:Issuing Authority: SOUS-PREFECTURE DE BELLE (02)
:Gender:
:MRZ Line 1: IDFRADAMBARD<<<<<<<<<<<<<<<<<<075025
:MRZ Line 2: 170775H557903VICTOR<<MARIE<9404246M5
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
* **reconstructed** (`Boolean`): indicates whether or not an object was reconstructed (not extracted as the API gave it).


Aside from the previous attributes, all basic fields have access to a `to_s` method that can be used to print their value as a string.


### Classification Field
The classification field `ClassificationField` does not implement all the basic `Field` attributes. It only implements **value**, **confidence** and **page_id**.

> Note: a classification field's `value is always a `String`.

### Date Field
Aside from the basic `Field` attributes, the date field `DateField` also implements the following: 

* **date_object** (`Date`): an accessible representation of the value as a JavaScript object.

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

## Page-Level Fields
Some fields are constrained to the page level, and so will not be retrievable to through the document.

# Attributes
The following fields are extracted for Carte Nationale d'Identité V1:

## Issuing Authority
**authority** ([StringField](#string-field)): The name of the issuing authority.

```rb
puts result.document.inference.prediction.authority.value
```

## Date of Birth
**birth_date** ([DateField](#date-field)): The date of birth of the card holder.

```rb
puts result.document.inference.prediction.birth_date.value
```

## Place of Birth
**birth_place** ([StringField](#string-field)): The place of birth of the card holder.

```rb
puts result.document.inference.prediction.birth_place.value
```

## Document Side
[📄](#page-level-fields "This field is only present on individual pages.")**document_side** ([ClassificationField](#classification-field)): The side of the document which is visible.

```rb
for document_side_elem in result.document.document_side do
  puts document_side_elem.value
end
```

## Expiry Date
**expiry_date** ([DateField](#date-field)): The expiry date of the identification card.

```rb
puts result.document.inference.prediction.expiry_date.value
```

## Gender
**gender** ([StringField](#string-field)): The gender of the card holder.

```rb
puts result.document.inference.prediction.gender.value
```

## Given Name(s)
**given_names** (Array<[StringField](#string-field)>): The given name(s) of the card holder.

```rb
for given_names_elem in result.document.inference.prediction.given_names do
  puts given_names_elem.value
end
```

## Identity Number
**id_number** ([StringField](#string-field)): The identification card number.

```rb
puts result.document.inference.prediction.id_number.value
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
**surname** ([StringField](#string-field)): The surname of the card holder.

```rb
puts result.document.inference.prediction.surname.value
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)
