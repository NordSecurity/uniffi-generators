#!/bin/bash
set -euxo pipefail

# Generate bindings for all languages inside container
LIBRARY="/workspace/target/debug/libcompatibility_test.so"    
uniffi-bindgen generate $LIBRARY --library --language python --out-dir tmp/python
uniffi-bindgen generate $LIBRARY --library --language kotlin --out-dir tmp/kotlin
uniffi-bindgen generate $LIBRARY --library --language swift --out-dir tmp/swift
uniffi-bindgen-cs $LIBRARY --library --out-dir tmp/cs/UniffiCS/generated
uniffi-bindgen-go $LIBRARY --library --out-dir tmp/go/generated
uniffi-bindgen-cpp $LIBRARY --library --out-dir tmp/cpp
