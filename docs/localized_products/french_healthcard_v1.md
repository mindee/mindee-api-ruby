---
title: FR Health Card
category: 622b805aaec68102ea7fcbc2
slug: ruby-fr-health-card-ocr
parentDoc: 67b49e29a2cd6f08d69a40d8
---
The Ruby Client Library supports the [Health Card API](https://platform.mindee.com/mindee/french_healthcard).


> 📝 Product Specs
>
> | Specification                  | Details                                            |
> | ------------------------------ | -------------------------------------------------- |
> | Endpoint Name                  | `french_healthcard`                                |
> | Recommended Version            | `v1.0`                                             |
> | Supports Polling/Webhooks      | ✔️ Yes                                             |
> | Support Synchronous HTTP Calls | ❌ No                                              |
> | Geography                      | 🇫🇷 France                                          |

> 🔐 Polling Limitations
>
> | Setting                         | Parameter name          | Default Value |
> | ------------------------------- | ----------------------- | ------------- |
> | Initial Delay Before Polling    | `initial_delay_seconds` | 2 seconds     |
> | Default Delay Between Calls     | `delay_sec`             | 1.5 seconds   |
> | Polling Attempts Before Timeout | `max_retries`           | 80 retries    |


Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/french_healthcard/default_sample.jpg),
we are going to illustrate how to extract the data that we want using the Ruby Client Library.
![Health Card sample](https://github.com/mindee/client-lib-test-data/blob/main/products/french_healthcard/default_sample.jpg?raw=true)

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
  Mindee::Product::FR::HealthCard::HealthCardV1
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
:Mindee ID: 9ee2733d-933a-4dcd-a73a-a31395e3b288
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/french_healthcard v1.0
:Rotation applied: Yes

Prediction
==========
:Given Name(s): NATHALIE
:Surname: DURAND
:Social Security Number: 2 69 05 49 588 157 80
:Issuance Date: 2007-01-01
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
The following fields are extracted for Health Card V1:

## Given Name(s)
**given_names** (Array<[StringField](#string-field)>): The given names of the card holder.

```rb
result.document.inference.prediction.given_names do |given_names_elem|
  puts given_names_elem.value
end
```

## Issuance Date
**issuance_date** ([DateField](#date-field)): The date when the carte vitale document was issued.

```rb
puts result.document.inference.prediction.issuance_date.value
```

## Social Security Number
**social_security** ([StringField](#string-field)): The social security number of the card holder.

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
