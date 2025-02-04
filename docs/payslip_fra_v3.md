---
title: FR Payslip OCR Ruby
category: 622b805aaec68102ea7fcbc2
slug: ruby-fr-payslip-ocr
parentDoc: 6294d97ee723f1008d2ab28e
---
The Ruby OCR SDK supports the [Payslip API](https://platform.mindee.com/mindee/payslip_fra).

Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/payslip_fra/default_sample.jpg), we are going to illustrate how to extract the data that we want using the OCR SDK.
![Payslip sample](https://github.com/mindee/client-lib-test-data/blob/main/products/payslip_fra/default_sample.jpg?raw=true)

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
  Mindee::Product::FR::Payslip::PayslipV3
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
:Mindee ID: a479e3e7-6838-4e82-9a7d-99289f34ec7f
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/payslip_fra v3.0
:Rotation applied: Yes

Prediction
==========
:Pay Period:
  :End Date: 2023-03-31
  :Month: 03
  :Payment Date: 2023-03-29
  :Start Date: 2023-03-01
  :Year: 2023
:Employee:
  :Address: 52 RUE DES FLEURS 33500 LIBOURNE FRANCE
  :Date of Birth:
  :First Name: Jean Luc
  :Last Name: Picard
  :Phone Number:
  :Registration Number:
  :Social Security Number: 123456789012345
:Employer:
  :Address: 1 RUE DU TONNOT 25210 DOUBS
  :Company ID: 12345678901234
  :Company Site:
  :NAF Code: 1234A
  :Name: DEMO COMPANY
  :Phone Number:
  :URSSAF Number:
:Bank Account Details:
  :Bank Name:
  :IBAN:
  :SWIFT:
:Employment:
  :Category: Cadre
  :Coefficient: 600,000
  :Collective Agreement: Construction -- Promotion
  :Job Title: Directeur Régional du Développement
  :Position Level: Niveau 5 Echelon 3
  :Seniority Date:
  :Start Date: 2022-05-01
:Salary Details:
  +--------------+-----------+--------------------------------------+--------+-----------+
  | Amount       | Base      | Description                          | Number | Rate      |
  +==============+===========+======================================+========+===========+
  | 6666.67      |           | Salaire de base                      |        |           |
  +--------------+-----------+--------------------------------------+--------+-----------+
  | 9.30         |           | Part patronale Mutuelle NR           |        |           |
  +--------------+-----------+--------------------------------------+--------+-----------+
  | 508.30       |           | Avantages en nature voiture          |        |           |
  +--------------+-----------+--------------------------------------+--------+-----------+
:Pay Detail:
  :Gross Salary: 7184.27
  :Gross Salary YTD: 18074.81
  :Income Tax Rate: 17.60
  :Income Tax Withheld: 1030.99
  :Net Paid: 3868.32
  :Net Paid Before Tax: 4899.31
  :Net Taxable: 5857.90
  :Net Taxable YTD: 14752.73
  :Total Cost Employer: 10486.94
  :Total Taxes and Deductions: 1650.36
:Paid Time Off:
  +-----------+--------+-------------+-----------+-----------+
  | Accrued   | Period | Type        | Remaining | Used      |
  +===========+========+=============+===========+===========+
  |           | N-1    | VACATION    |           |           |
  +-----------+--------+-------------+-----------+-----------+
  | 6.17      | N      | VACATION    | 6.17      |           |
  +-----------+--------+-------------+-----------+-----------+
  | 2.01      | N      | RTT         | 2.01      |           |
  +-----------+--------+-------------+-----------+-----------+
```

# Field Types
## Standard Fields
These fields are generic and used in several products.

### Basic Field
Each prediction object contains a set of fields that inherit from the generic `Field` class.
A typical `Field` object will have the following attributes:

* **value** (`String`, `Float`, `Integer`, `Boolean`): corresponds to the field value. Can be `nil` if no value was extracted.
* **confidence** (Float, nil): the confidence score of the field prediction.
* **bounding_box** (`Mindee::Geometry::Quadrilateral`, `nil`): contains exactly 4 relative vertices (points) coordinates of a right rectangle containing the field in the document.
* **polygon** (`Mindee::Geometry::Polygon`, `nil`): contains the relative vertices coordinates (`Point`) of a polygon containing the field in the image.
* **page_id** (`Integer`, `nil`): the ID of the page, always `nil` when at document-level.
* **reconstructed** (`Boolean`): indicates whether an object was reconstructed (not extracted as the API gave it).


Aside from the previous attributes, all basic fields have access to a `to_s` method that can be used to print their value as a string.

## Specific Fields
Fields which are specific to this product; they are not used in any other product.

### Bank Account Details Field
Information about the employee's bank account.

A `PayslipV3BankAccountDetail` implements the following attributes:

* `bank_name` (String): The name of the bank.
* `iban` (String): The IBAN of the bank account.
* `swift` (String): The SWIFT code of the bank.
Fields which are specific to this product; they are not used in any other product.

### Employee Field
Information about the employee.

A `PayslipV3Employee` implements the following attributes:

* `address` (String): The address of the employee.
* `date_of_birth` (String): The date of birth of the employee.
* `first_name` (String): The first name of the employee.
* `last_name` (String): The last name of the employee.
* `phone_number` (String): The phone number of the employee.
* `registration_number` (String): The registration number of the employee.
* `social_security_number` (String): The social security number of the employee.
Fields which are specific to this product; they are not used in any other product.

### Employer Field
Information about the employer.

A `PayslipV3Employer` implements the following attributes:

* `address` (String): The address of the employer.
* `company_id` (String): The company ID of the employer.
* `company_site` (String): The site of the company.
* `naf_code` (String): The NAF code of the employer.
* `name` (String): The name of the employer.
* `phone_number` (String): The phone number of the employer.
* `urssaf_number` (String): The URSSAF number of the employer.
Fields which are specific to this product; they are not used in any other product.

### Employment Field
Information about the employment.

A `PayslipV3Employment` implements the following attributes:

* `category` (String): The category of the employment.
* `coefficient` (String): The coefficient of the employment.
* `collective_agreement` (String): The collective agreement of the employment.
* `job_title` (String): The job title of the employee.
* `position_level` (String): The position level of the employment.
* `seniority_date` (String): The seniority date of the employment.
* `start_date` (String): The start date of the employment.
Fields which are specific to this product; they are not used in any other product.

### Paid Time Off Field
Information about paid time off.

A `PayslipV3PaidTimeOff` implements the following attributes:

* `accrued` (Float): The amount of paid time off accrued in the period.
* `period` (String): The paid time off period.

#### Possible values include:
 - N
 - N-1
 - N-2

* `pto_type` (String): The type of paid time off.

#### Possible values include:
 - VACATION
 - RTT
 - COMPENSATORY

* `remaining` (Float): The remaining amount of paid time off at the end of the period.
* `used` (Float): The amount of paid time off used in the period.
Fields which are specific to this product; they are not used in any other product.

### Pay Detail Field
Detailed information about the pay.

A `PayslipV3PayDetail` implements the following attributes:

* `gross_salary` (Float): The gross salary of the employee.
* `gross_salary_ytd` (Float): The year-to-date gross salary of the employee.
* `income_tax_rate` (Float): The income tax rate of the employee.
* `income_tax_withheld` (Float): The income tax withheld from the employee's pay.
* `net_paid` (Float): The net paid amount of the employee.
* `net_paid_before_tax` (Float): The net paid amount before tax of the employee.
* `net_taxable` (Float): The net taxable amount of the employee.
* `net_taxable_ytd` (Float): The year-to-date net taxable amount of the employee.
* `total_cost_employer` (Float): The total cost to the employer.
* `total_taxes_and_deductions` (Float): The total taxes and deductions of the employee.
Fields which are specific to this product; they are not used in any other product.

### Pay Period Field
Information about the pay period.

A `PayslipV3PayPeriod` implements the following attributes:

* `end_date` (String): The end date of the pay period.
* `month` (String): The month of the pay period.
* `payment_date` (String): The date of payment for the pay period.
* `start_date` (String): The start date of the pay period.
* `year` (String): The year of the pay period.
Fields which are specific to this product; they are not used in any other product.

### Salary Details Field
Detailed information about the earnings.

A `PayslipV3SalaryDetail` implements the following attributes:

* `amount` (Float): The amount of the earning.
* `base` (Float): The base rate value of the earning.
* `description` (String): The description of the earnings.
* `number` (Float): The number of units in the earning.
* `rate` (Float): The rate of the earning.

# Attributes
The following fields are extracted for Payslip V3:

## Bank Account Details
**bank_account_details** ([PayslipV3BankAccountDetail](#bank-account-details-field)): Information about the employee's bank account.

```rb
puts result.document.inference.prediction.bank_account_details.value
```

## Employee
**employee** ([PayslipV3Employee](#employee-field)): Information about the employee.

```rb
puts result.document.inference.prediction.employee.value
```

## Employer
**employer** ([PayslipV3Employer](#employer-field)): Information about the employer.

```rb
puts result.document.inference.prediction.employer.value
```

## Employment
**employment** ([PayslipV3Employment](#employment-field)): Information about the employment.

```rb
puts result.document.inference.prediction.employment.value
```

## Paid Time Off
**paid_time_off** (Array<[PayslipV3PaidTimeOff](#paid-time-off-field)>): Information about paid time off.

```rb
for paid_time_off_elem in result.document.inference.prediction.paid_time_off do
  puts paid_time_off_elem.value
end
```

## Pay Detail
**pay_detail** ([PayslipV3PayDetail](#pay-detail-field)): Detailed information about the pay.

```rb
puts result.document.inference.prediction.pay_detail.value
```

## Pay Period
**pay_period** ([PayslipV3PayPeriod](#pay-period-field)): Information about the pay period.

```rb
puts result.document.inference.prediction.pay_period.value
```

## Salary Details
**salary_details** (Array<[PayslipV3SalaryDetail](#salary-details-field)>): Detailed information about the earnings.

```rb
for salary_details_elem in result.document.inference.prediction.salary_details do
  puts salary_details_elem.value
end
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
