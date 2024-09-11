FROM ubuntu:latest AS builder
RUN mkdir -p /opt/v2ray/ && \
    cd /opt/v2ray/ && \
    apt-get update && \
    apt-get install -y wget unzip && \
    V2RAY_PLATFORM="" && \
    if [ "$TARGETOS" = "linux" ] && [ "$TARGETARCH" = "amd64" ]; then \
    V2RAY_PLATFORM="linux-64"; \
    elif [ "$TARGETOS" = "linux" ] && [ "$TARGETARCH" = "amd64" ]; then \
    V2RAY_PLATFORM="linux-arm64-v8a"; \
    else \
    echo "Unsupported platform: $TARGETPLATFORM"; \
    exit 1; \
    fi && \
    wget --no-check-certificate -O v2ray.zip "https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-${V2RAY_PLATFORM}.zip"; \
    unzip v2ray.zip

# fix missing root CA certificate in busybox
FROM alpine:latest AS certs
RUN apk update && \
    apk add ca-certificates

FROM busybox:latest AS rootfs
COPY --from=builder --chmod=777 /opt/v2ray/v2ray /usr/bin/
COPY --chmod=777 entrypoint.sh /usr/bin/v2ray-websocket
COPY --from=certs /etc/ssl/certs/ /etc/ssl/certs/
RUN mkdir -p /etc/v2ray/

FROM scratch
COPY --from=rootfs / /
EXPOSE 80
ENTRYPOINT ["v2ray-websocket"]
