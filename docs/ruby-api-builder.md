The Ruby  OCR SDK supports [custom-built API](https://developers.mindee.com/docs/build-your-first-document-parsing-api)
from the API Builder.

If your document isn't covered by one of Mindee's Off-the-Shelf APIs, you can create your own API using the
[API Builder](https://developers.mindee.com/docs/overview).

For the following examples, we are using our own [W9s custom API](https://developers.mindee.com/docs/w9-forms-ocr)
created with the [API Builder](https://developers.mindee.com/docs/overview).

> 📘 **Info**
>
> We used a data model that may be different from yours. To modify this to your own custom API,
> change the `config_custom_doc` call with your own parameters.

```ruby
require 'mindee'

# Init a new client and configure your custom document
mindee_client = Mindee::Client.new(
  api_key: 'my-api-key', # optional, can be set in environment
).config_custom_doc(
  'wsnine',
  'john',
  version: '1.1' # optional, if not set, use the latest version of the model
)

# Load a file from disk and parse it
w9_data = mindee_client.doc_from_path('/path/to/file.pdf').parse('wsnine')

# Print a brief summary of the parsed data
puts w9_data.document.to_s
```

If the `version` argument is set, you'll be required to update it every time a new model is trained.
This is probably not needed for development but essential for production use.

## Parsing Documents
The client calls the `parse` method when parsing your custom document, which will return an object that you can send to the API.
The document type must be specified when calling the parse method.

```ruby
result = mindee_client.doc_from_path('/path/to/custom_file').parse('wsnine')
puts result
```

> 📘 **Info**
>
> If your custom document has the same name as an [off-the-shelf APIs](https://developers.mindee.com/docs/what-is-off-the-shelf-api) document,
> you **must** specify your account name when calling the `parse` method:

```ruby
mindee_client = Mindee::Client.new.config_custom_doc(
  'receipt',
  'john'
)

result = mindee_client.doc_from_path('/path/to/receipt.jpg')
  .parse('receipt', username: 'john')
```

## Document Fields
All the fields defined in the API builder when creating your custom document are available.

In custom documents, each field will hold an array of all the words in the document which are related to that field.
Each word is an object that has the text content, geometry information, and confidence score.

Value fields can be accessed either via the `fields` attribute, or as their own attributes set at run-time.

Classification fields can be accessed either via the `classifications` attribute, or as their own attributes set at run-time.

> 📘 **Info**
>
> Both document level and page level objects work in the same way.

### Run-time Attributes
Individual field values can be accessed simply by using the field's API name, in the examples below we'll use the `address` field.

```ruby
# raw data, list of each word object
puts w9_data.document.address.values

# list of all values
puts w9_data.document.address.contents_list

# default string representation
puts w9_data.document.address.to_s

# custom string representation
puts w9_data.document.address.contents_str(separator: '_')
```

### Fields property
In addition to accessing a value field directly, it's possible to access it through the `fields` attribute.
It's a hashmap with the following structure:
* key: the API name of the field, as a `symbol`
* value: a `ListField` object which has a `values` attribute, containing a list of all values found for the field.

```ruby
# raw data, list of each word object
puts w9_data.document.fields[:address].values
```

This makes it simple to iterate over all the fields:
```ruby
w9_data.document.fields.each do |name, info|
  puts name
  puts info.values
end
```

### Classifications property
In addition to accessing a classification field directly, it's possible to access it through the `classifications` attribute.
It's a hashmap with the following structure:
* key: the API name of the field, as a `symbol`
* value: a `ClassificationField` object which has a `value` attribute, containing a string representation of the detected classification.

```ruby
# raw data, list of each word object
puts w9_data.document.classifications[:doc_type].value
```

This makes it simple to iterate over all the fields:
```ruby
w9_data.document.classifications.each do |name, info|
  puts name
  puts info.value
end
```

## Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)
