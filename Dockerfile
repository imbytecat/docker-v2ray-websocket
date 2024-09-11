FROM ubuntu:latest AS builder
RUN mkdir -p /opt/v2ray/ && \
    cd /opt/v2ray/ && \
    apt-get update && \
    apt-get install -y wget unzip && \
    wget --no-check-certificate -O v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip && \
    unzip v2ray.zip

# busybox 缺失根 CA 证书
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
