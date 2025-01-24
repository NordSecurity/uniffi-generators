# uniffi-generators - Hosting UniFFI bindings generators in docker images

Official UniFFI project provides binding generator for Kotlin, Swift, Python and Ruby. At
NordSecurity, we've created additional generators for C#, Go, and C++. This repository hosts Docker
images with all these generators in their compatible versions.

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
uniffi-bindgen-cpp src/definition.udl
```
For the exact instructions on how to run individual generators please visit their respective repositories:
- [uniffi-bindgen](https://github.com/NordSecurity/uniffi-rs)
- [uniffi-bindgen-cs](https://github.com/NordSecurity/uniffi-bindgen-cs)
- [uniffi-bindgen-go](https://github.com/NordSecurity/uniffi-bindgen-go)
- [uniffi-bindgen-cpp](https://github.com/NordSecurity/uniffi-bindgen-cpp)

*NOTE: `uniffi-bindgen` is a version-compatible fork of `mozilla/uniffi-rs`.*

# Contributing

For contribution guidelines, read [CONTRIBUTING.md](CONTRIBUTING.md).

# Versioning

This project is versioned in sync with `uniffi-rs`. Generators compatible with uniffi
version `v0.23.0` will be tagged `v0.23.0-X` in this repository. `X` will be incremented
each time one of the generators is updated e.g. because of a bug fix. The table below
shows which versions of each generator are inside the docker image.


| Docker image           | uniffi-rs version     | uniffi-bindgen-cs version | uniffi-bindgen-go version | uniffi-bindgen-cpp version |
|------------------------|-----------------------|---------------------------|---------------------------|----------------------------|
| v0.25.0-14             | v0.3.3+v0.25.0        | v0.8.3+v0.25.0            | v0.2.2+v0.25.0            | **v0.6.4+v0.25.0**         |
| v0.25.0-14             | **v0.3.3+v0.25.0**    | v0.8.3+v0.25.0            | v0.2.2+v0.25.0            | v0.6.1+v0.25.0             |
| v0.25.0-13             | v0.3.2+v0.25.0        | v0.8.3+v0.25.0            | **v0.2.2+v0.25.0**        | v0.6.1+v0.25.0             |
| v0.25.0-12             | **v0.3.2+v0.25.0**    | v0.8.3+v0.25.0            | v0.2.1+v0.25.0            | v0.6.1+v0.25.0             |
| v0.25.0-11             | v0.3.0+0.25.0         | **v0.8.3+v0.25.0**        | v0.2.1+v0.25.0            | v0.6.1+v0.25.0             |
| v0.25.0-10             | v0.3.0+0.25.0         | **v0.8.1+v0.25.0**        | v0.2.1+v0.25.0            | v0.6.1+v0.25.0             |
| v0.25.0-9              | v0.3.0+0.25.0         | v0.8.0+v0.25.0            | v0.2.1+v0.25.0            | **v0.6.1+v0.25.0**         |
| v0.25.0-8              | v0.3.0+0.25.0         | v0.8.0+v0.25.0            | v0.2.1+v0.25.0            | **v0.6.0+v0.25.0**         |
| v0.25.0-7              | v0.3.0+0.25.0         | v0.8.0+v0.25.0            | v0.2.1+v0.25.0            | **v0.5.0+v0.25.0**         |
| v0.25.0-6              | v0.3.0+0.25.0         | v0.8.0+v0.25.0            | v0.2.1+v0.25.0            | **v0.4.2+v0.25.0**         |
| v0.25.0-5              | v0.3.0+0.25.0         | v0.8.0+v0.25.0            | v0.2.1+v0.25.0            | **v0.4.1+v0.25.0**         |
| v0.25.0-4              | v0.3.0+0.25.0         | **v0.8.0+v0.25.0**        | **v0.2.1+v0.25.0**        | **v0.4.0+v0.25.0**         |
| v0.25.0-3              | v0.3.0+0.25.0         | v0.7.0+v0.25.0            | v0.2.0+v0.25.0            | **v0.3.0+v0.25.0**         |
| v0.25.0-2              | v0.3.0+0.25.0         | v0.7.0+v0.25.0            | v0.2.0+v0.25.0            | **v0.2.2+v0.25.0**         |
| v0.25.0-1              | **v0.3.0+0.25.0**     | **v0.7.0+v0.25.0**        | **v0.2.0+v0.25.0**        | **v0.1.0+v0.25.0**         |
| v0.23.0-6              | v0.23.0-3             | v0.4.0+v0.23.0            | v0.1.5+v0.23.0            | not present                |
| v0.23.0-5              | v0.23.0-3             | **v0.4.0+v0.23.0**        | **v0.1.5+v0.23.0**        | not present                |
| v0.23.0-4              | v0.23.0               | **v0.2.3+v0.23.0**        | **v0.1.3+v0.23.0**        | not present                |
| v0.23.0-3 (DO NOT USE) | v0.23.0               | **v0.2.2+v0.23.0**        | v0.1.0+v0.23.0            | not present                |
| v0.23.0-2 (DO NOT USE) | v0.23.0               | v0.2.1+v0.23.0            | **v0.1.0+v0.23.0**        | not present                |
| v0.23.0-1              | v0.23.0               | v0.2.1+v0.23.0            | not present               | not present                |

# Changelog

Version changelogs are available inside each individual project.

- [mozilla/uniffi-rs/CHANGELOG.md](https://github.com/mozilla/uniffi-rs/blob/main/CHANGELOG.md)
- [NordSecurity/uniffi-rs/CHANGELOG.md](https://github.com/NordSecurity/uniffi-rs/blob/main/CHANGELOG.md)
- [NordSecurity/uniffi-bindgen-cpp/CHANGELOG.md](https://github.com/NordSecurity/uniffi-bindgen-cpp/blob/main/CHANGELOG.md)
- [NordSecurity/uniffi-bindgen-cs/CHANGELOG.md](https://github.com/NordSecurity/uniffi-bindgen-cs/blob/main/CHANGELOG.md)
- [NordSecurity/uniffi-bindgen-go/CHANGELOG.md](https://github.com/NordSecurity/uniffi-bindgen-go/blob/main/CHANGELOG.md)

### v0.23.0-6

- Include `python3` installation in the *docker* image

### ~~v0.23.0-2~~, ~~v0.23.0-3~~

These versions are not ABI compatible with upstream, and should not be used.
