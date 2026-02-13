FROM rust:1.85.0-bullseye as builder
COPY . /project

# Download crates.io index, saves time if subsequent steps change
RUN cargo search --limit 1

RUN cd /project && cargo install --path uniffi-bindgen
RUN cargo install uniffi-bindgen-cs --tag v0.9.2+v0.28.3 --git https://github.com/NordSecurity/uniffi-bindgen-cs
RUN cargo install uniffi-bindgen-go --tag v0.4.0+v0.28.3 --git https://github.com/NordSecurity/uniffi-bindgen-go
RUN cargo install uniffi-bindgen-cpp --tag v0.7.2+v0.28.3 --git https://github.com/NordSecurity/uniffi-bindgen-cpp
RUN cargo install uniffi-bindgen-react-native --tag 0.28.3-5 --git https://github.com/jhugman/uniffi-bindgen-react-native.git

FROM rust:1.85.0-bullseye
COPY --from=builder /usr/local/cargo/bin/uniffi-bindgen /bin
COPY --from=builder /usr/local/cargo/bin/uniffi-bindgen-cs /bin
COPY --from=builder /usr/local/cargo/bin/uniffi-bindgen-go /bin
COPY --from=builder /usr/local/cargo/bin/uniffi-bindgen-cpp /bin
COPY --from=builder /usr/local/cargo/bin/uniffi-bindgen-react-native /bin

RUN apt-get update && apt-get install -y --no-install-recommends python3 && apt-get clean && rm -rf /var/lib/apt/lists/*
