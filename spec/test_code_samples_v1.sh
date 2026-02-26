#! /bin/sh
set -e

OUTPUT_FILE='./_test_v1.rb'

if [ -z "${MINDEE_ACCOUNT_SE_TESTS}" ]; then echo "MINDEE_ACCOUNT_SE_TESTS is required"; exit 1; fi
if [ -z "${MINDEE_ENDPOINT_SE_TESTS}" ]; then echo "MINDEE_ENDPOINT_SE_TESTS is required"; exit 1; fi

for f in $(find ./docs/code_samples -maxdepth 1 -name "*.txt" -not -name "workflow_*.txt" -not -name "v2_*" | sort -h)
do
  echo
  echo "###############################################"
  echo "${f}"
  echo "###############################################"
  echo

  sed "s/my-api-key/${MINDEE_API_KEY_SE_TESTS}/" "$f" > $OUTPUT_FILE
  sed -i 's/\/path\/to\/the\/file.ext/.\/spec\/data\/file_types\/pdf\/blank_1.pdf/' $OUTPUT_FILE

  if echo "$f" | grep -q "custom_v1.txt"
  then
    sed -i "s/my-account/$MINDEE_ACCOUNT_SE_TESTS/g" $OUTPUT_FILE
    sed -i "s/my-endpoint/$MINDEE_ENDPOINT_SE_TESTS/g" $OUTPUT_FILE
  fi
  if echo "${f}" | grep -q "default.txt"
  then
    sed -i "s/my-account/$MINDEE_ACCOUNT_SE_TESTS/g" $OUTPUT_FILE
    sed -i "s/my-endpoint/$MINDEE_ENDPOINT_SE_TESTS/g" $OUTPUT_FILE
    sed -i "s/my-version/1/g" $OUTPUT_FILE
  fi

  if echo "${f}" | grep -q "default_async.txt"
  then
    sed -i "s/my-account/mindee/" $OUTPUT_FILE
    sed -i "s/my-endpoint/invoice_splitter/" $OUTPUT_FILE
    sed -i "s/my-version/1/" $OUTPUT_FILE
  fi

  bundle exec ruby $OUTPUT_FILE
done
