# syntax = docker/dockerfile:experimental
FROM --platform=$TARGETPLATFORM python:3.9.15-slim-bullseye AS base
ENV DEBIAN_FRONTEND "noninteractive"
RUN --mount=type=tmpfs,target=/root/.cargo apt update \
    && apt full-upgrade -y \
    && apt install -y --no-install-recommends \
    tzdata \
    ca-certificates \
    curl \
    build-essential \
    libffi-dev \
    libssl-dev \
    gosu \
    python3-grpcio python3-grpc-tools \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y \
    && export PATH="$HOME/.cargo/bin:$PATH" \
    && pip3 install mitmproxy google-cloud-pubsub protobuf --no-binary=grpcio \
    && apt purge -y build-essential gosu \
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists $HOME/.rustup

WORKDIR /app

LABEL org.opencontainers.image.source https://github.com/vivid-lapin/docker-mitmproxy
EXPOSE 8080 8081
HEALTHCHECK --interval=5m --timeout=3s \
    CMD curl -f -H "Host: mitm.it" http://localhost:8080
CMD ["mitmproxy"]
