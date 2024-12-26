FROM debian:trixie-20241223-slim

ADD --link https://github.com/davidmoreno/rtpmidid/releases/download/v24.12/rtpmidid_24.12.2_amd64.deb /
RUN apt-get update \
 && apt-get install -y pipewire-alsa pipewire alsa-utils curl avahi-daemon socat lsof
RUN apt-get install -y /rtpmidid_24.12.2_amd64.deb
RUN mkdir /var/run/rtpmidid \
 && mkdir /run/dbus \
 && rm -rf /var/lib/apt/lists/*

COPY --link ./docker-entrypoint.sh /usr/local/bin/
CMD ["docker-entrypoint.sh"]
