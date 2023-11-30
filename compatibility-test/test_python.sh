#!/bin/bash
set -euxo pipefail

SCRIPT_DIR="${SCRIPT_DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )}"
source "$SCRIPT_DIR/env.sh"

function python_docker() {
    docker run --rm \
        -v $ROOT_DIR:/workspace \
        -w /workspace/compatibility-test/tmp/python \
        python:3.10-slim-bookworm \
        $*
}

cp $ROOT_DIR/target/debug/libcompatibility_test.so $TMP_DIR/python
python_docker python3 -m unittest discover -v
