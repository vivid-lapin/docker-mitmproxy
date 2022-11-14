FROM --platform=$BUILDPLATFORM python:3.9.15-slim-buster AS base
RUN apt update \
    && apt full-upgrade -y \
    && apt install -y --no-install-recommends \
    tzdata \
    ca-certificates \
    curl \
    && curl https://sh.rustup.rs -sSf | sh \
    && export PATH="/root/.cargo/bin:$PATH" \
    && pip3 install mitmproxy google-cloud-pubsub protobuf \
    && rustup self uninstall \
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists

LABEL org.opencontainers.image.source https://github.com/vivid-lapin/docker-mitmproxy
EXPOSE 8080
EXPOSE 8081
HEALTHCHECK --interval=5m --timeout=3s \
    CMD curl -f -H "Host: mitm.it" http://localhost:8080
CMD ["mitmproxy"]
