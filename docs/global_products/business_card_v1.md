---
title: Ruby Client Library - Business Card
category: 622b805aaec68102ea7fcbc2
slug: ruby-business-card-ocr
parentDoc: 67b49df15b843f3fa9cd622b
---
The Ruby Client Library SDK supports the [Business Card API](https://platform.mindee.com/mindee/business_card).

Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/business_card/default_sample.jpg), we are going to illustrate how to extract the data that we want using the Ruby Client Library.
![Business Card sample](https://github.com/mindee/client-lib-test-data/blob/main/products/business_card/default_sample.jpg?raw=true)

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
  Mindee::Product::BusinessCard::BusinessCardV1
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
:Mindee ID: 6f9a261f-7609-4687-9af0-46a45156566e
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/business_card v1.0
:Rotation applied: Yes

Prediction
==========
:Firstname: Andrew
:Lastname: Morin
:Job Title: Founder & CEO
:Company: RemoteGlobal
:Email: amorin@remoteglobalconsulting.com
:Phone Number: +14015555555
:Mobile Number: +13015555555
:Fax Number: +14015555556
:Address: 178 Main Avenue, Providence, RI 02111
:Website: www.remoteglobalconsulting.com
:Social Media: https://www.linkedin.com/in/johndoe
               https://twitter.com/johndoe
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

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

# Attributes
The following fields are extracted for Business Card V1:

## Address
**address** ([StringField](#string-field)): The address of the person.

```rb
puts result.document.inference.prediction.address.value
```

## Company
**company** ([StringField](#string-field)): The company the person works for.

```rb
puts result.document.inference.prediction.company.value
```

## Email
**email** ([StringField](#string-field)): The email address of the person.

```rb
puts result.document.inference.prediction.email.value
```

## Fax Number
**fax_number** ([StringField](#string-field)): The Fax number of the person.

```rb
puts result.document.inference.prediction.fax_number.value
```

## Firstname
**firstname** ([StringField](#string-field)): The given name of the person.

```rb
puts result.document.inference.prediction.firstname.value
```

## Job Title
**job_title** ([StringField](#string-field)): The job title of the person.

```rb
puts result.document.inference.prediction.job_title.value
```

## Lastname
**lastname** ([StringField](#string-field)): The lastname of the person.

```rb
puts result.document.inference.prediction.lastname.value
```

## Mobile Number
**mobile_number** ([StringField](#string-field)): The mobile number of the person.

```rb
puts result.document.inference.prediction.mobile_number.value
```

## Phone Number
**phone_number** ([StringField](#string-field)): The phone number of the person.

```rb
puts result.document.inference.prediction.phone_number.value
```

## Social Media
**social_media** (Array<[StringField](#string-field)>): The social media profiles of the person or company.

```rb
for social_media_elem in result.document.inference.prediction.social_media do
  puts social_media_elem.value
end
```

## Website
**website** ([StringField](#string-field)): The website of the person or company.

```rb
puts result.document.inference.prediction.website.value
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
