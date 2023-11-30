#!/bin/bash
set -euxo pipefail

SCRIPT_DIR="${SCRIPT_DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )}"
source "$SCRIPT_DIR/env.sh"

function swift_docker() {
    docker run --rm \
        -v $ROOT_DIR:/workspace \
        -w /workspace/compatibility-test/tmp/swift \
        -e LD_LIBRARY_PATH=/workspace/target/debug \
        swift:5.7 \
        $*
}

pushd $TMP_DIR/swift
mkdir -p coverallFFI
cp coverallFFI.h coverallFFI/
cp coverallFFI.modulemap coverallFFI/module.modulemap
popd

swift_docker swiftc -v -emit-module -module-name coverall -o libtestmod.so -emit-library -Xcc -fmodule-map-file=coverallFFI/module.modulemap -I . -L /workspace/target/debug -lcompatibility_test coverall.swift
swift_docker swift -I . -L . -ltestmod -lcompatibility_test -Xcc -fmodule-map-file=coverallFFI/module.modulemap test_coverall.swift
