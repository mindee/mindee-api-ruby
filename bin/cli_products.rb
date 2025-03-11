# frozen_string_literal: true

PRODUCTS = {
  "universal" => {
    description: "Universal document type from API builder",
    doc_class: Mindee::Product::Universal::Universal,
    sync: true,
    async: true,
  },
  "barcode-reader" => {
    description: "Barcode Reader",
    doc_class: Mindee::Product::BarcodeReader::BarcodeReaderV1,
    sync: true,
    async: false,
  },
  "bill-of-lading" => {
    description: "Bill of Lading",
    doc_class: Mindee::Product::BillOfLading::BillOfLadingV1,
    sync: false,
    async: true,
  },
  "business-card" => {
    description: "Business Card",
    doc_class: Mindee::Product::BusinessCard::BusinessCardV1,
    sync: false,
    async: true,
  },
  "cropper" => {
    description: "Cropper",
    doc_class: Mindee::Product::Cropper::CropperV1,
    sync: true,
    async: false,
  },
  "delivery-note" => {
    description: "Delivery note",
    doc_class: Mindee::Product::DeliveryNote::DeliveryNoteV1,
    sync: false,
    async: true,
  },
  "driver-license" => {
    description: "Driver License",
    doc_class: Mindee::Product::DriverLicense::DriverLicenseV1,
    sync: false,
    async: true,
  },
  "license-plate" => {
    description: "License Plate",
    doc_class: Mindee::Product::EU::LicensePlate::LicensePlateV1,
    sync: true,
    async: false,
  },
  "financial-document" => {
    description: "Financial Document",
    doc_class: Mindee::Product::FinancialDocument::FinancialDocumentV1,
    sync: true,
    async: true,
  },
  "bank-account-details" => {
    description: "Bank Account Details",
    doc_class: Mindee::Product::FR::BankAccountDetails::BankAccountDetailsV2,
    sync: true,
    async: false,
  },
  "bank-statement" => {
    description: "Bank Statement",
    doc_class: Mindee::Product::FR::BankStatement::BankStatementV2,
    sync: false,
    async: true,
  },
  "carte-grise" => {
    description: "Carte Grise",
    doc_class: Mindee::Product::FR::CarteGrise::CarteGriseV1,
    sync: true,
    async: false,
  },
  "energy-bill" => {
    description: "Energy Bill",
    doc_class: Mindee::Product::FR::EnergyBill::EnergyBillV1,
    sync: false,
    async: true,
  },
  "health-card" => {
    description: "Health Card",
    doc_class: Mindee::Product::FR::HealthCard::HealthCardV1,
    sync: false,
    async: true,
  },
  "carte-nationale-d-identite" => {
    description: "Carte Nationale d'Identité",
    doc_class: Mindee::Product::FR::IdCard::IdCardV2,
    sync: true,
    async: false,
  },
  "payslip" => {
    description: "Payslip",
    doc_class: Mindee::Product::FR::Payslip::PayslipV3,
    sync: false,
    async: true,
  },
  "passport-india" => {
    description: "Passport - India",
    doc_class: Mindee::Product::IND::IndianPassport::IndianPassportV1,
    sync: false,
    async: true,
  },
  "international-id" => {
    description: "International ID",
    doc_class: Mindee::Product::InternationalId::InternationalIdV2,
    sync: false,
    async: true,
  },
  "invoice" => {
    description: "Invoice",
    doc_class: Mindee::Product::Invoice::InvoiceV4,
    sync: true,
    async: true,
  },
  "invoice-splitter" => {
    description: "Invoice Splitter",
    doc_class: Mindee::Product::InvoiceSplitter::InvoiceSplitterV1,
    sync: false,
    async: true,
  },
  "multi-receipts-detector" => {
    description: "Multi Receipts Detector",
    doc_class: Mindee::Product::MultiReceiptsDetector::MultiReceiptsDetectorV1,
    sync: true,
    async: false,
  },
  "nutrition-facts-label" => {
    description: "Nutrition Facts Label",
    doc_class: Mindee::Product::NutritionFactsLabel::NutritionFactsLabelV1,
    sync: false,
    async: true,
  },
  "passport" => {
    description: "Passport",
    doc_class: Mindee::Product::Passport::PassportV1,
    sync: true,
    async: false,
  },
  "receipt" => {
    description: "Receipt",
    doc_class: Mindee::Product::Receipt::ReceiptV5,
    sync: true,
    async: true,
  },
  "resume" => {
    description: "Resume",
    doc_class: Mindee::Product::Resume::ResumeV1,
    sync: false,
    async: true,
  },
  "bank-check" => {
    description: "Bank Check",
    doc_class: Mindee::Product::US::BankCheck::BankCheckV1,
    sync: true,
    async: false,
  },
  "healthcare-card" => {
    description: "Healthcare Card",
    doc_class: Mindee::Product::US::HealthcareCard::HealthcareCardV1,
    sync: false,
    async: true,
  },
  "us-mail" => {
    description: "US Mail",
    doc_class: Mindee::Product::US::UsMail::UsMailV3,
    sync: false,
    async: true,
  },
  "w9" => {
    description: "W9",
    doc_class: Mindee::Product::US::W9::W9V1,
    sync: true,
    async: false,
  },
}
