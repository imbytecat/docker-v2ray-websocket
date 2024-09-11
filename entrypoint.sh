#!/bin/sh
cat >/etc/v2ray/config.json <<EOF
{
  "inbounds": [
    {
      "tag": "vmess-ws",
      "port": 80,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${UUID}",
            "alterId": 0
          }
        ]
      },
      "streamSettings": {
        "network": "ws"
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF
v2ray run -config=/etc/v2ray/config.json
