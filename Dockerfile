FROM ghcr.io/automata-network/automata-sgx-sdk:v0.2_ubuntu-20.04

WORKDIR /workspace

ARG CACHE_DATE=1

RUN --mount=type=cache,target=/root/.cargo/registry/index \
    --mount=type=cache,target=/root/.cargo/registry/cache \
    --mount=type=cache,target=/root/.cargo/git \
    cargo install cargo-sgx

COPY . /workspace/source

RUN --mount=type=cache,target=/root/.cargo/registry/index \
    --mount=type=cache,target=/root/.cargo/registry/cache \
    --mount=type=cache,target=/root/.cargo/git \
    cd /workspace/source && cargo sgx run --release

RUN cp source/target/release/app-template /workspace
RUN cp source/target/release/*.signed.so /workspace
RUN rm -r source

ENTRYPOINT ["./app-template"]
