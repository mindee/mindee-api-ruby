# Mindee Ruby API Library Changelog

## v4.7.1 - 2025-09-19
### Fixes
* :sparkles: add missing `to_s` method on raw_text


## v4.7.0 - 2025-09-18
Including RC changes and fixes. 
### Changes
* :sparkles: add support for V2 Mindee API
* :sparkles: add missing accessors for PDF fixing options in `LocalInputSource`
* :recycle: add many missing internal types
### Fixes
* :recycle: update existing PDF fixing syntax
* :bug: fix for polygon points not correctly initialized
* :bug: fix user agent not being able to access version number
* :bug: fix invalid types for many V1 features
* :bug: fix V1 errors sometimes having the wrong code
* :bug: fix many presumably immutable fields having non-readonly parameters
* :bug: fix broken `resources` accessor in `ApiRequest` object


## v4.7.0-rc3 - 2025-08-29
### Fixes
* :bug: fix user agent not being able to access version number


## v4.7.0-rc2 - 2025-08-20
### Changes
* :sparkles: add missing accessors for PDF fixing options in `LocalInputSource`
### Fixes
* :recycle: update existing PDF fixing syntax
* :memo: fix typos & documentation


## v4.7.0-rc1 - 2025-08-13
### Changes
* :sparkles: add support for client V2 & associated features
### Fixes
* :recycle: add many missing internal types
* :bug: fix invalid types for many V1 features
* :bug: fix V1 errors sometimes having the wrong code
* :bug: fix many presumably immutable fields having non-readonly parameters
* :bug: fix broken `resources` accessor in `ApiRequest` object


## v4.6.0 - 2025-06-03
### Changes
* :sparkles: add support for address fields


## v4.5.0 - 2025-05-27
### Changes
* :sparkles: add support for Financial Document v1.14
* :sparkles: add support for US Healthcare Cards v1.3
* :sparkles: add support for Invoice v4.11
### Fixes
* :recycle: switch to 'Transfer-Encoding: chunked' to prevent Net::HTTP from writing temporary files


## v4.4.1 - 2025-05-13
### Fixes
* :bug: fix bad option in CLI
* :bug: don't open the PDF unless needed


## v4.4.0 - 2025-04-23
### Changes
* :sparkles: add support for workflow polling
* :sparkles: add extras accessor from inference
### Fixes
* :recycle: fix misc typing issues
* :bug: fix improper return format for `raw_http`


## v4.3.0 - 2025-04-08
### Changes
* :sparkles: add support for Financial Document V1.12
* :sparkles: add support for Invoices V4.10
* :sparkles: add support for US Healthcare Cards V1.2


## v4.2.0 - 2025-03-28
### Changes
* :coffin: remove support for US W9


## v4.1.2 - 2025-03-26
### Fixes
* :wrench: loosen version restrictions on most dependencies


## v4.1.1 - 2025-03-25
### Fixes
* :wrench: loosen pinning on base64 dependency


## v4.1.0 - 2025-03-25
### Changes
* :sparkles: bump FR EnergyBillV1 to V1.2 & US HealthcareCardV1 to V1.1
* :sparkles: restore support for US Mail V2
* :sparkles: add support for RAG in workflow executions
### Fixes
* :recycle: update CLI syntax for easier product creation


## v4.0.0 - 2025-02-27
### ¡Breaking Changes!
* :boom: drop support for ruby versions < 3.0
* :boom: refactor error-handling
* :boom: merge enqueue_and_parse() into parse()
* :boom: allow access to page-level extras, even when the page predictions are empty
* :boom: deprecate CustomV1 & GeneratedV1 in favor of Universal
### Changes
* :sparkles: add support for logging
* :sparkles: add typing support through RBS
* :sparkles: add support for multiple feature classes, inheriting from Array
* :recycle: refactor internal modules
* :recycle: refactor test module
* :coffin: remove support for US Mail V2
* :coffin: remove support for FR Bank Statement V1
* :recycle: update `UrlInputSource` to `URLInputSource`
* :memo: update documentation structure
### Fixes
* :bug: fix miscellaneous bugs relating to image extraction
* :bug: fix miscellaneous bugs relating to pdf extraction
* :bug: fix improper saving mechanism


## v3.20.0 - 2025-02-26
### Changes
* :sparkles: add support for FR Banks Statement V2


## v3.19.1 - 2025-01-21
### Changes
* :bug: fix extras failing at document level if missing from prediction


## v3.19.0 - 2025-01-14
### Changes
* :sparkles: add support for US Mail V3
* :recycle: increase async retry timers


## v3.18.0 - 2024-12-13
### Changes
* :sparkles: allow local downloading of remote sources
* :coffin: remove support for (FR) Carte Vitale V1 in favor of French Health Card V1
### Fixes
* :bug: fix tax-extraction script


## v3.17.0 - 2024-11-28
### Changes
* :sparkles: add support for workflows
* :sparkles: add support for French Health Card V1
* :sparkles: add support for Driver License V1
* :sparkles: add support for Payslip FR V3
* :coffin: remove support for international ID V1

## v3.16.0 - 2024-11-14
### Changes
* :sparkles: add support for business cards V1
* :sparkles: add support for delivery note V1.1
* :sparkles: add support for indian passport V1
* :sparkles: add support for resume V1.1
### Fixes
* :recycle: adjust default values for async delays


## v3.15.0 - 2024-10-29
### Changes
* :sparkles: add support for image compression
* :sparkles: add support for PDF compression
### Fixes
* :recycle: refactor pdf & image namespaces
* :memo: fix rubocop directives unexpectedly appearing in Yard documentation
* :arrow_up: bump version for mini_magick


## v3.14.0 - 2024-10-11
### Changes
* :sparkles: add support for Financial Document v1.10
* :sparkles: add support for Invoice v4.8
### Fixes
* :bug: fix multi-receipts extraction not working as intended


## v3.13.0 - 2024-09-18
### Changes
* :sparkles: add support for BillOfLadingV1
* :sparkles: add support for (US) UsMailV2
* :sparkles: add support for (FR) EnergyBillV1
* :sparkles: add support for (FR) PayslipV1
* :sparkles: add support for NutritionFactsLabelV1
* :sparkles: add support for cropper Extra
* :sparkles: add support for full text Extra
* :sparkles: add support for invoice splitter auto-extraction
### Fixes
* :bug: fixed a bug that prevented longer decimals from appearing in the string representation of some objects
* :bug: fixed a bug that caused non-table elements to unexpectedly appear truncated when printed to the console
* :memo: fix a few documentation errors & typos
* :wrench: updated CI dependencies


## v3.12.0 - 2024-07-24
### Changes
* :sparkles: add support for Multi-Receipts Extraction
* :sparkles: add support for Healthcare Card V1
* :sparkles: add support for Invoice V4.7
* :sparkles: add support for Financial Document V1.9
* :recycle: update display for company registration fields


## v3.11.0 - 2024-06-10
### Changes
* :sparkles: add custom tax extraction feature (#76)


## v3.10.0 - 2024-05-31
### Changes
* :sparkles: add support for us mail v2 (#98)
* :sparkles: add support for boolean fields
* :sparkles: add support for webhooks (#97)
### Fixes
* :recycle: tweak display for LocaleField


## v3.9.0 - 2024-05-16
### Changes
* :sparkles: update financial document to v1.7 & receipts to v5.2


## v3.8.0 - 2024-05-02
### Changes
* :recycle: update products to newer syntax
* :sparkles: update financial document to v1.6 & invoice to v4.6


## v3.7.0 - 2024-03-28
### Changes
* :sparkles: update Invoice to v4.5
### Fixes
* :bug: fix invalid error codes


## v3.6.1 - 2024-03-07
### Changes
* :recycle: update error handling to account for future evolutions
* :memo: update miscellaneous product documentations
* :memo: add used environment variables to readme


## v3.6.0 - 2024-02-21
### Changes
* :sparkles: add support for resume V1


## v3.5.0 - 2024-02-16
### Changes
* :sparkles: add support for Generated V1 API
* :recycle: documents now aren't automatically converted to b64 when enqueued as non-PDF files
* :recycle: increase max async delay to 60 tries
* :sparkles: add support for FR bank statements
* :sparkles: add support for International ID V2
* :sparkles: add support for EU Driver License V1
* :recycle: update existing products
* :arrow_up: upgrade test lib
### Fixes
* :memo: add missing default async sample code
* :bug: fix rst display issues
* :bug: fix display issues for single page models
* :bug: fix miscellaneous issues related to data display (no changes expected on existing models)
* :bug: fix CLI breaking for custom products
* :bug: fix encoding issue that prevented UNICODE file names from being properly sent to the server


## v3.4.0 - 2024-01-30
### Changes
* :arrow_up: update invoices to v4.4
* :sparkles: add support for `raw_value` in string fields


## v3.3.1 - 2023-12-15
### Changes
* :recycle: tweak async delays & retry
* :recycle: tweak default async sample delays & retry
* :memo: update md doc & fix typos


## v3.3.0 - 2023-11-17
### Changes
* :sparkles: add support for Carte Grise V1
* :sparkles: add page number attributes to doc
* :arrow_up: update tests, docs & display format for some products
### Fixes
* :bug: fix page id not working on newer custom models


## v3.2.0 - 2023-09-15
### Changes
* :sparkles: add support for Multi Receipts Detector V1
* :sparkles: add support for Barcode Reader V1
* :sparkles: add support for W9 V1
* :sparkles: add support for FR ID Card V2
* :sparkles: add support for async in CLI
* :sparkles: add support for async auto-polling
* :sparkles: add direct access to `raw_http` response
* :memo: upgrade reference & guide documentation
* :test_tube: **EXPERIMENTAL** add PDF repair option
### Fixes
* :bug: fix display issues with `PositionField`


## v3.1.1 - 2023-08-10
### Fixes
* :bug: fixed non-pdf files being improperly handled by Ruby requests


## v3.1.0 - 2023-08-08
### Changes
* :sparkles: add support for US Driver License
* :recycle: update unit tests & dependencies
* :arrow_up: update Bank Checks (#46)
### Fixes
* :bug: fix `all_words` display (#47)
* :bug: fix empty `position_field` (#47)
* :bug: fix byte repacking issues for PDF files (#45)


## v3.0.0 - 2023-06-29
### ¡Breaking Changes!
* :boom: update `Client` creation & document upload
* :boom: update custom `Endpoint` creation syntax
* :art: improve product class syntax & structure
* :recycle: harmonize naming with other client libraries
* :art: moved most parsing modules into their own respective modules
* :art: separated common, standard & custom parsing features into their own modules
### Changes
* :sparkles: add support for asynchronous endpoints
* :sparkles: add support for Invoice Splitter V1
* :sparkles: add support for OCR Full-text parsing on compatible APIs
* :sparkles: add support for FR Bank Account Details V2
* :sparkles: allow for the implementation of pages to differ from main document
* :sparkles: add url input source
* :coffin: remove Shipping Containers
* :recycle: moved all products into the `Product` module (from `Parsing`)
* :recycle: better implementation of geometric operations
* :pencil2: document all previously non-documented class
* :recycle: match file hierarchy with module nesting
* :recycle: rewrite tutorials to match new syntax
### Fixes
* :bug: fix: pages now use the proper `orientation` property
* :zap: optimize: only a single endpoint is now created on document upload


## v2.2.1 - 2023-05-22
### Fixes
* :bug: added base attribute to tax field


## v2.2.0 - 2023-05-16
### Changes
* :sparkles: add support for Receipts v5
* :pushpin: more specific dependency pinning; update some dependencies


## v2.1.1 - 2023-04-21
### Changes
* :memo: minor docstring improvements
* :coffin: remove redundant local checks
* :memo: publish documentation
* :memo: add code samples


## v2.1.0 - 2023-01-30
### Changes
* :sparkles: Add financial document v1 support (Co-authored-by: Oriol Gual)
* :sparkles: Add Proof of Address v1 support


## v2.0.0 - 2023-01-13
### ¡Breaking Changes!
* :sparkles: add improved PDF merge system
* :boom: it should be up to the user to handle API errors
* :wastebasket: remove deprecated APIs
* :recycle: refactor CLI tool
### Changes
* :sparkles: add support for Invoice v4.1 and Receipt v4.1
* :sparkles: add EU license plates
* :sparkles: add shipping containers support
* :sparkles: add US bank check support
* :sparkles: add all French documents
* :memo: Add YARD for generating docs
* :white_check_mark: add testing on Ruby 3.2
* :sparkles: allow setting the request timeout from env


## v1.2.0 - 2022-12-26
### Changes
* :arrow_up: switch to origamindee => adds support for Ruby 3


## v1.1.2 - 2022-12-23
### Changes
* :recycle: use of `append_page` is better for adding pages to a new PDF


## v1.1.1 - 2022-08-08
### Fixes
* :bug: Fix for missing attribute accessor


## v1.1.0 - 2022-08-04
### Changes
* :sparkles: Add support for custom API classification field (#5)


## v1.0.0 - 2022-07-28
* :tada: First release!
