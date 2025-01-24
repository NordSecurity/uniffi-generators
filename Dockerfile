FROM rust:1.78-bullseye as builder
COPY . /project

# Download crates.io index, saves time if subsequent steps change
RUN cargo search --limit 1

RUN cd /project && cargo install --path uniffi-bindgen
RUN cargo install uniffi-bindgen-cs --tag v0.8.3+v0.25.0 --git https://github.com/NordSecurity/uniffi-bindgen-cs
RUN cargo install uniffi-bindgen-go --tag v0.2.2+v0.25.0 --git https://github.com/NordSecurity/uniffi-bindgen-go
RUN cargo install uniffi-bindgen-cpp --tag v0.6.4+v0.25.0 --git https://github.com/NordSecurity/uniffi-bindgen-cpp

FROM rust:1.78-bullseye
COPY --from=builder /usr/local/cargo/bin/uniffi-bindgen /bin
COPY --from=builder /usr/local/cargo/bin/uniffi-bindgen-cs /bin
COPY --from=builder /usr/local/cargo/bin/uniffi-bindgen-go /bin
COPY --from=builder /usr/local/cargo/bin/uniffi-bindgen-cpp /bin

RUN apt-get update && apt-get install -y --no-install-recommends python3 && apt-get clean && rm -rf /var/lib/apt/lists/*
