#! /bin/sh
set -e

OUTPUT_FILE='./_test_v2.rb'
API_KEY_V2=$1
FINDOC_MODEL_ID=$2
WEBHOOK_ID=$3
CLASSIFICATION_MODEL_ID=$4
CROP_MODEL_ID=$5
OCR_MODEL_ID=$6
SPLIT_MODEL_ID=$7

if [ -z "${FINDOC_MODEL_ID}" ]; then echo "FINDOC_MODEL_ID is required"; exit 1; fi
if [ -z "${WEBHOOK_ID}" ]; then echo "WEBHOOK_ID is required"; exit 1; fi

for f in $(find ./docs/code_samples -maxdepth 1 -name "v2_*.txt" | sort -h)
do
  echo
  echo "###############################################"
  echo "${f}"
  echo "###############################################"
  echo

  cat "${f}" > $OUTPUT_FILE
  sed -i "s/MY_API_KEY/$API_KEY_V2/" $OUTPUT_FILE
  sed -i "s/MY_WEBHOOK_ID/$WEBHOOK_ID/" $OUTPUT_FILE
  sed -i 's/\/path\/to\/the\/file.ext/.\/spec\/data\/file_types\/pdf\/blank_1.pdf/' $OUTPUT_FILE

  if echo "${f}" | grep -q "v2_default.txt"
  then
    sed -i "s/MY_MODEL_ID/$FINDOC_MODEL_ID/" $OUTPUT_FILE
  fi

  if echo "${f}" | grep -q "v2_default_webhook.txt"
  then
    sed -i "s/MY_MODEL_ID/$FINDOC_MODEL_ID/" $OUTPUT_FILE
  fi

  if echo "${f}" | grep -q "v2_classification.txt"
  then
    sed -i "s/MY_MODEL_ID/$CLASSIFICATION_MODEL_ID/" $OUTPUT_FILE
  fi

  if echo "${f}" | grep -q "v2_crop.txt"
  then
    sed -i "s/MY_MODEL_ID/$CROP_MODEL_ID/" $OUTPUT_FILE
  fi

  if echo "${f}" | grep -q "v2_ocr.txt"
  then
    sed -i "s/MY_MODEL_ID/$OCR_MODEL_ID/" $OUTPUT_FILE
  fi

  if echo "${f}" | grep -q "v2_split.txt"
  then
    sed -i "s/MY_MODEL_ID/$SPLIT_MODEL_ID/" $OUTPUT_FILE
  fi

  bundle exec ruby $OUTPUT_FILE
done
