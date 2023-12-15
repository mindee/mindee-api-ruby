---
title: FR Bank Account Details OCR Ruby
---
The Ruby OCR SDK supports the [Bank Account Details API](https://platform.mindee.com/mindee/bank_account_details).

Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/bank_account_details/default_sample.jpg), we are going to illustrate how to extract the data that we want using the OCR SDK.
![Bank Account Details sample](https://github.com/mindee/client-lib-test-data/blob/main/products/bank_account_details/default_sample.jpg?raw=true)

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
  Mindee::Product::FR::BankAccountDetails::BankAccountDetailsV2
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
:Mindee ID: bc8f7265-8dab-49fe-810c-d50049605578
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/bank_account_details v2.0
:Rotation applied: Yes

Prediction
==========
:Account Holder's Names: MME HEGALALDIA L ENVOL
:Basic Bank Account Number:
  :Bank Code: 13335
  :Branch Code: 00040
  :Key: 06
  :Account Number: 08932891361
:IBAN: FR7613335000400893289136106
:SWIFT Code: CEPAFRPP333

Page Predictions
================

Page 0
------
:Account Holder's Names: MME HEGALALDIA L ENVOL
:Basic Bank Account Number:
  :Bank Code: 13335
  :Branch Code: 00040
  :Key: 06
  :Account Number: 08932891361
:IBAN: FR7613335000400893289136106
:SWIFT Code: CEPAFRPP333
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

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

## Specific Fields
Fields which are specific to this product; they are not used in any other product.

### Basic Bank Account Number Field
Full extraction of BBAN, including: branch code, bank code, account and key.

A `BankAccountDetailsV2Bban` implements the following attributes:

* `bban_bank_code` (String): The BBAN bank code outputted as a string.
* `bban_branch_code` (String): The BBAN branch code outputted as a string.
* `bban_key` (String): The BBAN key outputted as a string.
* `bban_number` (String): The BBAN Account number outputted as a string.

# Attributes
The following fields are extracted for Bank Account Details V2:

## Account Holder's Names
**account_holders_names** ([StringField](#string-field)): Full extraction of the account holders names.

```rb
puts result.document.inference.prediction.account_holders_names.value
```

## Basic Bank Account Number
**bban** ([BankAccountDetailsV2Bban](#basic-bank-account-number-field)): Full extraction of BBAN, including: branch code, bank code, account and key.

```rb
puts result.document.inference.prediction.bban.value
```

## IBAN
**iban** ([StringField](#string-field)): Full extraction of the IBAN number.

```rb
puts result.document.inference.prediction.iban.value
```

## SWIFT Code
**swift_code** ([StringField](#string-field)): Full extraction of the SWIFT code.

```rb
puts result.document.inference.prediction.swift_code.value
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)
