# Mindee API Helper Library for Ruby
Quickly and easily connect to Mindee's API services using Ruby.

## Quick Start
Here's the TL;DR of getting started.

First, get an [API Key](https://developers.mindee.com/docs/create-api-key)

Install by adding this line to your application's Gemfile:

```ruby
gem 'mindee'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install mindee

Finally, Ruby away!

### Off-the-Shelf Document
```ruby
require 'mindee'

# Init a new client and configure the Invoice API
mindee_client = Mindee::Client.new(api_key: 'my-api-key').config_invoice

# Load a file from disk and parse it
api_response = mindee_client.doc_from_path('/path/to/the/file.ext')
  .parse('invoice')

# Print a brief summary of the parsed data
puts api_response.document
```

### Custom Document (API Builder)
```ruby
require 'mindee'

# Init a new client and configure your custom document
mindee_client = Mindee::Client.new(api_key: 'my-api-key').config_custom_doc(
  'pokemon-card',
  'pikachu'
)

# Load a file from disk and parse it
api_response = mindee_client.doc_from_path('/path/to/the/file.ext')
  .parse('pokemon-card')

# Print a brief summary of the parsed data
puts api_response.document
```

## Further Reading
There's more to it than that for those that need more features, or want to
customize the experience.

All the juicy details are described in the
**[Official Documentation](https://developers.mindee.com/docs/ruby-getting-started)**.

## License
Copyright © Mindee

Available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
