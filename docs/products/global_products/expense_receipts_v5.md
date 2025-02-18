---
title: Receipt OCR Ruby
category: 622b805aaec68102ea7fcbc2
slug: ruby-receipt-ocr
parentDoc: 67b49df15b843f3fa9cd622b
---
The Ruby OCR SDK supports the [Receipt API](https://platform.mindee.com/mindee/expense_receipts).

Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/expense_receipts/default_sample.jpg), we are going to illustrate how to extract the data that we want using the OCR SDK.
![Receipt sample](https://github.com/mindee/client-lib-test-data/blob/main/products/expense_receipts/default_sample.jpg?raw=true)

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
  Mindee::Product::Receipt::ReceiptV5
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
:Mindee ID: d96fb043-8fb8-4adc-820c-387aae83376d
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/expense_receipts v5.3
:Rotation applied: Yes

Prediction
==========
:Expense Locale: en-GB; en; GB; GBP;
:Purchase Category: food
:Purchase Subcategory: restaurant
:Document Type: EXPENSE RECEIPT
:Purchase Date: 2016-02-26
:Purchase Time: 15:20
:Total Amount: 10.20
:Total Net: 8.50
:Total Tax: 1.70
:Tip and Gratuity:
:Taxes:
  +---------------+--------+----------+---------------+
  | Base          | Code   | Rate (%) | Amount        |
  +===============+========+==========+===============+
  | 8.50          | VAT    | 20.00    | 1.70          |
  +---------------+--------+----------+---------------+
:Supplier Name: Clachan
:Supplier Company Registrations: Type: VAT NUMBER, Value: 232153895
                                 Type: VAT NUMBER, Value: 232153895
:Supplier Address: 34 Kingley Street W1B 50H
:Supplier Phone Number: 02074940834
:Receipt Number: 54/7500
:Line Items:
  +--------------------------------------+----------+--------------+------------+
  | Description                          | Quantity | Total Amount | Unit Price |
  +======================================+==========+==============+============+
  | Meantime Pale                        | 2.00     | 10.20        |            |
  +--------------------------------------+----------+--------------+------------+

Page Predictions
================

Page 0
------
:Expense Locale: en-GB; en; GB; GBP;
:Purchase Category: food
:Purchase Subcategory: restaurant
:Document Type: EXPENSE RECEIPT
:Purchase Date: 2016-02-26
:Purchase Time: 15:20
:Total Amount: 10.20
:Total Net: 8.50
:Total Tax: 1.70
:Tip and Gratuity:
:Taxes:
  +---------------+--------+----------+---------------+
  | Base          | Code   | Rate (%) | Amount        |
  +===============+========+==========+===============+
  | 8.50          | VAT    | 20.00    | 1.70          |
  +---------------+--------+----------+---------------+
:Supplier Name: Clachan
:Supplier Company Registrations: Type: VAT NUMBER, Value: 232153895
                                 Type: VAT NUMBER, Value: 232153895
:Supplier Address: 34 Kingley Street W1B 50H
:Supplier Phone Number: 02074940834
:Receipt Number: 54/7500
:Line Items:
  +--------------------------------------+----------+--------------+------------+
  | Description                          | Quantity | Total Amount | Unit Price |
  +======================================+==========+==============+============+
  | Meantime Pale                        | 2.00     | 10.20        |            |
  +--------------------------------------+----------+--------------+------------+
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


### Amount Field
The amount field `AmountField` only has one constraint: its **value** is a `Float` (or `nil`).


### Classification Field
The classification field `ClassificationField` does not implement all the basic `Field` attributes. It only implements **value**, **confidence** and **page_id**.

> Note: a classification field's `value is always a `String`.


### Company Registration Field
Aside from the basic `Field` attributes, the company registration field `CompanyRegistrationField` also implements the following:

* **type** (`String`): the type of company.

### Date Field
Aside from the basic `Field` attributes, the date field `DateField` also implements the following: 

* **date_object** (`Date`): an accessible representation of the value as a JavaScript object.

### Locale Field
The locale field `LocaleField` only implements the **value**, **confidence** and **page_id** base `Field` attributes, but it comes with its own:

* **language** (`String`): ISO 639-1 language code (e.g.: `en` for English). Can be `nil`.
* **country** (`String`): ISO 3166-1 alpha-2 or ISO 3166-1 alpha-3 code for countries (e.g.: `GRB` or `GB` for "Great Britain"). Can be `nil`.
* **currency** (`String`): ISO 4217 code for currencies (e.g.: `USD` for "US Dollars"). Can be `nil`.

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

### Taxes Field
#### Tax
Aside from the basic `Field` attributes, the tax field `TaxField` also implements the following:

* **rate** (`Float`): the tax rate applied to an item can be expressed as a percentage. Can be `nil`.
* **code** (`String`): tax code (or equivalent, depending on the origin of the document). Can be `nil`.
* **base** (`Float`): base amount used for the tax. Can be `nil`.

> Note: currently `TaxField` is not used on its own, and is accessed through a parent `Taxes` object, an array-like structure.

#### Taxes (Array)
The `Taxes` field represents an array-like collection of `TaxField` objects. As it is the representation of several objects, it has access to a custom `to_s` method that can render a `TaxField` object as a table line.

## Specific Fields
Fields which are specific to this product; they are not used in any other product.

### Line Items Field
List of line item details.

A `ReceiptV5LineItem` implements the following attributes:

* `description` (String): The item description.
* `quantity` (Float): The item quantity.
* `total_amount` (Float): The item total amount.
* `unit_price` (Float): The item unit price.

# Attributes
The following fields are extracted for Receipt V5:

## Purchase Category
**category** ([ClassificationField](#classification-field)): The purchase category among predefined classes.

#### Possible values include:
 - toll
 - food
 - parking
 - transport
 - accommodation
 - gasoline
 - telecom
 - miscellaneous

```rb
puts result.document.inference.prediction.category.value
```

## Purchase Date
**date** ([DateField](#date-field)): The date the purchase was made.

```rb
puts result.document.inference.prediction.date.value
```

## Document Type
**document_type** ([ClassificationField](#classification-field)): One of: 'CREDIT CARD RECEIPT', 'EXPENSE RECEIPT'.

#### Possible values include:
 - expense_receipt
 - credit_card_receipt

```rb
puts result.document.inference.prediction.document_type.value
```

## Line Items
**line_items** (Array<[ReceiptV5LineItem](#line-items-field)>): List of line item details.

```rb
for line_items_elem in result.document.inference.prediction.line_items do
  puts line_items_elem.value
end
```

## Expense Locale
**locale** ([LocaleField](#locale-field)): The locale detected on the document.

```rb
puts result.document.inference.prediction.locale.value
```

## Receipt Number
**receipt_number** ([StringField](#string-field)): The receipt number or identifier.

```rb
puts result.document.inference.prediction.receipt_number.value
```

## Purchase Subcategory
**subcategory** ([ClassificationField](#classification-field)): The purchase subcategory among predefined classes for transport and food.

#### Possible values include:
 - plane
 - taxi
 - train
 - restaurant
 - shopping

```rb
puts result.document.inference.prediction.subcategory.value
```

## Supplier Address
**supplier_address** ([StringField](#string-field)): The address of the supplier or merchant.

```rb
puts result.document.inference.prediction.supplier_address.value
```

## Supplier Company Registrations
**supplier_company_registrations** (Array<[CompanyRegistrationField](#company-registration-field)>): List of company registrations associated to the supplier.

```rb
for supplier_company_registrations_elem in result.document.inference.prediction.supplier_company_registrations do
  puts supplier_company_registrations_elem.value
end
```

## Supplier Name
**supplier_name** ([StringField](#string-field)): The name of the supplier or merchant.

```rb
puts result.document.inference.prediction.supplier_name.value
```

## Supplier Phone Number
**supplier_phone_number** ([StringField](#string-field)): The phone number of the supplier or merchant.

```rb
puts result.document.inference.prediction.supplier_phone_number.value
```

## Taxes
**taxes** (Array<[TaxField](#taxes-field)>): List of tax lines information.

```rb
for taxes_elem in result.document.inference.prediction.taxes do
  puts taxes_elem.value
end
```

## Purchase Time
**time** ([StringField](#string-field)): The time the purchase was made.

```rb
puts result.document.inference.prediction.time.value
```

## Tip and Gratuity
**tip** ([AmountField](#amount-field)): The total amount of tip and gratuity.

```rb
puts result.document.inference.prediction.tip.value
```

## Total Amount
**total_amount** ([AmountField](#amount-field)): The total amount paid: includes taxes, discounts, fees, tips, and gratuity.

```rb
puts result.document.inference.prediction.total_amount.value
```

## Total Net
**total_net** ([AmountField](#amount-field)): The net amount paid: does not include taxes, fees, and discounts.

```rb
puts result.document.inference.prediction.total_net.value
```

## Total Tax
**total_tax** ([AmountField](#amount-field)): The total amount of taxes.

```rb
puts result.document.inference.prediction.total_tax.value
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
