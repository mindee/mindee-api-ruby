The Ruby  OCR SDK supports the [receipt API](https://developers.mindee.com/docs/receipt-ocr) for extracting data from receipts.

Using this sample below, we are going to illustrate how to extract the data that we want using the OCR SDK.

![sample receipt](https://raw.githubusercontent.com/mindee/client-lib-test-data/main/receipt/receipt.jpg)

## Quick Start
```ruby
require 'mindee'

# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')

# Parse the file
result = mindee_client.parse(
  input_source,
  Mindee::Product::Receipt::ReceiptV5
)

# Print a full summary of the parsed data in RST format
puts result.document
```

Output:
```
Receipt V5 Prediction
=====================
:Filename:
:Expense Locale: en-GB; en; GB; GBP;
:Expense Category: food
:Expense Sub Category: restaurant
:Document Type: EXPENSE RECEIPT
:Purchase Date: 2016-02-26
:Purchase Time: 15:20
:Total Amount: 10.20
:Total Excluding Taxes: 8.50
:Total Tax: 1.70
:Tip and Gratuity:
:Taxes:
  +---------------+--------+----------+---------------+
  | Base          | Code   | Rate (%) | Amount        |
  +===============+========+==========+===============+
  | 8.50          | VAT    | 20.00    | 1.70          |
  +---------------+--------+----------+---------------+
:Supplier Name: CLACHAN
:Supplier Company Registrations: 232153895
:Supplier Address: 34 kingley street w1b 5qh
:Supplier Phone Number: 02074940834
:Line Items:
  +--------------------------------------+----------+--------------+------------+
  | Description                          | Quantity | Total Amount | Unit Price |
  +======================================+==========+==============+============+
  | meantime pale                        | 2.00     | 10.20        |            |
  +--------------------------------------+----------+--------------+------------+
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
Depending on the field type specified, additional attributes can be extracted in the `Receipt` object.

Using the above sample, the following are the basic fields that can be extracted:

- [Quick Start](#quick-start)
- [Fields](#fields)
- [Attributes](#attributes)
  - [Category](#category)
  - [Date](#date)
  - [Locale](#locale)
  - [Supplier Information](#supplier-information)
  - [Taxes](#taxes)
  - [Time](#time)
  - [Totals](#totals)
- [Questions?](#questions)


### Category
* **`category`** (Field): Receipt category as seen on the receipt.
  The following categories are supported: toll, food, parking, transport, accommodation, gasoline, miscellaneous.

```ruby
puts result.document.inference.prediction.category.value
```


### Date
Date fields:

* contain the `date_object` attribute, which is a standard Ruby [date object](https://ruby-doc.org/stdlib-2.7.1/libdoc/date/rdoc/Date.html)
* have a `value` attribute which is the [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) representation of the date.

The following date fields are available:

* **`date`**: Date the receipt was issued

```ruby
puts result.document.inference.prediction.date.value
```


### Locale
**`locale`** (Locale): Locale information.

* `locale.value` (String): Locale with country and language codes.
```ruby
puts result.document.inference.prediction.locale
```

* `locale.language` (String): Language code in [ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1) format as seen on the document.
* 
```ruby
puts result.document.inference.prediction.locale.language
```

* `locale.currency` (String): Currency code in [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) format as seen on the document.

```ruby
puts result.document.inference.prediction.locale.currency
```

* `locale.country` (String): Country code in [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1) alpha-2 format as seen on the document.

```ruby
puts result.document.inference.prediction.locale.country
```

### Supplier Information
* **`supplier_name`** (Field): Supplier name as written in the receipt.

```ruby
puts result.document.inference.prediction.supplier_name.value
```


### Taxes
**`taxes`** (Array< TaxField >): Contains tax fields as seen on the receipt.

* `value` (Float): The tax amount.
```ruby
# Show the amount of the first tax
puts result.document.inference.prediction.taxes[0].value
```

* `code` (String): The tax code (HST, GST... for Canadian; City Tax, State tax for US, etc..).
```ruby
# Show the code of the first tax
puts result.document.inference.prediction.taxes[0].code
```

* `rate` (Float): The tax rate.
```ruby
# Show the rate of the first tax
puts result.document.inference.prediction.taxes[0].rate
```

### Time
* **`time`**: Time of purchase as seen on the receipt
    * `value` (string): Time of purchase with 24 hours formatting (hh:mm).

```ruby
puts result.document.inference.prediction.time.value
```

### Totals
* **`total_amount`** (Field): Total amount including taxes

```ruby
puts result.document.inference.prediction.total_amount.value
```

* **`total_net`** (Field): Total amount paid excluding taxes

```ruby
puts result.document.inference.prediction.total_net.value
```

* **`total_tax`** (Field): Total tax value from tax lines

```ruby
puts result.document.inference.prediction.total_tax.value
```

## Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)
