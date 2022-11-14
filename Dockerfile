# syntax = docker/dockerfile:experimental
FROM --platform=$TARGETPLATFORM python:3.9.15-slim-buster AS base
ENV DEBIAN_FRONTEND "noninteractive"
RUN apt-get update \
    && apt-get install -y --no-install-recommends gosu \
    && pip3 install mitmproxy==8.1.1 google-cloud-pubsub protobuf \
    && rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.source https://github.com/vivid-lapin/docker-mitmproxy
EXPOSE 8080 8081
HEALTHCHECK --interval=5m --timeout=3s \
    CMD curl -f -H "Host: mitm.it" http://localhost:8080
CMD ["mitmproxy"]
