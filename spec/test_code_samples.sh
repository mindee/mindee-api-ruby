#! /bin/sh
set -e

OUTPUT_FILE='./_test.rb'
ACCOUNT=$1
ENDPOINT=$2
API_KEY=$3

for f in $(find ./docs/code_samples -maxdepth 1 -name "*.txt" | sort -h)
do
  echo
  echo "###############################################"
  echo "${f}"
  echo "###############################################"
  echo

  sed "s/my-api-key/${API_KEY}/" "$f" > $OUTPUT_FILE
  sed -i 's/\/path\/to\/the\/file.ext/.\/spec\/data\/pdf\/blank_1.pdf/' $OUTPUT_FILE

  if echo "$f" | grep -q "custom_v1.txt"
  then
    sed -i "s/my-account/$ACCOUNT/g" $OUTPUT_FILE
    sed -i "s/my-endpoint/$ENDPOINT/g" $OUTPUT_FILE
  fi
  bundle exec ruby $OUTPUT_FILE
done
