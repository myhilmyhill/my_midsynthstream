#!/bin/bash

rm -f /run/dbus/pid /run/avahi-daemon/pid
dbus-daemon --system --fork
avahi-daemon --daemonize

rtpmidid --ini /etc/rtpmidid/rtpmidid.ini &
rtpmidid_pid=$!

arecord -lL

if [ ! "${MIDI_OUT_PORT:=0}" -gt 0 ]; then
  echo 'Require to specify $MIDI_OUT_PORT:'
  aconnect -l
  exit 1
fi

aseqdump -p 0:1 | while read line; do
  if echo "$line" | grep -q "Port start" && echo "$line" | grep -q "128:1"; then
    echo "aconnect 128:1 $MIDI_OUT_PORT"
    aconnect 128:1 $MIDI_OUT_PORT
  fi
done &

# wait $pid
if [ "$CAPTURE_DEVICE" = "" ]; then
  echo 'Require to specify $CAPTURE_DEVICE:'
  arecord -lL
  exit 1
fi

if [ "$1" = "no-record" ]; then
  echo "no-record"
  arecord -lL
  wait $rtpmidid_pid
  # ここで一生待つ
fi

echo "録音開始"
rm -f /sockets/pcm_socket
socat UNIX-LISTEN:/sockets/pcm_socket,fork,mode=666,unlink-early EXEC:"arecord --format=S16_LE --rate=48000 --channels=2 -t raw -D \"$CAPTURE_DEVICE\"" &
socat_pid=$!
sleep 2
if ! kill -0 $socat_pid 2>/dev/null; then
  echo "socat failed to start"
  exit 1
fi

setup-amixer.sh
wait $socat_pid
