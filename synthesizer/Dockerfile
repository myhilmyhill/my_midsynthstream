FROM ghcr.io/davidmoreno/rtpmidid:latest

USER root

RUN apt-get update \
 && apt-get install -y pipewire-alsa pipewire alsa-utils curl avahi-daemon socat lsof \
 && rm -rf /var/lib/apt/lists/*

COPY --link ./docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
