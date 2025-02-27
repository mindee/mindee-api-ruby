---
title: Ruby Client Library - FR Bank Statement
category: 622b805aaec68102ea7fcbc2
slug: ruby-fr-bank-statement-ocr
parentDoc: 67b49e29a2cd6f08d69a40d8
---
The Ruby Client Library supports the [Bank Statement API](https://platform.mindee.com/mindee/bank_statement_fr).


> 📝 Product Specs
>
> | Specification                  | Details                                            |
> | ------------------------------ | -------------------------------------------------- |
> | Endpoint Name                  | `bank_statement_fr`                                |
> | Recommended Version            | `v2.0`                                             |
> | Supports Polling/Webhooks      | ✔️ Yes                                             |
> | Support Synchronous HTTP Calls | ❌ No                                              |
> | Geography                      | 🇫🇷 France                                          |

> 🔐 Polling Limitations
>
> | Setting                         | Parameter name          | Default Value |
> | ------------------------------- | ----------------------- | ------------- |
> | Initial Delay Before Polling    | `initial_delay_seconds` | 2 seconds     |
> | Default Delay Between Calls     | `delay_sec`             | 1.5 seconds   |
> | Polling Attempts Before Timeout | `max_retries`           | 80 retries    |


Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/bank_statement_fr/default_sample.jpg),
we are going to illustrate how to extract the data that we want using the Ruby Client Library.
![Bank Statement sample](https://github.com/mindee/client-lib-test-data/blob/main/products/bank_statement_fr/default_sample.jpg?raw=true)

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
  Mindee::Product::FR::BankStatement::BankStatementV2,
  enqueue: false
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
:Mindee ID: 3c1811c0-9876-45ae-91ad-c2e9cd75dd83
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/bank_statement_fr v2.0
:Rotation applied: Yes

Prediction
==========
:Account Number: XXXXXXXXXXXXXX
:Bank Name: Banque lafinancepourtous
:Bank Address: 1 rue de la Banque, 100210 Cassette
:Client Names: Karine Plume
:Client Address: 1 rue des Cigales, 100210 Cassette
:Statement Date: 2002-02-28
:Statement Start Date: 2002-02-01
:Statement End Date: 2002-02-28
:Opening Balance: 22.15
:Closing Balance: -278.96
:Transactions:
  +------------+------------+--------------------------------------+
  | Amount     | Date       | Description                          |
  +============+============+======================================+
  | 1240.00    | 2002-02-01 | Virement salaire                     |
  +------------+------------+--------------------------------------+
  | -520.00    | 2002-02-02 | Virement loyer                       |
  +------------+------------+--------------------------------------+
  | -312.00    | 2002-02-03 | Débit Carte nºxxxx                   |
  +------------+------------+--------------------------------------+
  | 12.47      | 2002-02-04 | Virement CPAM                        |
  +------------+------------+--------------------------------------+
  | 65.00      | 2002-02-05 | Virement APL                         |
  +------------+------------+--------------------------------------+
  | -110.00    | 2002-02-07 | Débit Carte nxxxxxxxxxxxxxxxx        |
  +------------+------------+--------------------------------------+
  | -3.30      | 2002-02-08 | Cotisation mensuelle carte bancaire  |
  +------------+------------+--------------------------------------+
  | -120.00    | 2002-02-09 | Chèque n° xxxxxx98                   |
  +------------+------------+--------------------------------------+
  | -60.00     | 2002-02-09 | Retrait espèces DAB                  |
  +------------+------------+--------------------------------------+
  | -55.00     | 2002-02-15 | Chèque n° xxxxxx99                   |
  +------------+------------+--------------------------------------+
  | -80.00     | 2002-02-16 | Prélèvement supercrédit              |
  +------------+------------+--------------------------------------+
  | -120.00    | 2002-02-17 | Chèque n° xxxxx 100                  |
  +------------+------------+--------------------------------------+
  | -163.25    | 2002-02-20 | Débit Carte nºxxxxxxxxxxxxx          |
  +------------+------------+--------------------------------------+
  | -25.50     | 2002-02-21 | Débit Carte n°xxxxxxxxxxxxxxxxxx     |
  +------------+------------+--------------------------------------+
  | -30.00     | 2002-02-24 | Prélèvement Opérateur téléphonique   |
  +------------+------------+--------------------------------------+
  | -6.53      | 2002-02-25 | Agios                                |
  +------------+------------+--------------------------------------+
  | -13.00     | 2002-02-28 | Frais irrégularités et incidents ... |
  +------------+------------+--------------------------------------+
:Total Debits: 1618.58
:Total Credits: 1339.62
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

### Date Field
Aside from the basic `Field` attributes, the date field `DateField` also implements the following:

* **date_object** (`Date`): an accessible representation of the value as a JavaScript object.

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

## Specific Fields
Fields which are specific to this product; they are not used in any other product.

### Transactions Field
The list of values that represent the financial transactions recorded in a bank statement.

A `BankStatementV2Transaction` implements the following attributes:

* `amount` (Float): The monetary amount of the transaction.
* `date` (String): The date on which the transaction occurred.
* `description` (String): The additional information about the transaction.

# Attributes
The following fields are extracted for Bank Statement V2:

## Account Number
**account_number** ([StringField](#string-field)): The unique identifier for a customer's account in the bank's system.

```rb
puts result.document.inference.prediction.account_number.value
```

## Bank Address
**bank_address** ([StringField](#string-field)): The physical location of the bank where the statement was issued.

```rb
puts result.document.inference.prediction.bank_address.value
```

## Bank Name
**bank_name** ([StringField](#string-field)): The name of the bank that issued the statement.

```rb
puts result.document.inference.prediction.bank_name.value
```

## Client Address
**client_address** ([StringField](#string-field)): The address of the client associated with the bank statement.

```rb
puts result.document.inference.prediction.client_address.value
```

## Client Names
**client_names** (Array<[StringField](#string-field)>): The name of the clients who own the bank statement.

```rb
result.document.inference.prediction.client_names do |client_names_elem|
  puts client_names_elem.value
end
```

## Closing Balance
**closing_balance** ([AmountField](#amount-field)): The final amount of money in the account at the end of the statement period.

```rb
puts result.document.inference.prediction.closing_balance.value
```

## Opening Balance
**opening_balance** ([AmountField](#amount-field)): The initial amount of money in an account at the start of the period.

```rb
puts result.document.inference.prediction.opening_balance.value
```

## Statement Date
**statement_date** ([DateField](#date-field)): The date on which the bank statement was generated.

```rb
puts result.document.inference.prediction.statement_date.value
```

## Statement End Date
**statement_end_date** ([DateField](#date-field)): The date when the statement period ends.

```rb
puts result.document.inference.prediction.statement_end_date.value
```

## Statement Start Date
**statement_start_date** ([DateField](#date-field)): The date when the bank statement period begins.

```rb
puts result.document.inference.prediction.statement_start_date.value
```

## Total Credits
**total_credits** ([AmountField](#amount-field)): The total amount of money deposited into the account.

```rb
puts result.document.inference.prediction.total_credits.value
```

## Total Debits
**total_debits** ([AmountField](#amount-field)): The total amount of money debited from the account.

```rb
puts result.document.inference.prediction.total_debits.value
```

## Transactions
**transactions** (Array<[BankStatementV2Transaction](#transactions-field)>): The list of values that represent the financial transactions recorded in a bank statement.

```rb
result.document.inference.prediction.transactions do |transactions_elem|
  puts transactions_elem.value
end
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
