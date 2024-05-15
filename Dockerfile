# --platform=$BUILDPLATFORM
FROM rust:1.78 AS buildbase
WORKDIR /app
RUN <<EOT bash
 set -ex
 apt-get update
 apt-get install -y \
     git \
     clang
 rustup target add wasm32-wasi
EOT

FROM buildbase AS build
COPY Cargo.toml .
COPY src ./src
# Build the Wasm binary
RUN cargo build --target wasm32-wasi --release
# This line builds the AOT Wasm binary
RUN cp target/wasm32-wasi/release/wasmedge-server.wasm wasmedge-server.wasm
RUN chmod a+x wasmedge-server.wasm

FROM wasmedge/slim-runtime:0.13.5
COPY --from=build /app/wasmedge-server.wasm /wasmedge-server.wasm
CMD ["wasmedge", "--dir", ".:/", "/wasmedge-server.wasm"]