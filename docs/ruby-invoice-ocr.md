The Ruby OCR SDK supports the [invoice API](https://developers.mindee.com/docs/invoice-ocr) for extracting data from invoices.

Using this sample below, we are going to illustrate how to extract the data that we want using the OCR SDK.

![sample invoice](https://raw.githubusercontent.com/mindee/client-lib-test-data/main/invoice/invoice_1p.jpg)

## Quick Start
```ruby
# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk and parse it
doc = mindee_client.doc_from_path('/path/to/the/file.ext')

# Keep the product's class in a variable to keep the code DRY
doc_class = Mindee::Product::Invoice::InvoiceV4

# Send our document
result = mindee_client.parse(doc, doc_class)

# Print a full summary of the parsed data in RST format
puts result.document
```

Output:
```
Invoice V4 Prediction
=====================
:Filename:
:Locale: fr; fr; EUR;
:Invoice number: 0042004801351
:Reference numbers: AD29094
:Invoice date: 2020-02-17
:Invoice due date: 2020-02-17
:Supplier name: TURNPIKE DESIGNS CO.
:Supplier address: 156 University Ave, Toronto ON, Canada M5H 2H7
:Supplier company registrations: 501124705; FR33501124705
:Supplier payment details: FR7640254025476501124705368;
:Customer name: JIRO DOI
:Customer company registrations: FR00000000000; 111222333
:Customer address: 1954 Bloon Street West Toronto, ON, M6P 3K9 Canada
:Line Items:
  Code           | QTY    | Price   | Amount   | Tax (Rate)       | Description
                 |        |         | 4.31     |  (2.10%)         | PQ20 ETIQ ULTRA RESIS METAXXDC
                 | 1.00   | 65.00   | 75.00    | 10.00            | Platinum web hosting package Dow...
  XXX81125600010 | 1.00   | 250.01  | 275.51   | 25.50 (10.20%)   | a long string describing the ite...
  ABC456         | 200.30 | 8.101   | 1622.63  | 121.70 (7.50%)   | Liquid perfection
                 |        |         |          |                  | CARTOUCHE L NR BROTHER TN247BK
:Taxes:
  +---------------+--------+----------+---------------+
  | Base          | Code   | Rate (%) | Amount        |
  +===============+========+==========+===============+
  |               |        | 20.00    | 97.98         |
  +---------------+--------+----------+---------------+
:Total tax: 97.98
:Total net: 489.97
:Total amount: 587.95
```

> 📘 **Info**
>
> Line item descriptions are truncated here only for display purposes.
> The full text is available in the [details](#line-items).

## Fields
Each prediction object contains a set of different fields.
Each `Field` object contains at a minimum the following attributes:

* `value` (String or Float depending on the field type): corresponds to the field value. Can be `nil` if no value was extracted.
* `confidence` (Float): the confidence score of the field prediction.
* `bounding_box` (Array< Array< Float > >): contains exactly 4 relative vertices coordinates (points) of a right rectangle containing the field in the document.
* `polygon` (Array< Array< Float > >): contains the relative vertices coordinates (points) of a polygon containing the field in the image.
* `reconstructed` (Boolean): True if the field was reconstructed or computed using other fields.


## Attributes
Depending on the field type, there might be additional attributes that will be extracted in the `Invoice` object.

Using the above sample, the following are the basic fields that can be extracted:

- [Quick Start](#quick-start)
- [Fields](#fields)
- [Attributes](#attributes)
  - [Customer Information](#customer-information)
  - [Dates](#dates)
  - [Locale](#locale)
  - [Supplier Information](#supplier-information)
  - [Taxes](#taxes)
  - [Totals](#totals)
  - [Line items](#line-items)
- [Questions?](#questions)


### Customer Information
**`customer_name`** (Field): Customer's name

```ruby
puts result.document.inference.prediction.customer_name.value
```

**`customer_address`** (Field): Customer's postal address

```ruby
puts result.document.inference.prediction.customer_address.value
```

**`customer_company_registrations`** (Array<CompanyRegistration>): Customer's company registration

```ruby
result.document.inference.prediction.customer_company_registrations.each do |registration|
  puts registration.value
  puts registration.type
end
```

### Dates
Date fields:

* contain the `date_object` attribute, which is a standard Ruby [date object](https://ruby-doc.org/stdlib-2.7.1/libdoc/date/rdoc/Date.html)
* have a `value` attribute which is the [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) representation of the date.

The following date fields are available:

**`date`**: Date the invoice was issued

```ruby
puts result.document.inference.prediction.date.value
```

**`due_date`**: Payment due date of the invoice.

```ruby
puts result.document.inference.prediction.due_date.value
```

### Locale
**`locale`** [Locale]: Locale information.

* `locale.language` (String): Language code in [ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1) format as seen on the document.
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

**`supplier_name`**: Supplier name as written in the invoice (logo or supplier Info).

```ruby
puts result.document.inference.prediction.supplier_name.value
```

**`supplier_address`**: Supplier address as written in the invoice.

```ruby
puts result.document.inference.prediction.supplier_address.value
```

**`supplier__payment_details`** (Array< PaymentDetails >): List of invoice's supplier payment details.
Each object in the list contains extra attributes:

* `iban` (String)
```ruby
# Show the IBAN of the first payment
puts result.document.inference.prediction.supplier_payment_details[0].iban
```

* `swift` (String)
```ruby
# Show the SWIFT of the first payment
puts result.document.inference.prediction.supplier_payment_details[0].swift
```

* `routing_number` (String)
```ruby
# Show the routing number of the first payment
puts result.document.inference.prediction.supplier_payment_details[0].routing_number
```

* `account_number` (String)
```ruby
# Show the account number of the first payment
puts result.document.inference.prediction.supplier_payment_details[0].account_number
```

**`supplier_company_registrations`** (Array< CompanyRegistration >):
List of detected supplier's company registration numbers.
Each object in the list contains an extra attribute:

* `type` (String): Type of company registration number among predefined categories.
```ruby
result.document.inference.prediction.supplier_company_registrations.each do |registration|
  puts registration.value
  puts registration.type
end
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

### Totals

**`total_amount`** (Field): Total amount including taxes.

```ruby
puts result.document.inference.prediction.total_amount.value
```

**`total_net`** (Field): Total amount excluding taxes.

```ruby
puts result.document.inference.prediction.total_net.value
```

**`total_tax`** (Field): Total tax value from tax lines.

```ruby
puts result.document.inference.prediction.total_tax.value
```

### Line items

**`line_items`** (Array<InvoiceLineItem>): Line items details.
Each object in the list contains:

* `product_code` (String)
* `description` (String)
* `quantity` (Float)
* `unit_price` (Float)
* `total_amount` (Float)
* `tax_rate` (Float)
* `tax_amount` (Float)
* `confidence` (Float)
* `page_id` (Integer)
* `polygon` (Polygon)

```ruby
result.document.inference.prediction.line_items.each do |line_item|
  pp line_item
end
```

## Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)