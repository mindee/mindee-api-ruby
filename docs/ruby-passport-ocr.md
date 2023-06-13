The Ruby  OCR SDK supports the [passport API](https://developers.mindee.com/docs/passport-ocr) for extracting data from passports.

Using the sample below, we are going to illustrate how to extract the data that we want using the  OCR SDK.

![sample passport](https://raw.githubusercontent.com/mindee/client-lib-test-data/main/passport/passport.jpeg)

## Quick Start
```ruby
require 'mindee'

# Init a new client, specifying an API key
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Send the file
result = mindee_client.doc_from_path('/path/to/the/file.ext').parse(Mindee::Prediction::PassportV1)

# Print a summary of the document prediction in RST format
puts result.document.inference.prediction
```

Output:
```
:Full name: HENERT PUDARSAN
:Given names: HENERT
:Surname: PUDARSAN
:Country: GBR
:ID Number: 707797979
:Issuance date: 2012-04-22
:Birth date: 1995-05-20
:Expiry date: 2017-04-22
:MRZ 1: P<GBRPUDARSAN<<HENERT<<<<<<<<<<<<<<<<<<<<<<<
:MRZ 2: 7077979792GBR9505209M1704224<<<<<<<<<<<<<<00
:MRZ: P<GBRPUDARSAN<<HENERT<<<<<<<<<<<<<<<<<<<<<<<7077979792GBR9505209M1704224<<<<<<<<<<<<<<00
```

## Fields
Each prediction object contains a set of different fields.
Each `Field` object contains at a minimum the following attributes:

* `value` (String or Float depending on the field type): corresponds to the field value. Can be `nil` if no value was extracted.
* `confidence` (Float): the confidence score of the field prediction.
* `bounding_box` (Array< Array< Float > >): contains exactly 4 relative vertices coordinates (points) of a right rectangle containing the field in the document.
* `polygon` (Array< Array< Float > >): contains the relative vertices coordinates (points) of a polygon containing the field in the image.
* `reconstructed` (Boolean): True if the field was reconstructed or computed using other fields.


## Attributes
Depending on the field type specified, additional attributes can be extracted from the `Passport` object.

Using the above sample, the following are the basic fields that can be extracted:

- [Quick Start](#quick-start)
- [Fields](#fields)
- [Attributes](#attributes)
  - [Birth Place](#birth-place)
  - [Country](#country)
  - [Dates](#dates)
  - [Gender](#gender)
  - [Names](#names)
  - [ID](#id)
  - [Machine-Readable Zone](#machine-readable-zone)
- [Questions?](#questions)

### Birth Place

**`birth_place`** (Field): Passport owner birthplace.

```ruby
puts result.document.inference.prediction.birth_place.value
```

### Country
**`country`** (Field): Passport country in [ISO 3166-1 alpha-3 code format](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) (3-letter code).

```ruby
puts result.document.inference.prediction.country.value
```

### Dates
Date fields:

* contain the `date_object` attribute, which is a standard Ruby [date object](https://ruby-doc.org/stdlib-2.7.1/libdoc/date/rdoc/Date.html)
* have a `value` attribute which is the [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) representation of the date.

The following date fields are available:

**`expiry_date`**: Passport expiry date.

```ruby
puts result.document.inference.prediction.expiry_date.value
```

**`issuance_date`**: Passport date of issuance.

```ruby
puts result.document.inference.prediction.issuance_date.value
```

**`birth_date`**: Passport's owner date of birth.

```ruby
puts result.document.inference.prediction.birth_date.value
```

### Gender

**`gender`** (Field): Passport owner's gender (M / F).

```ruby
puts result.document.inference.prediction.gender.value
```

### Names

**`given_names`** (Array< Field >): List of passport owner's given names.

```ruby
result.document.inference.prediction.given_names.each do |name|
  puts name
end
```

**`surname`** (Field): Passport's owner surname.

```ruby
puts result.document.inference.prediction.surname.value
```

### ID

**`id_number`** (Field): Passport identification number.

```ruby
puts result.document.inference.prediction.id_number.value
```

### Machine-Readable Zone

**`mrz1`** (Field): Passport first line of machine-readable zone.

```ruby
puts result.document.inference.prediction.mrz1.value
```

**`mrz2`** (Field): Passport second line of machine-readable zone.

```ruby
puts result.document.inference.prediction.mrz2.value
```

**`mrz`** (Field): Reconstructed passport full machine-readable zone from mrz1 and mrz2.

```ruby
puts result.document.inference.prediction.mrz.value
```

## Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)
