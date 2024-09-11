# [imbytecat/v2ray-websocket](https://github.com/imbytecat/docker-v2ray-websocket)

![](https://github.com/imbytecat/docker-v2ray-websocket/actions/workflows/build.yaml/badge.svg)

V2Ray WebSocket in Docker container.

## Usage

With Docker CLI:

```bash
docker run \
  -d \
  -p 80:80 \
  --name v2ray-websocket \
  --restart unless-stopped \
  -e UUID=<your-uuid> \
  imbytecat/v2ray-websocket:latest
```

With Docker Compose:

```yaml
services:
  v2ray-websocket:
    image: imbytecat/v2ray-websocket:latest
    container_name: v2ray-websocket
    environment:
      UUID: <your-uuid>
    ports:
      - 80:80
    restart: unless-stopped
```
