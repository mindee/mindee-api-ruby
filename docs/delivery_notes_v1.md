---
title: Delivery note OCR Ruby
category: 622b805aaec68102ea7fcbc2
slug: ruby-delivery-note-ocr
parentDoc: 6294d97ee723f1008d2ab28e
---
The Ruby OCR SDK supports the [Delivery note API](https://platform.mindee.com/mindee/delivery_notes).

Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/delivery_notes/default_sample.jpg), we are going to illustrate how to extract the data that we want using the OCR SDK.
![Delivery note sample](https://github.com/mindee/client-lib-test-data/blob/main/products/delivery_notes/default_sample.jpg?raw=true)

# Quick-Start
```rb
require 'mindee'

# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')

# Parse the file
result = mindee_client.enqueue_and_parse(
  input_source,
  Mindee::Product::DeliveryNote::DeliveryNoteV1
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
:Mindee ID: d5ead821-edec-4d31-a69a-cf3998d9a506
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/delivery_notes v1.0
:Rotation applied: Yes

Prediction
==========
:Delivery Date: 2019-10-02
:Delivery Number: INT-001
:Supplier Name: John Smith
:Supplier Address: 4490 Oak Drive, Albany, NY 12210
:Customer Name: Jessie M Horne
:Customer Address: 4312 Wood Road, New York, NY 10031
:Total Amount: 204.75
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


### Amount Field
The amount field `AmountField` only has one constraint: its **value** is a `Float` (or `nil`).

### Date Field
Aside from the basic `Field` attributes, the date field `DateField` also implements the following: 

* **date_object** (`Date`): an accessible representation of the value as a JavaScript object.

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

# Attributes
The following fields are extracted for Delivery note V1:

## Customer Address
**customer_address** ([StringField](#string-field)): The address of the customer receiving the goods.

```rb
puts result.document.inference.prediction.customer_address.value
```

## Customer Name
**customer_name** ([StringField](#string-field)): The name of the customer receiving the goods.

```rb
puts result.document.inference.prediction.customer_name.value
```

## Delivery Date
**delivery_date** ([DateField](#date-field)): The date on which the delivery is scheduled to arrive.

```rb
puts result.document.inference.prediction.delivery_date.value
```

## Delivery Number
**delivery_number** ([StringField](#string-field)): A unique identifier for the delivery note.

```rb
puts result.document.inference.prediction.delivery_number.value
```

## Supplier Address
**supplier_address** ([StringField](#string-field)): The address of the supplier providing the goods.

```rb
puts result.document.inference.prediction.supplier_address.value
```

## Supplier Name
**supplier_name** ([StringField](#string-field)): The name of the supplier providing the goods.

```rb
puts result.document.inference.prediction.supplier_name.value
```

## Total Amount
**total_amount** ([AmountField](#amount-field)): The total monetary value of the goods being delivered.

```rb
puts result.document.inference.prediction.total_amount.value
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
