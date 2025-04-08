#!/bin/bash
set -euo pipefail

SCRIPT_DIR="${SCRIPT_DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )}"

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

usage() {
    echo -e "Usage: $0 [-b] [-d] [-g generator]"
    echo -e "  -b  - build test library"
    echo -e "  -d  - build docker image"
    echo -e "  -g  - test specific generator"
    exit 1
}

BUILD_LIBS=0
BUILD_DOCKER=0
GENERATOR=""

while getopts "bdg:" o; do
    case "${o}" in
        b)
            BUILD_LIBS=1
            ;;
        d)
            BUILD_DOCKER=1
            ;;
        g)
            GENERATOR="$OPTARG"
            ;;
        *)
            usage
            ;;
    esac
done

set -x

# Build test library:
function build_docker() {
    docker run --rm \
        -v $HOME/.cargo/registry:/usr/local/cargo/registry \
        -v $SCRIPT_DIR:/workspace \
        -w /workspace \
        rust:1.81-bullseye \
        $*
}

if [ $BUILD_LIBS -eq 1 ]; then
    build_docker cargo build --package compatibility-test
fi


# Build docker image with generators:
if [ $BUILD_DOCKER -eq 1 ]; then
    docker build -t generators:test .
fi

./compatibility-test/setup_test_source.sh

./compatibility-test/setup_bindings.sh

if [[ -z "$GENERATOR" || "$GENERATOR" = "python" ]]; then
    ./compatibility-test/test_python.sh
fi

if [[ -z "$GENERATOR" || "$GENERATOR" = "kotlin" ]]; then
    ./compatibility-test/test_kotlin.sh
fi

if [[ -z "$GENERATOR" || "$GENERATOR" = "swift" ]]; then
    ./compatibility-test/test_swift.sh
fi

if [[ -z "$GENERATOR" || "$GENERATOR" = "cs" ]]; then
    ./compatibility-test/test_cs.sh
fi

if [[ -z "$GENERATOR" || "$GENERATOR" = "go" ]]; then
    ./compatibility-test/test_go.sh
fi

if [[ -z "$GENERATOR" || "$GENERATOR" = "cpp" ]]; then
    ./compatibility-test/test_cpp.sh
fi

echo Compatibility tests passed!
