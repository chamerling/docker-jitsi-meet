FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    dnsutils \
    coturn \
  && rm -rf /var/lib/apt/lists/*

ADD turnserver.conf /etc/turnserver.conf
EXPOSE 3478

# // TODO
# // turnadmin -a -u $USERNAME -p $PASSWORD -r $REALM
# // check username password and realm in turnserver.conf

# TODO: Need certificates
# cert=/etc/ssl/turn_server_cert.pem
# pkey=/etc/ssl/turn_server_pkey.pem

ENTRYPOINT ["coturn"]
