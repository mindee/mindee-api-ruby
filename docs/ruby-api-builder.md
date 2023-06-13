The Ruby  OCR SDK supports [custom-built API](https://developers.mindee.com/docs/build-your-first-document-parsing-api) from the API Builder.

If your document isn't covered by one of Mindee's Off-the-Shelf APIs, you can create your own API using the
[API Builder](https://developers.mindee.com/docs/overview).

For the following examples, we are using our own [W9s custom API](https://developers.mindee.com/docs/w9-forms-ocr),
created with the [API Builder](https://developers.mindee.com/docs/overview).

> 📘 **Info**
>
> We used a data model that will be different from yours.
> To modify this to your own custom API, change the `add_endpoint` call with your own parameters.

```ruby
require 'mindee'

# Init a new client and configure your custom document
mindee_client = Mindee::Client.new(api_key: 'my-api-key').add_endpoint(
  'john',
  'wnine',
  version: '1.1' # optional, if not set, use the latest version of the model
)

# Load a file from disk and parse it
result = mindee_client.doc_from_path('/path/to/file.ext')
  .parse(Mindee::Prediction::CustomV1, endpoint_name: 'wnine')

# Print a summary of the document prediction in RST format
puts result.document
```

If the `version` argument is set, you'll be required to update it every time a new model is trained.
This is probably not needed for development but essential for production use.

## Parsing Documents
The client calls the `parse` method when parsing your custom document, which will return an object that you can send to the API.
The document type must be specified when calling the parse method.

```ruby
result = mindee_client.doc_from_path('/path/to/custom_file')
  .parse(Mindee::Prediction::CustomV1, endpoint_name: 'wnine')
puts result.document
```

> 📘 **Info**
>
> If your custom document has the same name as an [off-the-shelf APIs](https://developers.mindee.com/docs/what-is-off-the-shelf-api) document,
> you **must** specify your account name when calling the `parse` method:

```ruby
mindee_client = Mindee::Client.new.add_endpoint(
  'receipt',
  'john'
)

result = mindee_client.doc_from_path('/path/to/receipt.jpg')
  .parse(Mindee::Prediction::CustomV1, account_name: 'john')
```

## Document Fields
All the fields defined in the API builder when creating your custom document are available.

In custom documents, each field will hold an array of all the words in the document which are related to that field.
Each word is an object that has the text content, geometry information, and confidence score.

Value fields can be accessed via the `fields` attribute.

Classification fields can be accessed via the `classifications` attribute.

> 📘 **Info**
>
> Both document level and page level objects work in the same way.

### Fields Attribute
The `fields` attribute is a hashmap with the following structure:

* key: the API name of the field, as a `symbol`
* value: a `ListField` object which has a `values` attribute, containing a list of all values found for the field.

Individual field values can be accessed by using the field's API name, in the examples below we'll use the `address` field.

```ruby
# raw data, list of each word object
pp result.document.inference.prediction.fields[:address].values

# list of all values
puts result.document.inference.prediction.fields[:address].contents_list

# default string representation
puts result.document.inference.prediction.fields[:address].to_s

# custom string representation
puts result.document.inference.prediction.fields[:address].contents_str(separator: '_')
```

To iterate over all the fields:
```ruby
result.document.inference.prediction.fields.each do |name, info|
  puts name
  puts info.values
end
```

### Classifications Attribute
The `classifications` attribute is a hashmap with the following structure:

* key: the API name of the field, as a `symbol`
* value: a `ClassificationField` object which has a `value` attribute, containing a string representation of the detected classification.

```ruby
# raw data, list of each word object
puts result.document.classifications[:doc_type].value
```

To iterate over all the classifications:
```ruby
result.document.classifications.each do |name, info|
  puts name
  puts info.value
end
```

## Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)
