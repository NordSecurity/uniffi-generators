#!/bin/bash
set -euxo pipefail

SCRIPT_DIR="${SCRIPT_DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )}"
source "$SCRIPT_DIR/env.sh"

function cs_docker() {
    docker run --rm \
        -v $ROOT_DIR:/workspace \
        -w /workspace/compatibility-test/tmp/cs/UniffiCS.binding_tests \
        -e LD_LIBRARY_PATH=/workspace/target/debug \
        -e SKIP_FIXTURE_COPY=true \
        mcr.microsoft.com/dotnet/sdk:9.0 \
        $*
}

# Without TestingPlatformDotnetTestSupport, `dotnet test` on the .NET9 SDK
# builds the project without running any tests.
cs_docker dotnet test -p:TestingPlatformDotnetTestSupport=true -p:TestingPlatformShowTestsFailure=true
