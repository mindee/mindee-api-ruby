#!/bin/sh
set -e

TEST_FILE=$1
RID=$2

# Initialize rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$($HOME/.rbenv/bin/rbenv init -)"

if [ -z "$TEST_FILE" ]; then
  echo "Error: no sample file provided"
  exit 1
fi

if [ -z "$RID" ]; then
  OS_NAME="$(uname -s)"
  case "$OS_NAME" in
    Linux*)     RID="linux-x64" ;;
    Darwin*)    RID="osx-x64" ;;
    CYGWIN*|MINGW*|MSYS*) RID="win-x64" ;;
    *)
      echo ""
      echo "Error: Could not determine default Runtime Identifier (RID) for OS type '$OS_NAME'."
      echo "Please provide one manually. Available: 'linux-x64', 'osx-x64', 'win-x64'"
      exit 1
      ;;
  esac
  echo "Warning: Runtime Identifier (RID) not provided, defaulting to $RID"
fi

WD="$(basename "$PWD")"
if [ "$WD" = "spec" ]; then
  CLI_PATH="../bin/mindee.rb"
else
  CLI_PATH="./bin/mindee.rb"
fi

echo "--- Test model list retrieval (all models)"
MODELS=$("$CLI_PATH" v2 search-models)
if [ -z "$MODELS" ]; then
  echo "Error: no models found"
  exit 1
else
  echo "Models retrieval OK"
fi


run_search() {
  model_type="$1"

  echo "--- Test model list retrieval - model_type filter ($model_type models)"
  MODELS=$("$CLI_PATH" v2 search-models -t "$model_type")
  if [ -z "$MODELS" ]; then
    echo "Error: no models found"
    exit 1
  else
    echo "'$MODELS' Models retrieval OK"
  fi
  sleep 0.5
}
run_search "classification"
run_search "crop"
run_search "extraction"
run_search "ocr"
run_search "split"

echo "--- Test model list retrieval - name filter (non-existent model)"
NO_MODELS=$("$CLI_PATH" v2 search-models -n "supercalifragilisticexpialidocious")
if [ "$NO_MODELS" ]; then
  echo "Model shouldn't exist"
  exit 1
else
  echo "Non-existent models retrieval OK"
fi


echo "--- Test model list retrieval - name filter"
FINDOC_MODELS=$("$CLI_PATH" v2 search-models -n "findoc")
if [ -z "$FINDOC_MODELS" ]; then
  echo "Error: no models found"
  exit 1
else
  echo "Findoc models retrieval OK"
fi


echo "--- Test model list retrieval - name and model_type filter (findoc + extraction)"
FINDOC_MODELS=$("$CLI_PATH" v2 search-models -n "findoc" -t "extraction")
if [ -z "$FINDOC_MODELS" ]; then
  echo "Error: no models found"
  exit 1
else
  echo "Findoc models retrieval OK"
fi

echo "--- Test model list retrieval - model_type filter (invalid models)"
set +e
INVALID_MODELS_OUTPUT=$("$CLI_PATH" v2 search-models -t "invalid" 2>&1)
INVALID_MODELS_STATUS=$?
set -e

if [ "$INVALID_MODELS_STATUS" -eq 0 ]; then
  echo "Error: expected search-models to fail with an invalid model type"
  exit 1
elif ! echo "$INVALID_MODELS_OUTPUT" | grep -q "HTTP 422"; then
  echo "Error: expected HTTP 422 for invalid model type"
  echo "$INVALID_MODELS_OUTPUT"
  exit 1
else
  echo "Error retrieval OK"
fi





MODELS_SIZE=5
i=1

run_test() {
  model_id="$1"
  model_type="$2"

  echo "--- Test $model_type (ID: $model_id) with Summary Output ($i/$MODELS_SIZE) ---"
  SUMMARY_OUTPUT=$("$CLI_PATH" v2 "$model_type" -m "$model_id" "$TEST_FILE")
  echo "$SUMMARY_OUTPUT"
  echo ""
  echo ""
  sleep 0.5

  i=$((i + 1))
}

echo "--- Test URL file $MINDEE_V2_SE_TESTS_BLANK_PDF_URL ---"
SUMMARY_OUTPUT=$("$CLI_PATH" v2 "extraction" -m "$MINDEE_V2_SE_TESTS_FINDOC_MODEL_ID" "$MINDEE_V2_SE_TESTS_BLANK_PDF_URL")
echo "$SUMMARY_OUTPUT"
echo ""
echo ""

run_test "$MINDEE_V2_SE_TESTS_CLASSIFICATION_MODEL_ID" "classification"
run_test "$MINDEE_V2_SE_TESTS_CROP_MODEL_ID" "crop"
run_test "$MINDEE_V2_SE_TESTS_FINDOC_MODEL_ID" "extraction"
run_test "$MINDEE_V2_SE_TESTS_OCR_MODEL_ID" "ocr"
run_test "$MINDEE_V2_SE_TESTS_SPLIT_MODEL_ID" "split"
