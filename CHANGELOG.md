# Mindee Ruby API Library Changelog

## v3.11.0 - 2024-06-10
### Changes
* :sparkles: add support custom tax extraction feature (#76)


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

### Additions
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
