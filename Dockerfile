FROM ubuntu:latest AS builder
RUN mkdir -p /opt/v2ray/ && \
    cd /opt/v2ray/ && \
    apt-get update && \
    apt-get install -y wget unzip && \
    V2RAY_OS="" && \
    V2RAY_ARCH="" && \
    if [ "$TARGETOS" = "linux" ]; then \
        V2RAY_OS="linux"; \
        if [ "$TARGETARCH" = "amd64" ]; then \
            V2RAY_ARCH="64"; \
        elif [ "$TARGETARCH" = "arm64" ]; then \
            V2RAY_ARCH="arm64-v8a"; \
        else \
            echo "Unsupported architecture: $TARGETARCH"; \
            exit 1; \
        fi; \
    else \
        echo "Unsupported OS: $TARGETOS"; \
        exit 1; \
    fi && \
    if [ -n "$V2RAY_OS" ] && [ -n "$V2RAY_ARCH" ]; then \
        wget --no-check-certificate -O v2ray.zip "https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-${V2RAY_OS}-${V2RAY_ARCH}.zip"; \
    fi && \
    unzip v2ray.zip

# fix missing root CA certificate in busybox
FROM alpine:latest as certs
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
