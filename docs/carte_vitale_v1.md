---
title: FR Carte Vitale OCR Ruby
---
The Ruby OCR SDK supports the [Carte Vitale API](https://platform.mindee.com/mindee/carte_vitale).

Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/carte_vitale/default_sample.jpg), we are going to illustrate how to extract the data that we want using the OCR SDK.
![Carte Vitale sample](https://github.com/mindee/client-lib-test-data/blob/main/products/carte_vitale/default_sample.jpg?raw=true)

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
  Mindee::Product::FR::CarteVitale::CarteVitaleV1
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
:Mindee ID: 8c25cc63-212b-4537-9c9b-3fbd3bd0ee20
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/carte_vitale v1.0
:Rotation applied: Yes

Prediction
==========
:Given Name(s): NATHALIE
:Surname: DURAND
:Social Security Number: 269054958815780
:Issuance Date: 2007-01-01

Page Predictions
================

Page 0
------
:Given Name(s): NATHALIE
:Surname: DURAND
:Social Security Number: 269054958815780
:Issuance Date: 2007-01-01
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

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

# Attributes
The following fields are extracted for Carte Vitale V1:

## Given Name(s)
**given_names** (Array<[StringField](#string-field)>): The given name(s) of the card holder.

```rb
for given_names_elem in result.document.inference.prediction.given_names do
  puts given_names_elem.value
end
```

## Issuance Date
**issuance_date** ([DateField](#date-field)): The date the card was issued.

```rb
puts result.document.inference.prediction.issuance_date.value
```

## Social Security Number
**social_security** ([StringField](#string-field)): The Social Security Number (Numéro de Sécurité Sociale) of the card holder

```rb
puts result.document.inference.prediction.social_security.value
```

## Surname
**surname** ([StringField](#string-field)): The surname of the card holder.

```rb
puts result.document.inference.prediction.surname.value
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
