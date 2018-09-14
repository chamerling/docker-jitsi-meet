# Deployment on janus.hubl.in

1. Let's encrypt update
2. Change network and hostnames in docker-compose.yml from `meet.jitsi` to `janus.hubl.in`
3. Chnage hostnames in .env from `meet.jitsi` to `janus.hubl.in`
4. Set the `DOCKER_HOST_ADDRESS` to local IP in `.env` 54.36.8.91 (this is the IP of janus-hublin.linagora.dc2)
5. Expose port 5280 from prosody for http-bind
6. Update `/etc/nginx/sites-available/` and add jitsi.conf from file `janus.hubl.in/jitsi.conf`
7. Enable jitsi nginx configuration

## Troubleshooting

If it does not work on restart, remove all the containers and config stored in `$HOME/.jitsi-meet-cfg` to be sure that all is clean and regenerated from `.env` file and compose.
