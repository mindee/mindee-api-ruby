#!/bin/sh
set -e

# Initialize rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$($HOME/.rbenv/bin/rbenv init -)"

TEST_FILE=$1
RID=$2

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

if [ "$RID" = "win-x64" ]; then
  CLI_PATH="${CLI_PATH}.exe"
fi

PRODUCTS="financial-document receipt invoice invoice-splitter"
PRODUCTS_SIZE=4
i=1

for product in $PRODUCTS
do
  echo "--- Test $product with Summary Output ($i/$PRODUCTS_SIZE) ---"
  SUMMARY_OUTPUT=$(ruby "$CLI_PATH" v1 "$product" "$TEST_FILE")
  echo "$SUMMARY_OUTPUT"
  echo ""
  echo ""
  sleep 0.5
  i=$((i + 1))
done
