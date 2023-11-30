#!/bin/bash
set -euxo pipefail

SCRIPT_DIR="${SCRIPT_DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )}"
source "$SCRIPT_DIR/env.sh"

function go_docker() {
    docker run --rm \
        -v $ROOT_DIR:/workspace \
        -w /workspace/compatibility-test/tmp/go \
        -e CGO_ENABLED=1 \
        -e CGO_LDFLAGS="-lcompatibility_test -L/workspace/target/debug -ldl -lm" \
        -e LD_LIBRARY_PATH=/workspace/target/debug \
        golang:1.20 \
        $*
}

go_docker go test -v
