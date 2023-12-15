---
title: US Bank Check OCR Ruby
---
The Ruby OCR SDK supports the [Bank Check API](https://platform.mindee.com/mindee/bank_check).

Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/bank_check/default_sample.jpg), we are going to illustrate how to extract the data that we want using the OCR SDK.
![Bank Check sample](https://github.com/mindee/client-lib-test-data/blob/main/products/bank_check/default_sample.jpg?raw=true)

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
  Mindee::Product::US::BankCheck::BankCheckV1
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
:Mindee ID: b9809586-57ae-4f84-a35d-a85b2be1f2a2
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/bank_check v1.0
:Rotation applied: Yes

Prediction
==========
:Check Issue Date: 2022-03-29
:Amount: 15332.90
:Payees: JOHN DOE
         JANE DOE
:Routing Number:
:Account Number: 7789778136
:Check Number: 0003401

Page Predictions
================

Page 0
------
:Check Position: Polygon with 21 points.
:Signature Positions: Polygon with 6 points.
:Check Issue Date: 2022-03-29
:Amount: 15332.90
:Payees: JOHN DOE
         JANE DOE
:Routing Number:
:Account Number: 7789778136
:Check Number: 0003401
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


### Amount Field
The amount field `AmountField` only has one constraint: its **value** is a `Float` (or `nil`).

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
The following fields are extracted for Bank Check V1:

## Account Number
**account_number** ([StringField](#string-field)): The check payer's account number.

```rb
puts result.document.inference.prediction.account_number.value
```

## Amount
**amount** ([AmountField](#amount-field)): The amount of the check.

```rb
puts result.document.inference.prediction.amount.value
```

## Check Number
**check_number** ([StringField](#string-field)): The issuer's check number.

```rb
puts result.document.inference.prediction.check_number.value
```

## Check Position
[📄](#page-level-fields "This field is only present on individual pages.")**check_position** ([PositionField](#position-field)): The position of the check on the document.

```rb
for check_position_elem in result.document.check_position do
  puts check_position_elem.polygon
end
```

## Check Issue Date
**date** ([DateField](#date-field)): The date the check was issued.

```rb
puts result.document.inference.prediction.date.value
```

## Payees
**payees** (Array<[StringField](#string-field)>): List of the check's payees (recipients).

```rb
for payees_elem in result.document.inference.prediction.payees do
  puts payees_elem.value
end
```

## Routing Number
**routing_number** ([StringField](#string-field)): The check issuer's routing number.

```rb
puts result.document.inference.prediction.routing_number.value
```

## Signature Positions
[📄](#page-level-fields "This field is only present on individual pages.")**signatures_positions** (Array<[PositionField](#position-field)>): List of signature positions

```rb
for page in result.document.inference.pages do
  for signatures_positions_elem in page.prediction.signatures_positions do
    puts signatures_positions_elem.polygon.to_s
    puts signatures_positions_elem.quadrangle.to_s
    puts signatures_positions_elem.rectangle.to_s
    puts signatures_positions_elem.boundingBox.to_s
  end
end
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)
