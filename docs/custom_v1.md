---
title: Custom API Ruby
---
The Ruby OCR SDK supports [custom-built APIs](https://developers.mindee.com/docs/build-your-first-document-parsing-api).
If your document isn't covered by one of Mindee's Off-the-Shelf APIs, you can create your own API using the[API Builder](https://platform.mindee.com/api-builder).

# Quick-Start

```rb
require 'mindee'

# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')

# Initialize a custom endpoint for this product
custom_endpoint = mindee_client.create_endpoint(
  account_name: 'my-account',
  endpoint_name: 'my-endpoint'
)

# Parse the file
result = mindee_client.parse(
  input_source,
  Mindee::Product::Custom::CustomV1,
  endpoint: custom_endpoint
)

# Print a full summary of the parsed data in RST format
puts result.document

# Print the document-level parsed data
# puts result.document.inference.prediction

# Looping over all prediction values
result.document.inference.prediction.fields.each do |field_name, field_data|
  puts field_name
  puts field_data.values
  puts field_data.to_s
end
```

# Custom Endpoints

You may have noticed in the previous step that in order to access a custom build, you will need to provide an account and an endpoint name at the very least.

Although it is optional, the version number should match the latest version of your build in most use-cases.
If it is not set, it will default to "1".


# Field Types

## Custom Fields

### List Field

A `ListField` is a special type of custom list that implements the following:

* **confidence** (`Float`): the confidence score of the field prediction.
* **reconstructed** (`Boolean`): indicates whether or not an object was reconstructed (not extracted as the API gave it).
* **values** (`Array<`[ListFieldItem](#list-field-item)`>`): list of value fields

Since the inner contents can vary, the value isn't accessed through a property, but rather through the following functions:
* **contents_list()** (`[Array, Hash, String, nil]`): returns a list of values for each element.
* **contents_str(separator:' ')** (`String`): returns a list of concatenated values, with an optional **separator** `String` between them.
* **to_s()**: returns a string representation of all values, with an empty space between each of them.

#### List Field Item

Values of `ListField`s are stored in a `ListFieldItem` structure, which is implemented as follows:
* **content** (`String`): extracted content of the prediction
* **confidence** (`Float`): the confidence score of the prediction
* **bounding_box** (`Quadrilateral`): 4 relative vertices corrdinates of a rectangle containing the word in the document.
* **polygon** (`Polygon`): vertices of a polygon containing the word.
* **page_id** (`Integer`): the ID of the page, is `nil` when at document-level.

### Classification Field

A `ClassificationField` is a special type of custom classification that implements the following:

* **value** (`String`): the value of the classification. Corresponds to one of the values specified during training.
* **confidence** (`Float`): the confidence score of the field prediction.
* **to_s()**: returns a string representation of all values, with an empty space between each of them.

# Attributes

Custom builds always have access to at least two attributes:

## Fields

**fields** ({`String`=> [ListField](#list-field)}): 

```rb
puts result.document.inference.prediction.fields[:my_field].value
```

## Classifications

**classifications** ({`String` => [ClassificationField](#classification-field)}): The purchase category among predefined classes.

```js
console.log(result.document.inference.prediction.classifications["my-classification"].to_s);
```

# Questions?

[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)
