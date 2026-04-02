# frozen_string_literal: true

require 'json'
require 'mindee'

describe Mindee::V2::Product::OCR::OCR, :v2 do
  let(:ocr_data_dir) { File.join(V2_PRODUCT_DATA_DIR, 'ocr') }

  it 'parses a single page OCR response properly' do
    json_path = File.join(ocr_data_dir, 'ocr_single.json')
    json_sample = JSON.parse(File.read(json_path))

    response = Mindee::V2::Product::OCR::OCRResponse.new(json_sample)

    expect(response.inference).to be_a(Mindee::V2::Product::OCR::OCRInference)
    expect(response.inference.result.pages).not_to be_empty
    expect(response.inference.result.pages.size).to eq(1)

    page = response.inference.result.pages[0]
    first_word = page.words[0]

    expect(first_word.content).to eq('Shipper:')
    expect(first_word.polygon[0][0]).to eq(0.09742441209406495)
    expect(first_word.polygon[0][1]).to eq(0.07007125890736342)
    expect(first_word.polygon[1][0]).to eq(0.15621500559910415)
    expect(first_word.polygon[1][1]).to eq(0.07046714172604909)
    expect(first_word.polygon[2][0]).to eq(0.15621500559910415)
    expect(first_word.polygon[2][1]).to eq(0.08155186064924783)
    expect(first_word.polygon[3][0]).to eq(0.09742441209406495)
    expect(first_word.polygon[3][1]).to eq(0.08155186064924783)

    expect(page.words.size).to eq(305)
    expect(page.content).to eq(
      'Shipper: GLOBAL FREIGHT SOLUTIONS INC. 123 OCEAN DRIVE SHANGHAI, CHINA TEL: ' \
      "86-21-12345678 FAX: 86-21-87654321\nConsignee: PACIFIC TRADING CO. 789 TRADE " \
      "STREET SINGAPORE 567890 SINGAPORE TEL: 65-65432100 FAX: 65-65432101\nNotify " \
      "Party (Complete name and address): SAME AS CONSIGNEE\nBILL OF LADING\nJob No " \
      ".: XYZ123456\nGLOBAL SHIPPING CO\nPlace of receipt:\nSHANGHAI, CHINA\nOcean " \
      "vessel:\nGLOBAL VOYAGER V-202\nPort of loading:\nSHANGHAI, CHINA\nPort of " \
      "discharge:\nLOS ANGELES, USA\nPlace of delivery:\nLOS ANGELES, USA\nMarks and " \
      "numbers:\nP+F\n(IN DIA.)\nP/N: 12345\nDRAWING NO. A1B2C3\nNumber and kinds of " \
      "packages: 1CTN ELECTRONIC COMPONENTS 50 PCS\nDescription of goods:\nGross " \
      "weight:\n500 KGS\nMeasurement:\n1.5 M3\nP/O: 987654 LOT NO. " \
      "112233\nFFAU1234567/40'HQ/CFS-CFS ICTN/500KGS/1.5M3 SEAL NO:ABC1234567\nMADE " \
      "IN CHINA\nSAY TOTAL:\n2 PLTS ONLY\n\"FREIGHT COLLECT\" CFS-CFS\n** SURRENDERED " \
      "**\nFreight and Charge\nOCEAN FREIGHT\nRevenue tons\nRate\nPrepaid\nCollect\n" \
      "AS ARRANGED\nThe goods and instructions are accepted and dealt with subject " \
      'to the Standard Conditions printed overleaf. Taken in charge in apparent good ' \
      'order and condition, unless otherwise noted herein, at the place of receipt ' \
      'for transport and delivery as mentioned above. One of these Combined ' \
      'Transport Bills of Lading must be surrendered duly endorsed in exchange for ' \
      'the goods. In Witness whereof the original Combined Transport Bills of Lading ' \
      'all of this tenor and date have been signed in the number stated below, one ' \
      "of which being accomplished the other(s) to be void.\nUSD: 31.57 SHIPPED ON " \
      "BOARD: 30. SEP. 2022\nFreight Amount OCEAN FREIGHT\nFreight payable at\n" \
      "DESTINATION\nNumber of original\nZERO (0)\nCargo insurance\nnot covered\n" \
      "Covered according to attached Policy\nPlace and date of issue\nTAIPEI, " \
      "TAIWAN: 30. SEP. 2022\nFor delivery of goods please apply to: INTERNATIONAL " \
      'LOGISTICS LTD 456 SHIPPING LANE LOS ANGELES, CA 90001 USA TEL:1-213-9876543 ' \
      "FAX:1-213-9876544 ATTN: MR. JOHN DOE\nSignature: GLOBAL SHIPPING CO., " \
      "LTD.\nBY\nAS CARRIER"
    )
  end

  it 'parses a multiple page OCR response properly' do
    json_path = File.join(ocr_data_dir, 'ocr_multiple.json')
    json_sample = JSON.parse(File.read(json_path))

    response = Mindee::V2::Product::OCR::OCRResponse.new(json_sample)

    expect(response.inference).to be_a(Mindee::V2::Product::OCR::OCRInference)
    expect(response.inference.result).to be_a(Mindee::V2::Product::OCR::OCRResult)
    expect(response.inference.result.pages[0]).to be_a(Mindee::V2::Product::OCR::OCRPage)
    expect(response.inference.result.pages.size).to eq(3)

    page_zero_words = response.inference.result.pages[0].words
    expect(page_zero_words.size).to eq(295)
    expect(page_zero_words[0].content).to eq('FICTIOCORP')
    expect(page_zero_words[0].polygon[0][0]).to eq(0.06649402824332337)
    expect(page_zero_words[0].polygon[0][1]).to eq(0.03957449719523875)
    expect(page_zero_words[0].polygon[1][0]).to eq(0.23219061218068954)
    expect(page_zero_words[0].polygon[1][1]).to eq(0.03960015049938432)
    expect(page_zero_words[0].polygon[2][0]).to eq(0.23219061218068954)
    expect(page_zero_words[0].polygon[2][1]).to eq(0.06770762074155151)
    expect(page_zero_words[0].polygon[3][0]).to eq(0.06649402824332337)
    expect(page_zero_words[0].polygon[3][1]).to eq(0.06770762074155151)

    page_one_words = response.inference.result.pages[1].words
    expect(page_one_words.size).to eq(450)
    expect(page_one_words[0].content).to eq('KEOLIO')

    page_two_words = response.inference.result.pages[2].words
    expect(page_two_words.size).to eq(355)
    expect(page_two_words[0].content).to eq('KEOLIO')
  end
end
