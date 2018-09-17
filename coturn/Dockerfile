FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    dnsutils \
    coturn \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
ADD . /app

EXPOSE 3478

ENTRYPOINT ["bash", "turnserver.sh"]