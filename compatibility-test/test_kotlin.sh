#!/bin/bash
set -euxo pipefail

SCRIPT_DIR="${SCRIPT_DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )}"
source "$SCRIPT_DIR/env.sh"

function kotlin_docker() {
    docker run --rm \
        -v $ROOT_DIR:/workspace \
        -w /workspace/compatibility-test/tmp/kotlin \
        -e LD_LIBRARY_PATH=/workspace/target/debug \
        schlaubiboy/kotlin:1.9.0-jdk16-debian \
        $*
}

curl -L "https://repo1.maven.org/maven2/net/java/dev/jna/jna/5.7.0/jna-5.7.0.jar" -o $TMP_DIR/kotlin/jna.jar
kotlin_docker kotlinc -Werror -d coverall.jar uniffi/coverall/coverall.kt -classpath ".:jna.jar"
kotlin_docker kotlinc -Werror -classpath ".:jna.jar:coverall.jar" -J-ea -script test_coverall.kts
