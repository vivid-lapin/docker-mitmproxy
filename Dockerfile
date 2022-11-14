FROM --platform=$TARGETPLATFORM python:3.9.15-slim-buster AS base
RUN apt update \
    && curl https://sh.rustup.rs -sSf | sh \
    && pip3 install mitmproxy google-cloud-pubsub protobuf \
    && rustup self uninstall

LABEL org.opencontainers.image.source https://github.com/vivid-lapin/docker-mitmproxy
EXPOSE 8080
EXPOSE 8081
HEALTHCHECK --interval=5m --timeout=3s \
    CMD curl -f -H "Host: mitm.it" http://localhost:8080
CMD ["mitmproxy"]
