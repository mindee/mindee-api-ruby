---
title: Ruby Client Library - Financial Document
category: 622b805aaec68102ea7fcbc2
slug: ruby-financial-document-ocr
parentDoc: 67b49df15b843f3fa9cd622b
---
The Ruby Client Library supports the [Financial Document API](https://platform.mindee.com/mindee/financial_document).


> 📝 Product Specs
>
> | Specification                  | Details                                            |
> | ------------------------------ | -------------------------------------------------- |
> | Endpoint                       | `financial_document`                               |
> | Recommended Version            | `v1.11`                                            |
> | Supports Polling/Webhooks      | ✔️ Yes                                             |
> | Support Synchronous HTTP Calls | ✔️ Yes                                             |
> | Geography                      | 🌐 Global                                          |

> 🔐 Polling Limitations
>
> | Setting                         | Parameter name          | Value       |
> | ------------------------------- | ----------------------- | ----------- |
> | Initial Delay Before Polling    | `initial_delay_seconds` | 2 seconds   |
> | Default Delay Between Calls     | `delay_sec`             | 1.5 seconds |
> | Polling Attempts Before Timeout | `max_retries`           | 80 retries  |


Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/financial_document/default_sample.jpg), we are going to illustrate how to extract the data that we want using the
Ruby Client Library.
![Financial Document sample](https://github.com/mindee/client-lib-test-data/blob/main/products/financial_document/default_sample.jpg?raw=true)

# Quick-Start
```rb
#
# Install the Ruby client library by running:
# gem install mindee
#

require 'mindee'

# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')

# Parse the file
result = mindee_client.parse(
  input_source,
  Mindee::Product::FinancialDocument::FinancialDocumentV1
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
:Mindee ID: f469a24d-3875-4a83-ad43-e0d5aa9da604
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/financial_document v1.11
:Rotation applied: Yes

Prediction
==========
:Locale: en-US; en; US; USD;
:Invoice Number: INT-001
:Purchase Order Number: 2412/2019
:Receipt Number:
:Document Number: INT-001
:Reference Numbers: 2412/2019
:Purchase Date: 2019-11-02
:Due Date: 2019-11-17
:Payment Date: 2019-11-17
:Total Net: 195.00
:Total Amount: 204.75
:Taxes:
  +---------------+--------+----------+---------------+
  | Base          | Code   | Rate (%) | Amount        |
  +===============+========+==========+===============+
  |               |        | 5.00     | 9.75          |
  +---------------+--------+----------+---------------+
:Supplier Payment Details:
:Supplier Name: JOHN SMITH
:Supplier Company Registrations:
:Supplier Address: 4490 Oak Drive Albany, NY 12210
:Supplier Phone Number:
:Customer Name: JESSIE M HORNE
:Supplier Website:
:Supplier Email:
:Customer Company Registrations:
:Customer Address: 2019 Redbud Drive New York, NY 10011
:Customer ID: 1234567890
:Shipping Address: 2019 Redbud Drive New York, NY 10011
:Billing Address: 4312 Wood Road New York, NY 10031
:Document Type: INVOICE
:Purchase Subcategory:
:Purchase Category: miscellaneous
:Total Tax: 9.75
:Tip and Gratuity:
:Purchase Time:
:Line Items:
  +--------------------------------------+--------------+----------+------------+--------------+--------------+-----------------+------------+
  | Description                          | Product code | Quantity | Tax Amount | Tax Rate (%) | Total Amount | Unit of measure | Unit Price |
  +======================================+==============+==========+============+==============+==============+=================+============+
  | Front and rear brake cables          |              | 1.00     |            |              | 100.00       |                 | 100.00     |
  +--------------------------------------+--------------+----------+------------+--------------+--------------+-----------------+------------+
  | New set of pedal arms                |              | 2.00     |            |              | 50.00        |                 | 25.00      |
  +--------------------------------------+--------------+----------+------------+--------------+--------------+-----------------+------------+
  | Labor 3hrs                           |              | 3.00     |            |              | 45.00        |                 | 15.00      |
  +--------------------------------------+--------------+----------+------------+--------------+--------------+-----------------+------------+

Page Predictions
================

Page 0
------
:Locale: en-US; en; US; USD;
:Invoice Number: INT-001
:Purchase Order Number: 2412/2019
:Receipt Number:
:Document Number: INT-001
:Reference Numbers: 2412/2019
:Purchase Date: 2019-11-02
:Due Date: 2019-11-17
:Payment Date: 2019-11-17
:Total Net: 195.00
:Total Amount: 204.75
:Taxes:
  +---------------+--------+----------+---------------+
  | Base          | Code   | Rate (%) | Amount        |
  +===============+========+==========+===============+
  |               |        | 5.00     | 9.75          |
  +---------------+--------+----------+---------------+
:Supplier Payment Details:
:Supplier Name: JOHN SMITH
:Supplier Company Registrations:
:Supplier Address: 4490 Oak Drive Albany, NY 12210
:Supplier Phone Number:
:Customer Name: JESSIE M HORNE
:Supplier Website:
:Supplier Email:
:Customer Company Registrations:
:Customer Address: 2019 Redbud Drive New York, NY 10011
:Customer ID: 1234567890
:Shipping Address: 2019 Redbud Drive New York, NY 10011
:Billing Address: 4312 Wood Road New York, NY 10031
:Document Type: INVOICE
:Purchase Subcategory:
:Purchase Category: miscellaneous
:Total Tax: 9.75
:Tip and Gratuity:
:Purchase Time:
:Line Items:
  +--------------------------------------+--------------+----------+------------+--------------+--------------+-----------------+------------+
  | Description                          | Product code | Quantity | Tax Amount | Tax Rate (%) | Total Amount | Unit of measure | Unit Price |
  +======================================+==============+==========+============+==============+==============+=================+============+
  | Front and rear brake cables          |              | 1.00     |            |              | 100.00       |                 | 100.00     |
  +--------------------------------------+--------------+----------+------------+--------------+--------------+-----------------+------------+
  | New set of pedal arms                |              | 2.00     |            |              | 50.00        |                 | 25.00      |
  +--------------------------------------+--------------+----------+------------+--------------+--------------+-----------------+------------+
  | Labor 3hrs                           |              | 3.00     |            |              | 45.00        |                 | 15.00      |
  +--------------------------------------+--------------+----------+------------+--------------+--------------+-----------------+------------+
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
The classification field `ClassificationField` does not implement all the basic `Field` attributes. It only implements
**value**, **confidence** and **page_id**.

> Note: a classification field's `value is always a `String`.


### Company Registration Field
Aside from the basic `Field` attributes, the company registration field `CompanyRegistrationField` also implements the
following:

* **type** (`String`): the type of company.

### Date Field
Aside from the basic `Field` attributes, the date field `DateField` also implements the following:

* **date_object** (`Date`): an accessible representation of the value as a JavaScript object.

### Locale Field
The locale field `LocaleField` only implements the **value**, **confidence** and **page_id** base `Field` attributes,
but it comes with its own:

* **language** (`String`): ISO 639-1 language code (e.g.: `en` for English). Can be `nil`.
* **country** (`String`): ISO 3166-1 alpha-2 or ISO 3166-1 alpha-3 code for countries (e.g.: `GRB` or `GB` for "Great
Britain"). Can be `nil`.
* **currency** (`String`): ISO 4217 code for currencies (e.g.: `USD` for "US Dollars"). Can be `nil`.

### Payment Details Field
Aside from the basic `Field` attributes, the payment details field `PaymentDetailsField` also implements the
following:

* **account_number** (`String`): number of an account, expressed as a string. Can be `nil`.
* **iban** (`String`): International Bank Account Number. Can be `nil`.
* **routing_number** (`String`): routing number of an account. Can be `nil`.
* **swift** (`String`): the account holder's bank's SWIFT Business Identifier Code (BIC). Can be `nil`.

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

### Taxes Field
#### Tax
Aside from the basic `Field` attributes, the tax field `TaxField` also implements the following:

* **rate** (`Float`): the tax rate applied to an item can be expressed as a percentage. Can be `nil`.
* **code** (`String`): tax code (or equivalent, depending on the origin of the document). Can be `nil`.
* **base** (`Float`): base amount used for the tax. Can be `nil`.

> Note: currently `TaxField` is not used on its own, and is accessed through a parent `Taxes` object, an array-like
structure.

#### Taxes (Array)
The `Taxes` field represents an array-like collection of `TaxField` objects. As it is the representation of several
objects, it has access to a custom `to_s` method that can render a `TaxField` object as a table line.

## Specific Fields
Fields which are specific to this product; they are not used in any other product.

### Line Items Field
List of line item details.

A `FinancialDocumentV1LineItem` implements the following attributes:
      
* `description` (String): The item description.
* `product_code` (String): The product code referring to the item.
* `quantity` (Float): The item quantity
* `tax_amount` (Float): The item tax amount.
* `tax_rate` (Float): The item tax rate in percentage.
* `total_amount` (Float): The item total amount.
* `unit_measure` (String): The item unit of measure.
* `unit_price` (Float): The item unit price.

# Attributes
The following fields are extracted for Financial Document V1:

## Billing Address
**billing_address** ([StringField](#string-field)): The customer's address used for billing.

```rb
puts result.document.inference.prediction.billing_address.value
```

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

## Customer Address
**customer_address** ([StringField](#string-field)): The address of the customer.

```rb
puts result.document.inference.prediction.customer_address.value
```

## Customer Company Registrations
**customer_company_registrations** (Array<[CompanyRegistrationField](#company-registration-field)>): List of company registrations associated to the customer.

```rb
result.document.inference.prediction.customer_company_registrations do |customer_company_registrations_elem|
  puts customer_company_registrations_elem.value
end
```

## Customer ID
**customer_id** ([StringField](#string-field)): The customer account number or identifier from the supplier.

```rb
puts result.document.inference.prediction.customer_id.value
```

## Customer Name
**customer_name** ([StringField](#string-field)): The name of the customer.

```rb
puts result.document.inference.prediction.customer_name.value
```

## Purchase Date
**date** ([DateField](#date-field)): The date the purchase was made.

```rb
puts result.document.inference.prediction.date.value
```

## Document Number
**document_number** ([StringField](#string-field)): The document number or identifier.

```rb
puts result.document.inference.prediction.document_number.value
```

## Document Type
**document_type** ([ClassificationField](#classification-field)): One of: 'INVOICE', 'CREDIT NOTE', 'CREDIT CARD RECEIPT', 'EXPENSE RECEIPT'.

#### Possible values include:
 - INVOICE
 - CREDIT NOTE
 - CREDIT CARD RECEIPT
 - EXPENSE RECEIPT

```rb
puts result.document.inference.prediction.document_type.value
```

## Due Date
**due_date** ([DateField](#date-field)): The date on which the payment is due.

```rb
puts result.document.inference.prediction.due_date.value
```

## Invoice Number
**invoice_number** ([StringField](#string-field)): The invoice number or identifier only if document is an invoice.

```rb
puts result.document.inference.prediction.invoice_number.value
```

## Line Items
**line_items** (Array<[FinancialDocumentV1LineItem](#line-items-field)>): List of line item details.

```rb
result.document.inference.prediction.line_items do |line_items_elem|
  puts line_items_elem.value
end
```

## Locale
**locale** ([LocaleField](#locale-field)): The locale detected on the document.

```rb
puts result.document.inference.prediction.locale.value
```

## Payment Date
**payment_date** ([DateField](#date-field)): The date on which the payment is due / fullfilled.

```rb
puts result.document.inference.prediction.payment_date.value
```

## Purchase Order Number
**po_number** ([StringField](#string-field)): The purchase order number.

```rb
puts result.document.inference.prediction.po_number.value
```

## Receipt Number
**receipt_number** ([StringField](#string-field)): The receipt number or identifier only if document is a receipt.

```rb
puts result.document.inference.prediction.receipt_number.value
```

## Reference Numbers
**reference_numbers** (Array<[StringField](#string-field)>): List of Reference numbers, including PO number.

```rb
result.document.inference.prediction.reference_numbers do |reference_numbers_elem|
  puts reference_numbers_elem.value
end
```

## Shipping Address
**shipping_address** ([StringField](#string-field)): The customer's address used for shipping.

```rb
puts result.document.inference.prediction.shipping_address.value
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
result.document.inference.prediction.supplier_company_registrations do |supplier_company_registrations_elem|
  puts supplier_company_registrations_elem.value
end
```

## Supplier Email
**supplier_email** ([StringField](#string-field)): The email of the supplier or merchant.

```rb
puts result.document.inference.prediction.supplier_email.value
```

## Supplier Name
**supplier_name** ([StringField](#string-field)): The name of the supplier or merchant.

```rb
puts result.document.inference.prediction.supplier_name.value
```

## Supplier Payment Details
**supplier_payment_details** (Array<[PaymentDetailsField](#payment-details-field)>): List of payment details associated to the supplier.

```rb
result.document.inference.prediction.supplier_payment_details do |supplier_payment_details_elem|
  puts supplier_payment_details_elem.value
  puts supplier_payment_details_elem.rate
  puts supplier_payment_details_elem.code
  puts supplier_payment_details_elem.basis
end
```

## Supplier Phone Number
**supplier_phone_number** ([StringField](#string-field)): The phone number of the supplier or merchant.

```rb
puts result.document.inference.prediction.supplier_phone_number.value
```

## Supplier Website
**supplier_website** ([StringField](#string-field)): The website URL of the supplier or merchant.

```rb
puts result.document.inference.prediction.supplier_website.value
```

## Taxes
**taxes** (Array<[TaxField](#taxes-field)>): List of tax lines information.

```rb
result.document.inference.prediction.taxes do |taxes_elem|
  puts taxes_elem.value
end
```

## Purchase Time
**time** ([StringField](#string-field)): The time the purchase was made.

```rb
puts result.document.inference.prediction.time.value
```

## Tip and Gratuity
**tip** ([AmountField](#amount-field)): The total amount of tip and gratuity

```rb
puts result.document.inference.prediction.tip.value
```

## Total Amount
**total_amount** ([AmountField](#amount-field)): The total amount paid: includes taxes, tips, fees, and other charges.

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
