#!/bin/bash
set -euxo pipefail

SCRIPT_DIR="${SCRIPT_DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )}"
source "$SCRIPT_DIR/env.sh"

function cpp_docker() {
    docker run --rm \
        -v $ROOT_DIR:/workspace \
        -w /workspace/compatibility-test/tmp/cpp \
        -e LD_LIBRARY_PATH=/workspace/target/debug \
        gcc:10-bullseye \
        $*
}

cpp_docker g++ -std=c++20 coverall/main.cpp -I. -Iinclude -o test_coverall
cpp_docker ./test_coverall
