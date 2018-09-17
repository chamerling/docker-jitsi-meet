# Deployment on janus.hubl.in

1. Let's encrypt update
2. Change network and hostnames in docker-compose.yml from `meet.jitsi` to `janus.hubl.in`
3. Chnage hostnames in .env from `meet.jitsi` to `janus.hubl.in`
4. Set the `DOCKER_HOST_ADDRESS` to local IP in `.env` 54.36.8.91 (this is the IP of janus-hublin.linagora.dc2)
5. Expose port 5280 from prosody for http-bind
6. Update `/etc/nginx/sites-available/` and add jitsi.conf from file `janus.hubl.in/jitsi.conf`
7. Enable jitsi nginx configuration

## TURN/STUN and co


Turn server is not required for jitsi: https://github.com/jitsi/jitsi-meet/issues/324

From https://github.com/jitsi/jitsi-meet/issues/324#issuecomment-279001655

    Use of a TURN server with Jitsi Videobridge is entirely redundant. It would only add extra hops and hence additional points of doubt and failure for your calls


From https://github.com/jitsi/jitsi-meet/issues/1567#issuecomment-301123830

    STUN is needed only in P2P mode if it is enabled. You do not need TURN cause jitsi-videobridge is relaying media for users. TURN is a media relay as it is and the jvb.

1. Checking if P2P mode must be activated: Yes in web/rootfs/defaults/config.js
2. Intall STUN server: coturn

## Troubleshooting

If it does not work on restart, remove all the containers and config stored in `$HOME/.jitsi-meet-cfg` to be sure that all is clean and regenerated from `.env` file and compose.
