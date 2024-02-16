---
title: US Driver License OCR Ruby
---
The Ruby OCR SDK supports the [Driver License API](https://platform.mindee.com/mindee/us_driver_license).

Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/us_driver_license/default_sample.jpg), we are going to illustrate how to extract the data that we want using the OCR SDK.
![Driver License sample](https://github.com/mindee/client-lib-test-data/blob/main/products/us_driver_license/default_sample.jpg?raw=true)

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
  Mindee::Product::US::DriverLicense::DriverLicenseV1
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
:Mindee ID: bf70068d-d3d6-49dc-b93a-b4b7d156fc3d
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/us_driver_license v1.0
:Rotation applied: Yes

Prediction
==========
:State: AZ
:Driver License ID: D12345678
:Expiry Date: 2018-02-01
:Date Of Issue: 2013-01-10
:Last Name: SAMPLE
:First Name: JELANI
:Address: 123 MAIN STREET PHOENIX AZ 85007
:Date Of Birth: 1957-02-01
:Restrictions: NONE
:Endorsements: NONE
:Driver License Class: D
:Sex: M
:Height: 5-08
:Weight: 185
:Hair Color: BRO
:Eye Color: BRO
:Document Discriminator: 1234567890123456

Page Predictions
================

Page 0
------
:Photo: Polygon with 4 points.
:Signature: Polygon with 4 points.
:State: AZ
:Driver License ID: D12345678
:Expiry Date: 2018-02-01
:Date Of Issue: 2013-01-10
:Last Name: SAMPLE
:First Name: JELANI
:Address: 123 MAIN STREET PHOENIX AZ 85007
:Date Of Birth: 1957-02-01
:Restrictions: NONE
:Endorsements: NONE
:Driver License Class: D
:Sex: M
:Height: 5-08
:Weight: 185
:Hair Color: BRO
:Eye Color: BRO
:Document Discriminator: 1234567890123456
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


### Position Field
The position field `PositionField` does not implement all the basic `Field` attributes, only **bounding_box**, **polygon** and **page_id**. On top of these, it has access to:

* **rectangle** (`Mindee::Geometry::Quadrilateral`): a Polygon with four points that may be oriented (even beyond canvas).
* **quadrangle** (`Mindee::Geometry::Quadrilateral`): a free polygon made up of four points.

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

## Page-Level Fields
Some fields are constrained to the page level, and so will not be retrievable to through the document.

# Attributes
The following fields are extracted for Driver License V1:

## Address
**address** ([StringField](#string-field)): US driver license holders address

```rb
puts result.document.inference.prediction.address.value
```

## Date Of Birth
**date_of_birth** ([DateField](#date-field)): US driver license holders date of birth

```rb
puts result.document.inference.prediction.date_of_birth.value
```

## Document Discriminator
**dd_number** ([StringField](#string-field)): Document Discriminator Number of the US Driver License

```rb
puts result.document.inference.prediction.dd_number.value
```

## Driver License Class
**dl_class** ([StringField](#string-field)): US driver license holders class

```rb
puts result.document.inference.prediction.dl_class.value
```

## Driver License ID
**driver_license_id** ([StringField](#string-field)): ID number of the US Driver License.

```rb
puts result.document.inference.prediction.driver_license_id.value
```

## Endorsements
**endorsements** ([StringField](#string-field)): US driver license holders endorsements

```rb
puts result.document.inference.prediction.endorsements.value
```

## Expiry Date
**expiry_date** ([DateField](#date-field)): Date on which the documents expires.

```rb
puts result.document.inference.prediction.expiry_date.value
```

## Eye Color
**eye_color** ([StringField](#string-field)): US driver license holders eye colour

```rb
puts result.document.inference.prediction.eye_color.value
```

## First Name
**first_name** ([StringField](#string-field)): US driver license holders first name(s)

```rb
puts result.document.inference.prediction.first_name.value
```

## Hair Color
**hair_color** ([StringField](#string-field)): US driver license holders hair colour

```rb
puts result.document.inference.prediction.hair_color.value
```

## Height
**height** ([StringField](#string-field)): US driver license holders hight

```rb
puts result.document.inference.prediction.height.value
```

## Date Of Issue
**issued_date** ([DateField](#date-field)): Date on which the documents was issued.

```rb
puts result.document.inference.prediction.issued_date.value
```

## Last Name
**last_name** ([StringField](#string-field)): US driver license holders last name

```rb
puts result.document.inference.prediction.last_name.value
```

## Photo
[📄](#page-level-fields "This field is only present on individual pages.")**photo** ([PositionField](#position-field)): Has a photo of the US driver license holder

```rb
for photo_elem in result.document.photo do
  puts photo_elem.polygon
end
```

## Restrictions
**restrictions** ([StringField](#string-field)): US driver license holders restrictions

```rb
puts result.document.inference.prediction.restrictions.value
```

## Sex
**sex** ([StringField](#string-field)): US driver license holders gender

```rb
puts result.document.inference.prediction.sex.value
```

## Signature
[📄](#page-level-fields "This field is only present on individual pages.")**signature** ([PositionField](#position-field)): Has a signature of the US driver license holder

```rb
for signature_elem in result.document.signature do
  puts signature_elem.polygon
end
```

## State
**state** ([StringField](#string-field)): US State

```rb
puts result.document.inference.prediction.state.value
```

## Weight
**weight** ([StringField](#string-field)): US driver license holders weight

```rb
puts result.document.inference.prediction.weight.value
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)
