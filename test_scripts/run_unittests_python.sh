#!/bin/bash

set -e

# Check if subfolder name is provided
if [ -z "$1" ]; then
  echo "Error: No subfolder name provided."
  echo "Usage: $0 <subfolder_name>"
  exit 1
fi

BUILD_SUBFOLDER=.tmp/python_"$1"

echo "Setting up Python build subfolder: $BUILD_SUBFOLDER"

rm -rf "$BUILD_SUBFOLDER"
mkdir -p "$BUILD_SUBFOLDER"

cp -R "$1"/* "$BUILD_SUBFOLDER"

cd "$BUILD_SUBFOLDER" || { echo "Error: Cannot enter $BUILD_SUBFOLDER"; exit 2; }

echo "Creating virtual environment..."
python3 -m venv .venv

echo "Installing dependencies..."
if [ -f "requirements.txt" ]; then
  ./.venv/bin/pip install --upgrade pip -q
  ./.venv/bin/pip install -r requirements.txt -q
else
  echo "Warning: No requirements.txt found"
fi

echo "Running Python unit tests with pytest..."
./.venv/bin/pytest -v
exit $?
