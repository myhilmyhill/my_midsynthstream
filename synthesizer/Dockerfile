FROM debian:bookworm-20240904

RUN apt update \
 && apt install -y pipewire-alsa pipewire alsa-utils curl

RUN curl -LO https://github.com/davidmoreno/rtpmidid/releases/download/v23.12/rtpmidid_23.12_amd64.deb \
 && dpkg -i --force-depends rtpmidid_23.12_amd64.deb \
 && apt -fy install \
 && mkdir /var/run/rtpmidid

RUN apt update \
 && apt install -y avahi-daemon

RUN apt update \
 && apt install -y socat lsof

COPY ./docker-entrypoint.sh .
ENTRYPOINT ["./docker-entrypoint.sh"]
