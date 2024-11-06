# syntax = docker/dockerfile:experimental
FROM --platform=$TARGETPLATFORM python:3.12.7-slim-bookworm AS base
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
    && pip3 install mitmproxy==11.0.0 google-cloud-pubsub==2.26.1 protobuf==5.28.2 msgpack==1.1.0 \
    && apt purge -y build-essential gosu \
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists

WORKDIR /app

LABEL org.opencontainers.image.source https://github.com/vivid-lapin/docker-mitmproxy
EXPOSE 8080 8081
HEALTHCHECK --interval=5m --timeout=3s \
    CMD curl -f -H "Host: mitm.it" http://localhost:8080
CMD ["mitmproxy"]
