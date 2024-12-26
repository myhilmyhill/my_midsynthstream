FROM debian:bookworm-20241016-slim

ADD --link https://github.com/davidmoreno/rtpmidid/releases/download/v23.12/rtpmidid_23.12_amd64.deb /
RUN apt update \
 && apt install -y pipewire-alsa pipewire alsa-utils curl avahi-daemon socat lsof
RUN dpkg -i --force-depends /rtpmidid_23.12_amd64.deb \
 && apt -fy install \
 && mkdir /var/run/rtpmidid \
 && rm -rf /var/lib/apt/lists/*

COPY ./docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
