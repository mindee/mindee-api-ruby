# frozen_string_literal: true

V1_PRODUCTS = {
  'universal' => {
    description: 'Universal document type from API builder',
    doc_class: Mindee::V1::Product::Universal::Universal,
    sync: true,
    async: true,
  },
  'barcode-reader' => {
    description: 'Barcode Reader',
    doc_class: Mindee::V1::Product::BarcodeReader::BarcodeReaderV1,
    sync: true,
    async: false,
  },
  'cropper' => {
    description: 'Cropper',
    doc_class: Mindee::V1::Product::Cropper::CropperV1,
    sync: true,
    async: false,
  },
  'financial-document' => {
    description: 'Financial Document',
    doc_class: Mindee::V1::Product::FinancialDocument::FinancialDocumentV1,
    sync: true,
    async: true,
  },
  'fr-bank-account-details' => {
    description: 'Bank Account Details',
    doc_class: Mindee::V1::Product::FR::BankAccountDetails::BankAccountDetailsV2,
    sync: true,
    async: false,
  },
  'fr-bank-statement' => {
    description: 'Bank Statement',
    doc_class: Mindee::V1::Product::FR::BankStatement::BankStatementV2,
    sync: false,
    async: true,
  },
  'fr-carte-nationale-d-identite' => {
    description: "Carte Nationale d'Identité",
    doc_class: Mindee::V1::Product::FR::IdCard::IdCardV2,
    sync: true,
    async: false,
  },
  'international-id' => {
    description: 'International ID',
    doc_class: Mindee::V1::Product::InternationalId::InternationalIdV2,
    sync: false,
    async: true,
  },
  'invoice' => {
    description: 'Invoice',
    doc_class: Mindee::V1::Product::Invoice::InvoiceV4,
    sync: true,
    async: true,
  },
  'invoice-splitter' => {
    description: 'Invoice Splitter',
    doc_class: Mindee::V1::Product::InvoiceSplitter::InvoiceSplitterV1,
    sync: false,
    async: true,
  },
  'multi-receipts-detector' => {
    description: 'Multi Receipts Detector',
    doc_class: Mindee::V1::Product::MultiReceiptsDetector::MultiReceiptsDetectorV1,
    sync: true,
    async: false,
  },
  'passport' => {
    description: 'Passport',
    doc_class: Mindee::V1::Product::Passport::PassportV1,
    sync: true,
    async: false,
  },
  'receipt' => {
    description: 'Receipt',
    doc_class: Mindee::V1::Product::Receipt::ReceiptV5,
    sync: true,
    async: true,
  },
  'resume' => {
    description: 'Resume',
    doc_class: Mindee::V1::Product::Resume::ResumeV1,
    sync: false,
    async: true,
  },
}.freeze
