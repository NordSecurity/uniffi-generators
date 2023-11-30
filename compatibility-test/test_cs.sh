#!/bin/bash
set -euxo pipefail

SCRIPT_DIR="${SCRIPT_DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )}"
source "$SCRIPT_DIR/env.sh"

function cs_docker() {
    docker run --rm \
        -v $ROOT_DIR:/workspace \
        -w /workspace/compatibility-test/tmp/cs/UniffiCS.binding_tests \
        -e LD_LIBRARY_PATH=/workspace/target/debug \
        mcr.microsoft.com/dotnet/sdk:6.0 \
        $*
}

cs_docker dotnet test -l "console;verbosity=normal"
