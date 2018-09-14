# Coturn server

    docker build -t linagora/coturn .

## Hublin ICE servers

```
    "appIceServers": [
        {"url": "stun:openpaas-conf.prod1.linagora.com:3478"},
        {"url": "turn:openpaas-conf.prod1.linagora.com:3478", "username": "username1", "credential": "key1"}
    ]
```

TODO:

- Certificates
- Realm

