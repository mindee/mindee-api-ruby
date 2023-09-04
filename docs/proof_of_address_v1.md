---
title: Proof of Address OCR Ruby
---
The Ruby OCR SDK supports the [Proof of Address API](https://platform.mindee.com/mindee/proof_of_address).

Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/proof_of_address/default_sample.jpg), we are going to illustrate how to extract the data that we want using the OCR SDK.
![Proof of Address sample](https://github.com/mindee/client-lib-test-data/blob/main/products/proof_of_address/default_sample.jpg?raw=true)

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
  Mindee::Product::ProofOfAddress::ProofOfAddressV1
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
:Mindee ID: 3a7e1da6-d4d0-4704-af91-051fe5484c2e
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/proof_of_address v1.0
:Rotation applied: Yes

Prediction
==========
:Locale: en; en; USD;
:Issuer Name: PPL ELECTRIC UTILITIES
:Issuer Company Registrations:
:Issuer Address: 2 NORTH 9TH STREET CPC-GENN1 ALLENTOWN,PA 18101-1175
:Recipient Name:
:Recipient Company Registrations:
:Recipient Address: 123 MAIN ST ANYTOWN,PA 18062
:Dates: 2011-07-27
        2011-07-06
        2011-08-03
        2011-07-27
        2011-06-01
        2011-07-01
        2010-07-01
        2010-08-01
        2011-07-01
        2009-08-01
        2010-07-01
        2011-07-27
:Date of Issue: 2011-07-27

Page Predictions
================

Page 0
------
:Locale: en; en; USD;
:Issuer Name: PPL ELECTRIC UTILITIES
:Issuer Company Registrations:
:Issuer Address: 2 NORTH 9TH STREET CPC-GENN1 ALLENTOWN,PA 18101-1175
:Recipient Name:
:Recipient Company Registrations:
:Recipient Address: 123 MAIN ST ANYTOWN,PA 18062
:Dates: 2011-07-27
        2011-07-06
        2011-08-03
        2011-07-27
        2011-06-01
        2011-07-01
        2010-07-01
        2010-08-01
        2011-07-01
        2009-08-01
        2010-07-01
        2011-07-27
:Date of Issue: 2011-07-27
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


### Company Registration Field
Aside from the basic `Field` attributes, the company registration field `CompanyRegistrationField` also implements the following:

* **type** (`String`): the type of company.

### Date Field
Aside from the basic `Field` attributes, the date field `DateField` also implements the following: 

* **date_object** (`Date`): an accessible representation of the value as a JavaScript object.

### Locale Field
The locale field `LocaleField` only implements the **value**, **confidence** and **page_id** base `Field` attributes, but it comes with its own:

* **language** (`String`): ISO 639-1 language code (e.g.: `en` for English). Can be `nil`.
* **country** (`String`): ISO 3166-1 alpha-2 or ISO 3166-1 alpha-3 code for countries (e.g.: `GRB` or `GB` for "Great Britain"). Can be `nil`.
* **currency** (`String`): ISO 4217 code for currencies (e.g.: `USD` for "US Dollars"). Can be `nil`.

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

# Attributes
The following fields are extracted for Proof of Address V1:

## Date of Issue
**date** ([DateField](#date-field)): The date the document was issued.

```rb
puts result.document.inference.prediction.date.value
```

## Dates
**dates** (Array<[DateField](#date-field)>): List of dates found on the document.

```rb
for dates_elem in result.document.inference.prediction.dates do
  puts dates_elem.value
end
```

## Issuer Address
**issuer_address** ([StringField](#string-field)): The address of the document's issuer.

```rb
puts result.document.inference.prediction.issuer_address.value
```

## Issuer Company Registrations
**issuer_company_registration** (Array<[CompanyRegistrationField](#company-registration-field)>): List of company registrations found for the issuer.

```rb
for issuer_company_registration_elem in result.document.inference.prediction.issuer_company_registration do
  puts issuer_company_registration_elem.value
end
```

## Issuer Name
**issuer_name** ([StringField](#string-field)): The name of the person or company issuing the document.

```rb
puts result.document.inference.prediction.issuer_name.value
```

## Locale
**locale** ([LocaleField](#locale-field)): The locale detected on the document.

```rb
puts result.document.inference.prediction.locale.value
```

## Recipient Address
**recipient_address** ([StringField](#string-field)): The address of the recipient.

```rb
puts result.document.inference.prediction.recipient_address.value
```

## Recipient Company Registrations
**recipient_company_registration** (Array<[CompanyRegistrationField](#company-registration-field)>): List of company registrations found for the recipient.

```rb
for recipient_company_registration_elem in result.document.inference.prediction.recipient_company_registration do
  puts recipient_company_registration_elem.value
end
```

## Recipient Name
**recipient_name** ([StringField](#string-field)): The name of the person or company receiving the document.

```rb
puts result.document.inference.prediction.recipient_name.value
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)
