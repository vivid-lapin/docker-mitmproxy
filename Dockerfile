FROM --platform=$BUILDPLATFORM python:3.9.15-alpine3.16 AS base
RUN pip3 install mitmproxy google-cloud-pubsub protobuf

LABEL org.opencontainers.image.source https://github.com/vivid-lapin/docker-mitmproxy
EXPOSE 8080
EXPOSE 8081
HEALTHCHECK --interval=5m --timeout=3s \
    CMD curl -f -H "Host: mitm.it" http://localhost:8080
CMD ["mitmproxy"]
