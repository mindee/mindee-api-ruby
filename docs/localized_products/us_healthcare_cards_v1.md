---
title: US Healthcare Card
category: 622b805aaec68102ea7fcbc2
slug: ruby-us-healthcare-card-ocr
parentDoc: 67b49e29a2cd6f08d69a40d8
---
The Ruby Client Library supports the [Healthcare Card API](https://platform.mindee.com/mindee/us_healthcare_cards).


> 📝 Product Specs
>
> | Specification                  | Details                                            |
> | ------------------------------ | -------------------------------------------------- |
> | Endpoint Name                  | `us_healthcare_cards`                              |
> | Recommended Version            | `v1.3`                                             |
> | Supports Polling/Webhooks      | ✔️ Yes                                             |
> | Support Synchronous HTTP Calls | ❌ No                                              |
> | Geography                      | 🇺🇸 United States                                   |

> 🔐 Polling Limitations
>
> | Setting                         | Parameter name          | Default Value |
> | ------------------------------- | ----------------------- | ------------- |
> | Initial Delay Before Polling    | `initial_delay_seconds` | 2 seconds     |
> | Default Delay Between Calls     | `delay_sec`             | 1.5 seconds   |
> | Polling Attempts Before Timeout | `max_retries`           | 80 retries    |


Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/us_healthcare_cards/default_sample.jpg),
we are going to illustrate how to extract the data that we want using the Ruby Client Library.
![Healthcare Card sample](https://github.com/mindee/client-lib-test-data/blob/main/products/us_healthcare_cards/default_sample.jpg?raw=true)

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
  Mindee::Product::US::HealthcareCard::HealthcareCardV1
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
:Mindee ID: 5e917fc8-5c13-42b2-967f-954f4eed9959
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/us_healthcare_cards v1.3
:Rotation applied: Yes

Prediction
==========
:Company Name: UnitedHealthcare
:Plan Name: Choice Plus
:Member Name: SUBSCRIBER SMITH
:Member ID: 123456789
:Issuer 80840:
:Dependents: SPOUSE SMITH
             CHILD1 SMITH
             CHILD2 SMITH
             CHILD3 SMITH
:Group Number: 98765
:Payer ID: 87726
:RX BIN: 610279
:RX ID:
:RX GRP: UHEALTH
:RX PCN: 9999
:Copays:
  +--------------+----------------------+
  | Service Fees | Service Name         |
  +==============+======================+
  | 20.00        | office_visit         |
  +--------------+----------------------+
  | 300.00       | emergency_room       |
  +--------------+----------------------+
  | 75.00        | urgent_care          |
  +--------------+----------------------+
  | 30.00        | specialist           |
  +--------------+----------------------+
:Enrollment Date:
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

## Specific Fields
Fields which are specific to this product; they are not used in any other product.

### Copays Field
Copayments for covered services.

A `HealthcareCardV1Copay` implements the following attributes:

* `service_fees` (Float): The price of the service.
* `service_name` (String): The name of the service.

#### Possible values include:
 - primary_care
 - emergency_room
 - urgent_care
 - specialist
 - office_visit
 - prescription
        

# Attributes
The following fields are extracted for Healthcare Card V1:

## Company Name
**company_name** ([StringField](#string-field)): The name of the company that provides the healthcare plan.

```rb
puts result.document.inference.prediction.company_name.value
```

## Copays
**copays** (Array<[HealthcareCardV1Copay](#copays-field)>): Copayments for covered services.

```rb
result.document.inference.prediction.copays do |copays_elem|
  puts copays_elem.value
end
```

## Dependents
**dependents** (Array<[StringField](#string-field)>): The list of dependents covered by the healthcare plan.

```rb
result.document.inference.prediction.dependents do |dependents_elem|
  puts dependents_elem.value
end
```

## Enrollment Date
**enrollment_date** ([DateField](#date-field)): The date when the member enrolled in the healthcare plan.

```rb
puts result.document.inference.prediction.enrollment_date.value
```

## Group Number
**group_number** ([StringField](#string-field)): The group number associated with the healthcare plan.

```rb
puts result.document.inference.prediction.group_number.value
```

## Issuer 80840
**issuer80840** ([StringField](#string-field)): The organization that issued the healthcare plan.

```rb
puts result.document.inference.prediction.issuer80840.value
```

## Member ID
**member_id** ([StringField](#string-field)): The unique identifier for the member in the healthcare system.

```rb
puts result.document.inference.prediction.member_id.value
```

## Member Name
**member_name** ([StringField](#string-field)): The name of the member covered by the healthcare plan.

```rb
puts result.document.inference.prediction.member_name.value
```

## Payer ID
**payer_id** ([StringField](#string-field)): The unique identifier for the payer in the healthcare system.

```rb
puts result.document.inference.prediction.payer_id.value
```

## Plan Name
**plan_name** ([StringField](#string-field)): The name of the healthcare plan.

```rb
puts result.document.inference.prediction.plan_name.value
```

## RX BIN
**rx_bin** ([StringField](#string-field)): The BIN number for prescription drug coverage.

```rb
puts result.document.inference.prediction.rx_bin.value
```

## RX GRP
**rx_grp** ([StringField](#string-field)): The group number for prescription drug coverage.

```rb
puts result.document.inference.prediction.rx_grp.value
```

## RX ID
**rx_id** ([StringField](#string-field)): The ID number for prescription drug coverage.

```rb
puts result.document.inference.prediction.rx_id.value
```

## RX PCN
**rx_pcn** ([StringField](#string-field)): The PCN number for prescription drug coverage.

```rb
puts result.document.inference.prediction.rx_pcn.value
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
