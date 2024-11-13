#!/bin/bash
set -euo pipefail

SCRIPT_DIR="${SCRIPT_DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )}"
source "$SCRIPT_DIR/env.sh"

# Disable logging commands to make the file download logs easy to read
set +x

# XD use docker to rm tmp directory as root. The tests run in Docker container, and create files
# in tmp directory as root.
docker run --rm \
    --volume "$ROOT_DIR":/workspace \
    alpine rm -rf /workspace/compatibility-test/tmp

download_file() {
    URL=$1
    DESTINATION_DIR=$2
    FILENAME=$(basename $URL)

    mkdir -p $DESTINATION_DIR

    echo "Download file"
    echo "    URL: $URL"
    echo "    INTO: $DESTINATION_DIR/$FILENAME"
    curl -f -s "$URL" > "$DESTINATION_DIR/$FILENAME"
    echo ""
}

GITHUB_VERSION="v0.25.0"
GITHUB_URL="https://raw.githubusercontent.com/mozilla/uniffi-rs/$GITHUB_VERSION"
download_file "$GITHUB_URL/fixtures/coverall/tests/bindings/test_coverall.kts"   "$TMP_DIR/kotlin"
download_file "$GITHUB_URL/fixtures/coverall/tests/bindings/test_coverall.py"    "$TMP_DIR/python"
download_file "$GITHUB_URL/fixtures/coverall/tests/bindings/test_coverall.swift" "$TMP_DIR/swift"

GITHUB_VERSION="v0.8.3+v0.25.0"
GITHUB_URL="https://raw.githubusercontent.com/NordSecurity/uniffi-bindgen-cs/$GITHUB_VERSION"
download_file "$GITHUB_URL/dotnet-tests/UniffiCS.BindingTests/TestCoverall.cs"                 "$TMP_DIR/cs/UniffiCS.binding_tests"
download_file "$GITHUB_URL/dotnet-tests/UniffiCS.BindingTests/UniffiCS.BindingTests.csproj"    "$TMP_DIR/cs/UniffiCS.binding_tests"
download_file "$GITHUB_URL/dotnet-tests/UniffiCS.BindingTests/Usings.cs"                       "$TMP_DIR/cs/UniffiCS.binding_tests"
download_file "$GITHUB_URL/dotnet-tests/UniffiCS/UniffiCS.csproj"                              "$TMP_DIR/cs/UniffiCS"

GITHUB_VERSION="v0.2.2+v0.25.0"
GITHUB_URL="https://raw.githubusercontent.com/NordSecurity/uniffi-bindgen-go/$GITHUB_VERSION"
download_file "$GITHUB_URL/binding_tests/coverall_test.go" "$TMP_DIR/go"
download_file "$GITHUB_URL/binding_tests/go.mod"           "$TMP_DIR/go"
download_file "$GITHUB_URL/binding_tests/go.sum"           "$TMP_DIR/go"

GITHUB_VERSION="v0.6.1+v0.25.0"
GITHUB_URL="https://raw.githubusercontent.com/NordSecurity/uniffi-bindgen-cpp/$GITHUB_VERSION"
download_file "$GITHUB_URL/cpp-tests/tests/coverall/main.cpp" "$TMP_DIR/cpp/coverall"
download_file "$GITHUB_URL/cpp-tests/include/test_common.hpp" "$TMP_DIR/cpp/include"
