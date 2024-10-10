---
title: US US Mail OCR Ruby
category: 622b805aaec68102ea7fcbc2
slug: ruby-us-us-mail-ocr
parentDoc: 6294d97ee723f1008d2ab28e
---
The Ruby OCR SDK supports the [US Mail API](https://platform.mindee.com/mindee/us_mail).

Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/us_mail/default_sample.jpg), we are going to illustrate how to extract the data that we want using the OCR SDK.
![US Mail sample](https://github.com/mindee/client-lib-test-data/blob/main/products/us_mail/default_sample.jpg?raw=true)

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
  Mindee::Product::US::UsMail::UsMailV2
)

# Print a full summary of the parsed data in RST format
puts result.document

# Print the document-level parsed data
# puts result.document.inference.prediction

```

**Output (RST):**
```rst
:Sender Name: zed
:Sender Address:
  :City: Dallas
  :Complete Address: 54321 Elm Street, Dallas, Texas 54321
  :Postal Code: 54321
  :State: TX
  :Street: 54321 Elm Street
:Recipient Names: Jane Doe
:Recipient Addresses:
  +-----------------+-------------------------------------+-------------------+-------------+------------------------+-------+---------------------------+
  | City            | Complete Address                    | Is Address Change | Postal Code | Private Mailbox Number | State | Street                    |
  +=================+=====================================+===================+=============+========================+=======+===========================+
  | Detroit         | 1234 Market Street PMB 4321, Det... |                   | 12345       | 4321                   | MI    | 1234 Market Street        |
  +-----------------+-------------------------------------+-------------------+-------------+------------------------+-------+---------------------------+
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

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

## Specific Fields
Fields which are specific to this product; they are not used in any other product.

### Recipient Addresses Field
The addresses of the recipients.

A `UsMailV2RecipientAddress` implements the following attributes:

* `city` (String): The city of the recipient's address.
* `complete` (String): The complete address of the recipient.
* `is_address_change` (Boolean): Indicates if the recipient's address is a change of address.
* `postal_code` (String): The postal code of the recipient's address.
* `private_mailbox_number` (String): The private mailbox number of the recipient's address.
* `state` (String): Second part of the ISO 3166-2 code, consisting of two letters indicating the US State.
* `street` (String): The street of the recipient's address.
Fields which are specific to this product; they are not used in any other product.

### Sender Address Field
The address of the sender.

A `UsMailV2SenderAddress` implements the following attributes:

* `city` (String): The city of the sender's address.
* `complete` (String): The complete address of the sender.
* `postal_code` (String): The postal code of the sender's address.
* `state` (String): Second part of the ISO 3166-2 code, consisting of two letters indicating the US State.
* `street` (String): The street of the sender's address.

# Attributes
The following fields are extracted for US Mail V2:

## Recipient Addresses
**recipient_addresses** (Array<[UsMailV2RecipientAddress](#recipient-addresses-field)>): The addresses of the recipients.

```rb
for recipient_addresses_elem in result.document.inference.prediction.recipient_addresses do
  puts recipient_addresses_elem.value
end
```

## Recipient Names
**recipient_names** (Array<[StringField](#string-field)>): The names of the recipients.

```rb
for recipient_names_elem in result.document.inference.prediction.recipient_names do
  puts recipient_names_elem.value
end
```

## Sender Address
**sender_address** ([UsMailV2SenderAddress](#sender-address-field)): The address of the sender.

```rb
puts result.document.inference.prediction.sender_address.value
```

## Sender Name
**sender_name** ([StringField](#string-field)): The name of the sender.

```rb
puts result.document.inference.prediction.sender_name.value
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
