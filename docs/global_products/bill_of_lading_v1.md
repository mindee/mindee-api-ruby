---
title: Bill of Lading
category: 622b805aaec68102ea7fcbc2
slug: ruby-bill-of-lading-ocr
parentDoc: 67b49df15b843f3fa9cd622b
---
The Ruby Client Library supports the [Bill of Lading API](https://platform.mindee.com/mindee/bill_of_lading).


> 📝 Product Specs
>
> | Specification                  | Details                                            |
> | ------------------------------ | -------------------------------------------------- |
> | Endpoint Name                  | `bill_of_lading`                                   |
> | Recommended Version            | `v1.1`                                             |
> | Supports Polling/Webhooks      | ✔️ Yes                                             |
> | Support Synchronous HTTP Calls | ❌ No                                              |
> | Geography                      | 🌐 Global                                          |

> 🔐 Polling Limitations
>
> | Setting                         | Parameter name          | Default Value |
> | ------------------------------- | ----------------------- | ------------- |
> | Initial Delay Before Polling    | `initial_delay_seconds` | 2 seconds     |
> | Default Delay Between Calls     | `delay_sec`             | 1.5 seconds   |
> | Polling Attempts Before Timeout | `max_retries`           | 80 retries    |


Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/bill_of_lading/default_sample.jpg),
we are going to illustrate how to extract the data that we want using the Ruby Client Library.
![Bill of Lading sample](https://github.com/mindee/client-lib-test-data/blob/main/products/bill_of_lading/default_sample.jpg?raw=true)

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
  Mindee::Product::BillOfLading::BillOfLadingV1
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
:Mindee ID: 3b5250a1-b52c-4e0b-bc3e-2f0146b04e29
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/bill_of_lading v1.1
:Rotation applied: No

Prediction
==========
:Bill of Lading Number: XYZ123456
:Shipper:
  :Address: 123 OCEAN DRIVE, SHANGHAI, CHINA
  :Email:
  :Name: GLOBAL FREIGHT SOLUTIONS INC.
  :Phone: 86-21-12345678
:Consignee:
  :Address: 789 TRADE STREET, SINGAPORE 567890, SINGAPORE
  :Email:
  :Name: PACIFIC TRADING CO.
  :Phone: 65-65432100
:Notify Party:
  :Address: 789 TRADE STREET, SINGAPORE 567890, SINGAPORE
  :Email:
  :Name: PACIFIC TRADING CO.
  :Phone: 65-65432100
:Carrier:
  :Name: GLOBAL SHIPPING CO.,LTD.
  :Professional Number:
  :SCAC:
:Items:
  +--------------------------------------+--------------+-------------+------------------+----------+-------------+
  | Description                          | Gross Weight | Measurement | Measurement Unit | Quantity | Weight Unit |
  +======================================+==============+=============+==================+==========+=============+
  | ELECTRONIC COMPONENTS\nP/N: 12345... | 500.00       | 1.50        | cbm              | 1.00     | kgs         |
  +--------------------------------------+--------------+-------------+------------------+----------+-------------+
:Port of Loading: SHANGHAI, CHINA
:Port of Discharge: LOS ANGELES, USA
:Place of Delivery: LOS ANGELES, USA
:Date of issue: 2022-09-30
:Departure Date:
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

### Date Field
Aside from the basic `Field` attributes, the date field `DateField` also implements the following:

* **date_object** (`Date`): an accessible representation of the value as a JavaScript object.

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

## Specific Fields
Fields which are specific to this product; they are not used in any other product.

### Shipper Field
The party responsible for shipping the goods.

A `BillOfLadingV1Shipper` implements the following attributes:

* `address` (String): The address of the shipper.
* `email` (String): The  email of the shipper.
* `name` (String): The name of the shipper.
* `phone` (String): The phone number of the shipper.
Fields which are specific to this product; they are not used in any other product.

### Consignee Field
The party to whom the goods are being shipped.

A `BillOfLadingV1Consignee` implements the following attributes:

* `address` (String): The address of the consignee.
* `email` (String): The  email of the shipper.
* `name` (String): The name of the consignee.
* `phone` (String): The phone number of the consignee.
Fields which are specific to this product; they are not used in any other product.

### Notify Party Field
The party to be notified of the arrival of the goods.

A `BillOfLadingV1NotifyParty` implements the following attributes:

* `address` (String): The address of the notify party.
* `email` (String): The  email of the shipper.
* `name` (String): The name of the notify party.
* `phone` (String): The phone number of the notify party.
Fields which are specific to this product; they are not used in any other product.

### Carrier Field
The shipping company responsible for transporting the goods.

A `BillOfLadingV1Carrier` implements the following attributes:

* `name` (String): The name of the carrier.
* `professional_number` (String): The professional number of the carrier.
* `scac` (String): The Standard Carrier Alpha Code (SCAC) of the carrier.
Fields which are specific to this product; they are not used in any other product.

### Items Field
The goods being shipped.

A `BillOfLadingV1CarrierItem` implements the following attributes:

* `description` (String): A description of the item.
* `gross_weight` (Float): The gross weight of the item.
* `measurement` (Float): The measurement of the item.
* `measurement_unit` (String): The unit of measurement for the measurement.
* `quantity` (Float): The quantity of the item being shipped.
* `weight_unit` (String): The unit of measurement for weights.

# Attributes
The following fields are extracted for Bill of Lading V1:

## Bill of Lading Number
**bill_of_lading_number** ([StringField](#string-field)): A unique identifier assigned to a Bill of Lading document.

```rb
puts result.document.inference.prediction.bill_of_lading_number.value
```

## Carrier
**carrier** ([BillOfLadingV1Carrier](#carrier-field)): The shipping company responsible for transporting the goods.

```rb
puts result.document.inference.prediction.carrier.value
```

## Items
**carrier_items** (Array<[BillOfLadingV1CarrierItem](#items-field)>): The goods being shipped.

```rb
result.document.inference.prediction.carrier_items do |carrier_items_elem|
  puts carrier_items_elem.value
end
```

## Consignee
**consignee** ([BillOfLadingV1Consignee](#consignee-field)): The party to whom the goods are being shipped.

```rb
puts result.document.inference.prediction.consignee.value
```

## Date of issue
**date_of_issue** ([DateField](#date-field)): The date when the bill of lading is issued.

```rb
puts result.document.inference.prediction.date_of_issue.value
```

## Departure Date
**departure_date** ([DateField](#date-field)): The date when the vessel departs from the port of loading.

```rb
puts result.document.inference.prediction.departure_date.value
```

## Notify Party
**notify_party** ([BillOfLadingV1NotifyParty](#notify-party-field)): The party to be notified of the arrival of the goods.

```rb
puts result.document.inference.prediction.notify_party.value
```

## Place of Delivery
**place_of_delivery** ([StringField](#string-field)): The place where the goods are to be delivered.

```rb
puts result.document.inference.prediction.place_of_delivery.value
```

## Port of Discharge
**port_of_discharge** ([StringField](#string-field)): The port where the goods are unloaded from the vessel.

```rb
puts result.document.inference.prediction.port_of_discharge.value
```

## Port of Loading
**port_of_loading** ([StringField](#string-field)): The port where the goods are loaded onto the vessel.

```rb
puts result.document.inference.prediction.port_of_loading.value
```

## Shipper
**shipper** ([BillOfLadingV1Shipper](#shipper-field)): The party responsible for shipping the goods.

```rb
puts result.document.inference.prediction.shipper.value
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
