# Deployment on janus.hubl.in

1. Let's encrypt update
2. Replace network and hostnames in docker-compose.yml from meet.jitsi to janus.hubl.in
3. Replace hostnames in .env from meet.jitsi to janus.hubl.in
4. Set the DOCKER_HOST_ADDRESS to local IP in .env 54.36.8.91 (this is the IP of janus-hublin.linagora.dc2)
5. Expose port 5280 from prosody for http-bind
6. Update /etc/nginx/sites-enabled/hublin.conf to add jitsi, http-bind and xmpp-websocket stuff:

```
upstream hublin {
    server localhost:8080;
    keepalive 8;
}

upstream janus {
    server 127.0.0.1:8089;
    keepalive 8;
}

upstream hublot {
    server localhost:3000;
    keepalive 8;
}

# Added for JITSI
upstream jitsi {
    server localhost:8000;
    keepalive 8;
}

# Added for JITSI
upstream http-bind {
    server localhost:5280;
    keepalive 8;
}

server {
        listen 80 default_server;
        listen [::]:80 default_server;
        server_name janus.hubl.in;
        return 301 https://$server_name$request_uri;
}

server {
     listen 443  ssl;
     listen [::]:443 ssl;
     server_name janus.hubl.in;

    # SSL configuration
     ssl_certificate     /etc/letsencrypt/live/janus.hubl.in/fullchain.pem;
     ssl_certificate_key /etc/letsencrypt/live/janus.hubl.in/privkey.pem;
     ssl_protocols             TLSv1.1 TLSv1.2;
     ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!3DES:!MD5:!PSK';
     ssl_prefer_server_ciphers on;
     ssl_dhparam /etc/ssl/certs/dhparam.pem;
     keepalive_timeout         70;
     ssl_session_cache         shared:SSL:10m;
     ssl_session_timeout       10m;

    location ~ /gateway/(.*)$ {
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-NginX-Proxy true;
        proxy_pass https://janus/$1;
        proxy_redirect off;
        proxy_buffering off;
    }

    location /hublot/ {
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-NginX-Proxy true;
        proxy_pass http://hublot/;
        proxy_redirect off;
        proxy_buffering off;
    }

    # Added for JITSI
    location /jitsi/ {
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-NginX-Proxy true;
        proxy_pass http://jitsi/;
        proxy_redirect off;
        proxy_buffering off;
    }

    # Added for JITSI
    location /http-bind {
        proxy_pass http://http-bind/http-bind;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $http_host;
        proxy_buffering off;
        tcp_nodelay on;
    }

    # Added for JITSI
    location /xmpp-websocket {
        proxy_pass http://localhost:5280;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        tcp_nodelay on;
    }

    location /demos/ {
        root /opt/janus/share/janus/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-NginX-Proxy true;
        proxy_redirect off;
        proxy_buffering off;
    }

    location / {
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-NginX-Proxy true;
        proxy_pass http://hublin/;
        proxy_redirect off;
        proxy_buffering off;
    }

}
```

## Troubleshooting

If it does not work on restart, remove all the containers and config stored in $HOME/.jitsi-meet-cfg to be sure that all is clean and regenerated from .env file and compose.
