internalIp="$(ip a | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')"

# TODO: Define IP from .env
externalIp="$(dig +short myip.opendns.com @resolver1.opendns.com)"

echo "listening-port=3478
tls-listening-port=5349
listening-ip="$internalIp"
relay-ip="$internalIp"
external-ip="$externalIp"
realm=janus.hubl.in
server-name=janus.hubl.in
# use real-valid certificate/privatekey files
#cert=/etc/ssl/turn_server_cert.pem
#pkey=/etc/ssl/turn_server_pkey.pem"  | tee /etc/turnserver.conf

# TODO if we need TURN, but for now we only need STUN
#turnadmin -a -u $USERNAME -p $PASSWORD -r $REALM

echo "Start TURN server..."

turnserver
