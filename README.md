# docker-v2ray-websocket

V2Ray WebSocket in Docker container

## Usage

With Docker CLI:

```bash
docker run \
  -d \
  -p 80:80 \
  --name v2ray-websocket \
  --restart always \
  -e UUID="2a028f3e-03df-43e0-a13d-de2e8049f74d" \
  imbytecat/v2ray-websocket:latest
```

With Docker Compose:

```yaml
services:
  v2ray-websocket:
    image: imbytecat/v2ray-websocket
    container_name: v2ray-websocket
    environment:
      UUID: 2a028f3e-03df-43e0-a13d-de2e8049f74d
    ports:
      - 80:80
    restart: always
```
