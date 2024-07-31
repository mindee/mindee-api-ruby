---
title: Generated API Ruby
category: 622b805aaec68102ea7fcbc2
slug: ruby-generated-ocr
parentDoc: 6294d97ee723f1008d2ab28e
---
The Ruby OCR SDK supports generated APIs.
Generated APIs can theoretically support all APIs in a catch-all generic format.

# Quick-Start

```ruby
require 'mindee'

# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')

# Initialize a custom endpoint for this product
custom_endpoint = mindee_client.create_endpoint(
  account_name: 'my-account',
  endpoint_name: 'my-endpoint',
  version: 'my-version'
)

# Parse the file
result = mindee_client.enqueue_and_parse(
  input_source,
  Mindee::Product::Generated::GeneratedV1,
  endpoint: custom_endpoint
)

# Print a full summary of the parsed data in RST format
puts result.document
```

# Generated Endpoints

You may have noticed in the previous step that in order to access a custom build, you will need to provide an account and an endpoint name at the very least.

Although it is optional, the version number should match the latest version of your build in most use-cases.
If it is not set, it will default to "1".

# Field Types

## Generated Fields

### Generated List Field

A `GeneratedListField` is a special type of custom list that implements the following:

- **values** (`Array<StringField`[GeneratedObjectField](#Generated-object-field)`>`): the confidence score of the field prediction.
- **page_id** (`Integer`): only available for some documents ATM.

Since the inner contents can vary, the value isn't accessed through a property, but rather through the following functions:

- **contents_list()** (`-> Array<String, Float>>`): returns a list of values for each element.
- **contents_string(separator=" ")** (`-> String`): returns a list of concatenated values, with an optional **separator** `String` between them.
> **Note:** the `to_s` method returns a string representation of all values of this object, with an empty space between each of them.

### Generated Object Field

Unrecognized structures and sometimes values of `ListField`s are stored in a `GeneratedObjectField` structure, which is implemented dynamically depending on the object's structure.

- **page_id** (`[Integer, nil]`): the ID of the page, is `nil` when at document-level.
- **raw_value** (`[String, nil]`): an optional field for when some post-processing has been done on fields (e.g. amounts). `nil` in most instances.
- **confidence** (`[Float, nil]`): the confidence score of the field prediction. Warning: support isn't guaranteed on all APIs.


> **Other fields**:No matter what, other fields will be stored in a dictionary-like structure with a `key: value` pair where `key` is a string and `value` is a nullable string. They can be accessed like any other regular value, but won't be suggested by your IDE.


### StringField
The text field `StringField` only has one constraint: its **value** is an `Optional[str]`.


# Attributes

Generated builds always have access to at least two attributes:

## Fields

**fields** (`Hash<String, Array<`[GeneratedListField](#generated-list-field),[GeneratedObjectField](#generated-object-field), `(#stringfield)[StringField]>>`):

```ruby
puts result.document.inference.prediction.fields["my-field"].to_s
```

# Questions?

[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
