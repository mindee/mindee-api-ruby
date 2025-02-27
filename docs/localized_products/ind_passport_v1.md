---
title: IND Passport - India
category: 622b805aaec68102ea7fcbc2
slug: ruby-ind-passport---india-ocr
parentDoc: 67b49e29a2cd6f08d69a40d8
---
The Ruby Client Library supports the [Passport - India API](https://platform.mindee.com/mindee/ind_passport).


> 📝 Product Specs
>
> | Specification                  | Details                                            |
> | ------------------------------ | -------------------------------------------------- |
> | Endpoint Name                  | `ind_passport`                                     |
> | Recommended Version            | `v1.2`                                             |
> | Supports Polling/Webhooks      | ✔️ Yes                                             |
> | Support Synchronous HTTP Calls | ❌ No                                              |
> | Geography                      | 🇮🇳 India                                           |

> 🔐 Polling Limitations
>
> | Setting                         | Parameter name          | Default Value |
> | ------------------------------- | ----------------------- | ------------- |
> | Initial Delay Before Polling    | `initial_delay_seconds` | 2 seconds     |
> | Default Delay Between Calls     | `delay_sec`             | 1.5 seconds   |
> | Polling Attempts Before Timeout | `max_retries`           | 80 retries    |


Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/ind_passport/default_sample.jpg),
we are going to illustrate how to extract the data that we want using the Ruby Client Library.
![Passport - India sample](https://github.com/mindee/client-lib-test-data/blob/main/products/ind_passport/default_sample.jpg?raw=true)

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
  Mindee::Product::IND::IndianPassport::IndianPassportV1
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
:Mindee ID: cf88fd43-eaa1-497a-ba29-a9569a4edaa7
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/ind_passport v1.0
:Rotation applied: Yes

Prediction
==========
:Page Number: 1
:Country: IND
:ID Number: J8369854
:Given Names: JOCELYN MICHELLE
:Surname: DOE
:Birth Date: 1959-09-23
:Birth Place: GUNDUGOLANU
:Issuance Place: HYDERABAD
:Gender: F
:Issuance Date: 2011-10-11
:Expiry Date: 2021-10-10
:MRZ Line 1: P<DOE<<JOCELYNMICHELLE<<<<<<<<<<<<<<<<<<<<<
:MRZ Line 2: J8369854<4IND5909234F2110101<<<<<<<<<<<<<<<8
:Legal Guardian:
:Name of Spouse:
:Name of Mother:
:Old Passport Date of Issue:
:Old Passport Number:
:Address Line 1:
:Address Line 2:
:Address Line 3:
:Old Passport Place of Issue:
:File Number:
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
The following fields are extracted for Passport - India V1:

## Address Line 1
**address1** ([StringField](#string-field)): The first line of the address of the passport holder.

```rb
puts result.document.inference.prediction.address1.value
```

## Address Line 2
**address2** ([StringField](#string-field)): The second line of the address of the passport holder.

```rb
puts result.document.inference.prediction.address2.value
```

## Address Line 3
**address3** ([StringField](#string-field)): The third line of the address of the passport holder.

```rb
puts result.document.inference.prediction.address3.value
```

## Birth Date
**birth_date** ([DateField](#date-field)): The birth date of the passport holder, ISO format: YYYY-MM-DD.

```rb
puts result.document.inference.prediction.birth_date.value
```

## Birth Place
**birth_place** ([StringField](#string-field)): The birth place of the passport holder.

```rb
puts result.document.inference.prediction.birth_place.value
```

## Country
**country** ([StringField](#string-field)): ISO 3166-1 alpha-3 country code (3 letters format).

```rb
puts result.document.inference.prediction.country.value
```

## Expiry Date
**expiry_date** ([DateField](#date-field)): The date when the passport will expire, ISO format: YYYY-MM-DD.

```rb
puts result.document.inference.prediction.expiry_date.value
```

## File Number
**file_number** ([StringField](#string-field)): The file number of the passport document.

```rb
puts result.document.inference.prediction.file_number.value
```

## Gender
**gender** ([ClassificationField](#classification-field)): The gender of the passport holder.

#### Possible values include:
 - M
 - F

```rb
puts result.document.inference.prediction.gender.value
```

## Given Names
**given_names** ([StringField](#string-field)): The given names of the passport holder.

```rb
puts result.document.inference.prediction.given_names.value
```

## ID Number
**id_number** ([StringField](#string-field)): The identification number of the passport document.

```rb
puts result.document.inference.prediction.id_number.value
```

## Issuance Date
**issuance_date** ([DateField](#date-field)): The date when the passport was issued, ISO format: YYYY-MM-DD.

```rb
puts result.document.inference.prediction.issuance_date.value
```

## Issuance Place
**issuance_place** ([StringField](#string-field)): The place where the passport was issued.

```rb
puts result.document.inference.prediction.issuance_place.value
```

## Legal Guardian
**legal_guardian** ([StringField](#string-field)): The name of the legal guardian of the passport holder (if applicable).

```rb
puts result.document.inference.prediction.legal_guardian.value
```

## MRZ Line 1
**mrz1** ([StringField](#string-field)): The first line of the machine-readable zone (MRZ) of the passport document.

```rb
puts result.document.inference.prediction.mrz1.value
```

## MRZ Line 2
**mrz2** ([StringField](#string-field)): The second line of the machine-readable zone (MRZ) of the passport document.

```rb
puts result.document.inference.prediction.mrz2.value
```

## Name of Mother
**name_of_mother** ([StringField](#string-field)): The name of the mother of the passport holder.

```rb
puts result.document.inference.prediction.name_of_mother.value
```

## Name of Spouse
**name_of_spouse** ([StringField](#string-field)): The name of the spouse of the passport holder (if applicable).

```rb
puts result.document.inference.prediction.name_of_spouse.value
```

## Old Passport Date of Issue
**old_passport_date_of_issue** ([DateField](#date-field)): The date of issue of the old passport (if applicable), ISO format: YYYY-MM-DD.

```rb
puts result.document.inference.prediction.old_passport_date_of_issue.value
```

## Old Passport Number
**old_passport_number** ([StringField](#string-field)): The number of the old passport (if applicable).

```rb
puts result.document.inference.prediction.old_passport_number.value
```

## Old Passport Place of Issue
**old_passport_place_of_issue** ([StringField](#string-field)): The place of issue of the old passport (if applicable).

```rb
puts result.document.inference.prediction.old_passport_place_of_issue.value
```

## Page Number
**page_number** ([ClassificationField](#classification-field)): The page number of the passport document.

#### Possible values include:
 - 1
 - 2

```rb
puts result.document.inference.prediction.page_number.value
```

## Surname
**surname** ([StringField](#string-field)): The surname of the passport holder.

```rb
puts result.document.inference.prediction.surname.value
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
