#!/bin/bash
set -euxo pipefail

SCRIPT_DIR="${SCRIPT_DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )}"
source "$SCRIPT_DIR/env.sh"

# `--library` mode invokes `cargo metadata` command, and the first invocation in Docker container
# is quite slow, so batching all invocations in a single Docker container is much faster.

docker run --rm \
    --volume $ROOT_DIR:/workspace \
    --workdir /workspace/compatibility-test \
    ghcr.io/nordsecurity/uniffi-generators:v0.25.0-1 \
    /bin/bash /workspace/compatibility-test/setup_bindings_inner.sh
