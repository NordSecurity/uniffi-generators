# uniffi-generators - Hosting UniFFI bindings generators in docker images

Official UniFFI project provides binding generator for Kotlin, Swift, Python and Ruby.
In Nord we've developed external generators for C# and Go.
This repository is hosting docker images that contain all three generators in the compatible versions.

# How to use

Start docker container with image from this repository e.g.:
```
ghcr.io/NordSecurity/uniffi-generators:v0.23.0-1
```
Inside docker you can run:
```
uniffi-bindgen generate src/definition.udl --language python
uniffi-bindgen-cs src/definition.udl
uniffi-bindgen-go src/definition.udl
```
For the exact instructions on how to run individual generators please visit their respective repositories:
[uniffi-bindgen](https://github.com/mozilla/uniffi-rs)
[uniffi-bindgen-cs](https://github.com/NordSecurity/uniffi-bindgen-cs)
[uniffi-bindgen-go](https://github.com/NordSecurity/uniffi-bindgen-go)

# Contributing

For contribution guidelines, read [CONTRIBUTING.md](CONTRIBUTING.md)

# Versioning

This project is versioned in sync with `uniffi-rs`. So e.g. generators compatible with uniffi
version `v0.23.0` will be tagged `v0.23.0-X` in this repository. `X` will be incremented
each time one of the generators is updated e.g. because of the bug fix. The table below
shows which versions of each generator are inside the docker image.


| Docker image   | uniffi-rs version | uniffi-bindgen-cs version | uniffi-bindgen-go version |
|----------------|-------------------|---------------------------|---------------------------|
| v0.23.0-3      | v0.23.0           | v0.2.2+v0.23.0            | v0.1.0+v0.23.0            |
| v0.23.0-2      | v0.23.0           | v0.2.1+v0.23.0            | v0.1.0+v0.23.0            |
| v0.23.0-1      | v0.23.0           | v0.2.1+v0.23.0            | not present               |
