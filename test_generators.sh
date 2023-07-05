#!/bin/bash
set -euo pipefail


# Run compatibility tests for all generators
# You can either run this script with -bd flags
# to build the test library and docker image
# or you can build them manually and then run this script.
# To build them manually you need to:
# 1. Build test library in debug mode by running:
#    cargo build --package compatibility-test
#    in the root of this repo
# 2. Build the docker image with generators by running:
#    docker build -t generators:test .
#    in the root of this repo
#
# NOTE:
#   Building library with this script by adding -b
#   is beneficial because the built library will be
#   compatibile with docker images used to run tests.
#   It is possible that the version built locally might
#   be not compatible e.g. when the version of GLIBC on
#   your system is newer than the one in the docker image.


if [[ $EUID -ne 0 ]]; then
    echo "$0 must be run as root. Otherwise there is a problem with permissions of files created inside docker containers. Try using sudo."
    exit 1
fi

usage() { echo -e "Usage: $0 [-b] [-d]\n  -b  - build test library\n  -d  - build docker image" 1>&2; exit 1; }

BUILD_LIBS=0
BUILD_DOCKER=0

while getopts "bd" o; do
    case "${o}" in
        b)
            BUILD_LIBS=1
            ;;
        d)
            BUILD_DOCKER=1
            ;;
        *)
            usage
            ;;
    esac
done

SCRIPT_DIR="${SCRIPT_DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )}"
ROOT_DIR="$SCRIPT_DIR"
TESTS_DIR="$ROOT_DIR/compatibility-test/tests"
TMP_DIR="$ROOT_DIR/compatibility-test/tmp"

# Build test library:
function build_docker() {
    docker run --rm \
        -v $ROOT_DIR:/workspace \
        -w /workspace \
        rust:1.64.0-slim-bullseye \
        $*
}

if [ $BUILD_LIBS -eq 1 ]; then
    build_docker cargo build --package compatibility-test
fi


# Build docker image with generators:
if [ $BUILD_DOCKER -eq 1 ]; then
    docker build -t generators:test .
fi


# Generate bindings for all languages:
function bindings_docker() {
    docker run --rm \
        -v $ROOT_DIR:/workspace \
        -w /workspace/compatibility-test \
        generators:test \
        $*
}

UDL_FILE="src/coverall.udl"
bindings_docker uniffi-bindgen generate $UDL_FILE --language python --out-dir "tmp/python"
bindings_docker uniffi-bindgen generate $UDL_FILE --language kotlin --out-dir "tmp/kotlin"
bindings_docker uniffi-bindgen generate $UDL_FILE --language swift --out-dir "tmp/swift"
bindings_docker uniffi-bindgen-cs $UDL_FILE --out-dir "tmp/cs" --config="uniffi.toml"
bindings_docker uniffi-bindgen-go $UDL_FILE --out-dir "tmp/go"


# Python tests:
function python_docker() {
    docker run --rm \
        -v $ROOT_DIR:/workspace \
        -w /workspace/compatibility-test/tmp/python \
        python:3.10-slim-bookworm \
        $*
}

cp $TESTS_DIR/python/* $TMP_DIR/python
cp $ROOT_DIR/target/debug/libuniffi_coverall.so $TMP_DIR/python
python_docker python3 -m unittest discover -v


# Kotlin tests:
function kotlin_docker() {
    docker run --rm \
        -v $ROOT_DIR:/workspace \
        -w /workspace/compatibility-test/tmp/kotlin \
        -e LD_LIBRARY_PATH=/workspace/target/debug \
        schlaubiboy/kotlin:1.9.0-jdk16-debian \
        $*
}

cp $TESTS_DIR/kotlin/* $TMP_DIR/kotlin
curl -L "https://repo1.maven.org/maven2/net/java/dev/jna/jna/5.7.0/jna-5.7.0.jar" -o $TMP_DIR/kotlin/jna.jar
kotlin_docker kotlinc -Werror -d coverall.jar uniffi/coverall/coverall.kt -classpath ".:jna.jar"
kotlin_docker kotlinc -Werror -classpath ".:jna.jar:coverall.jar" -J-ea -script test_coverall.kts


# Swift tests:
function swift_docker() {
    docker run --rm \
        -v $ROOT_DIR:/workspace \
        -w /workspace/compatibility-test/tmp/swift \
        -e LD_LIBRARY_PATH=/workspace/target/debug \
        swift:5.7 \
        $*
}

cp $TESTS_DIR/swift/* $TMP_DIR/swift
pushd $TMP_DIR/swift
mkdir -p coverallFFI
cp coverallFFI.h coverallFFI/
cp coverallFFI.modulemap coverallFFI/module.modulemap
popd

swift_docker swiftc -v -emit-module -module-name coverall -o libtestmod.so -emit-library -Xcc -fmodule-map-file=coverallFFI/module.modulemap -I . -L /workspace/target/debug -luniffi_coverall coverall.swift
swift_docker swift -I . -L . -ltestmod -luniffi_coverall -Xcc -fmodule-map-file=coverallFFI/module.modulemap test_coverall.swift


# C# tests:
function cs_docker() {
    docker run --rm \
        -v $ROOT_DIR:/workspace \
        -w /workspace/compatibility-test/tmp/cs \
        -e LD_LIBRARY_PATH=/workspace/target/debug \
        mcr.microsoft.com/dotnet/sdk:6.0-jammy \
        $*
}

cp $TESTS_DIR/cs/* $TMP_DIR/cs
cs_docker dotnet test -l "console;verbosity=normal"


# Go tests:
function go_docker() {
    docker run --rm \
        -v $ROOT_DIR:/workspace \
        -w /workspace/compatibility-test/tmp/go \
        -e CGO_ENABLED=1 \
        -e CGO_LDFLAGS="-luniffi_coverall -L/workspace/target/debug -ldl -lm" \
        -e LD_LIBRARY_PATH=/workspace/target/debug \
        golang:1.20 \
        $*
}

cp $TESTS_DIR/go/* $TMP_DIR/go
go_docker go test -v


# Clean up:
rm -rf $TMP_DIR
echo Compatibility tests passed!
