---
title: FR Energy Bill
category: 622b805aaec68102ea7fcbc2
slug: ruby-fr-energy-bill-ocr
parentDoc: 67b49e29a2cd6f08d69a40d8
---
The Ruby Client Library supports the [Energy Bill API](https://platform.mindee.com/mindee/energy_bill_fra).


> 📝 Product Specs
>
> | Specification                  | Details                                            |
> | ------------------------------ | -------------------------------------------------- |
> | Endpoint Name                  | `energy_bill_fra`                                  |
> | Recommended Version            | `v1.2`                                             |
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


Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/energy_bill_fra/default_sample.pdf),
we are going to illustrate how to extract the data that we want using the Ruby Client Library.
![Energy Bill sample](https://github.com/mindee/client-lib-test-data/blob/main/products/energy_bill_fra/default_sample.pdf?raw=true)

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
  Mindee::Product::FR::EnergyBill::EnergyBillV1
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
:Mindee ID: ff1f2ca8-4d29-44d8-a564-599a982a4ef7
:Filename: default_sample.pdf

Inference
#########
:Product: mindee/energy_bill_fra v1.2
:Rotation applied: Yes

Prediction
==========
:Invoice Number: 1234567890
:Contract ID: 9876543210
:Delivery Point: 98765432109876
:Invoice Date: 2021-01-29
:Due Date: 2021-02-15
:Total Before Taxes: 1241.03
:Total Taxes: 238.82
:Total Amount: 1479.85
:Energy Supplier:
  :Address: TSA 12345, 12345 DEMOCITY CEDEX
  :Name: EDF
:Energy Consumer:
  :Address: 123 RUE DE L'IMAGINAIRE, 75001 PARIS
  :Name: JOHN DOE
:Subscription:
  +--------------------------------------+------------+------------+----------+-----------+------------+
  | Description                          | End Date   | Start Date | Tax Rate | Total     | Unit Price |
  +======================================+============+============+==========+===========+============+
  | Abonnement électricité               | 2021-02-28 | 2021-01-01 | 5.50     | 59.00     | 29.50      |
  +--------------------------------------+------------+------------+----------+-----------+------------+
:Energy Usage:
  +-------------+--------------------------------------+------------+------------+----------+-----------+-----------------+------------+
  | Consumption | Description                          | End Date   | Start Date | Tax Rate | Total     | Unit of Measure | Unit Price |
  +=============+======================================+============+============+==========+===========+=================+============+
  | 8581.00     | Consommation électricité             | 2021-01-27 | 2020-11-28 | 20.00    | 898.43    | kWh             | 0.1047     |
  +-------------+--------------------------------------+------------+------------+----------+-----------+-----------------+------------+
:Taxes and Contributions:
  +--------------------------------------+------------+------------+----------+-----------+------------+
  | Description                          | End Date   | Start Date | Tax Rate | Total     | Unit Price |
  +======================================+============+============+==========+===========+============+
  | Contribution au Service Public de... | 2021-01-27 | 2020-11-28 | 20.00    | 193.07    | 0.0225     |
  +--------------------------------------+------------+------------+----------+-----------+------------+
  | Taxe Départementale sur la Conso ... | 2021-01-27 | 2020-11-28 | 20.00    | 13.98     | 0.003315   |
  +--------------------------------------+------------+------------+----------+-----------+------------+
  | Taxe Communale sur la Conso Final... | 2021-01-27 | 2020-11-28 | 20.00    | 28.56     | 0.006545   |
  +--------------------------------------+------------+------------+----------+-----------+------------+
  | Taxe Communale sur la Conso Final... | 2021-01-27 | 2020-11-28 | 20.00    | 27.96     | 0.00663    |
  +--------------------------------------+------------+------------+----------+-----------+------------+
:Meter Details:
  :Meter Number: 620
  :Meter Type: electricity
  :Unit of Power: 36kVA
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

### Energy Supplier Field
The company that supplies the energy.

A `EnergyBillV1EnergySupplier` implements the following attributes:

* `address` (String): The address of the energy supplier.
* `name` (String): The name of the energy supplier.
Fields which are specific to this product; they are not used in any other product.

### Energy Consumer Field
The entity that consumes the energy.

A `EnergyBillV1EnergyConsumer` implements the following attributes:

* `address` (String): The address of the energy consumer.
* `name` (String): The name of the energy consumer.
Fields which are specific to this product; they are not used in any other product.

### Subscription Field
The subscription details fee for the energy service.

A `EnergyBillV1Subscription` implements the following attributes:

* `description` (String): Description or details of the subscription.
* `end_date` (String): The end date of the subscription.
* `start_date` (String): The start date of the subscription.
* `tax_rate` (Float): The rate of tax applied to the total cost.
* `total` (Float): The total cost of subscription.
* `unit_price` (Float): The price per unit of subscription.
Fields which are specific to this product; they are not used in any other product.

### Energy Usage Field
Details of energy consumption.

A `EnergyBillV1EnergyUsage` implements the following attributes:

* `consumption` (Float): The price per unit of energy consumed.
* `description` (String): Description or details of the energy usage.
* `end_date` (String): The end date of the energy usage.
* `start_date` (String): The start date of the energy usage.
* `tax_rate` (Float): The rate of tax applied to the total cost.
* `total` (Float): The total cost of energy consumed.
* `unit` (String): The unit of measurement for energy consumption.

#### Possible values include:
 - kWh
 - m3
 - L
        
* `unit_price` (Float): The price per unit of energy consumed.
Fields which are specific to this product; they are not used in any other product.

### Taxes and Contributions Field
Details of Taxes and Contributions.

A `EnergyBillV1TaxesAndContribution` implements the following attributes:

* `description` (String): Description or details of the Taxes and Contributions.
* `end_date` (String): The end date of the Taxes and Contributions.
* `start_date` (String): The start date of the Taxes and Contributions.
* `tax_rate` (Float): The rate of tax applied to the total cost.
* `total` (Float): The total cost of Taxes and Contributions.
* `unit_price` (Float): The price per unit of Taxes and Contributions.
Fields which are specific to this product; they are not used in any other product.

### Meter Details Field
Information about the energy meter.

A `EnergyBillV1MeterDetail` implements the following attributes:

* `meter_number` (String): The unique identifier of the energy meter.
* `meter_type` (String): The type of energy meter.

#### Possible values include:
 - electricity
 - gas
 - water
 - None
        
* `unit` (String): The unit of power for energy consumption.

# Attributes
The following fields are extracted for Energy Bill V1:

## Contract ID
**contract_id** ([StringField](#string-field)): The unique identifier associated with a specific contract.

```rb
puts result.document.inference.prediction.contract_id.value
```

## Delivery Point
**delivery_point** ([StringField](#string-field)): The unique identifier assigned to each electricity or gas consumption point. It specifies the exact location where the energy is delivered.

```rb
puts result.document.inference.prediction.delivery_point.value
```

## Due Date
**due_date** ([DateField](#date-field)): The date by which the payment for the energy invoice is due.

```rb
puts result.document.inference.prediction.due_date.value
```

## Energy Consumer
**energy_consumer** ([EnergyBillV1EnergyConsumer](#energy-consumer-field)): The entity that consumes the energy.

```rb
puts result.document.inference.prediction.energy_consumer.value
```

## Energy Supplier
**energy_supplier** ([EnergyBillV1EnergySupplier](#energy-supplier-field)): The company that supplies the energy.

```rb
puts result.document.inference.prediction.energy_supplier.value
```

## Energy Usage
**energy_usage** (Array<[EnergyBillV1EnergyUsage](#energy-usage-field)>): Details of energy consumption.

```rb
result.document.inference.prediction.energy_usage do |energy_usage_elem|
  puts energy_usage_elem.value
end
```

## Invoice Date
**invoice_date** ([DateField](#date-field)): The date when the energy invoice was issued.

```rb
puts result.document.inference.prediction.invoice_date.value
```

## Invoice Number
**invoice_number** ([StringField](#string-field)): The unique identifier of the energy invoice.

```rb
puts result.document.inference.prediction.invoice_number.value
```

## Meter Details
**meter_details** ([EnergyBillV1MeterDetail](#meter-details-field)): Information about the energy meter.

```rb
puts result.document.inference.prediction.meter_details.value
```

## Subscription
**subscription** (Array<[EnergyBillV1Subscription](#subscription-field)>): The subscription details fee for the energy service.

```rb
result.document.inference.prediction.subscription do |subscription_elem|
  puts subscription_elem.value
end
```

## Taxes and Contributions
**taxes_and_contributions** (Array<[EnergyBillV1TaxesAndContribution](#taxes-and-contributions-field)>): Details of Taxes and Contributions.

```rb
result.document.inference.prediction.taxes_and_contributions do |taxes_and_contributions_elem|
  puts taxes_and_contributions_elem.value
end
```

## Total Amount
**total_amount** ([AmountField](#amount-field)): The total amount to be paid for the energy invoice.

```rb
puts result.document.inference.prediction.total_amount.value
```

## Total Before Taxes
**total_before_taxes** ([AmountField](#amount-field)): The total amount to be paid for the energy invoice before taxes.

```rb
puts result.document.inference.prediction.total_before_taxes.value
```

## Total Taxes
**total_taxes** ([AmountField](#amount-field)): Total of taxes applied to the invoice.

```rb
puts result.document.inference.prediction.total_taxes.value
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
