#!/bin/sh
set -e

TEST_FILE=$1
RID=$2

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

echo "--- Test extraction with no additional args"
SUMMARY_OUTPUT=$("$CLI_PATH" v2 extraction -m "$MINDEE_V2_SE_TESTS_FINDOC_MODEL_ID" "$TEST_FILE")
if [ -z "$SUMMARY_OUTPUT" ]; then
  echo "Error: no extraction output"
  exit 1
else
  echo "Extraction retrieval OK"
fi
