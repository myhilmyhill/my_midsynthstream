#!/bin/bash

rm -f /run/dbus/pid /run/avahi-daemon/pid
dbus-daemon --system --fork
avahi-daemon --daemonize

rtpmidid --ini /etc/rtpmidid/rtpmidid.ini &
rtpmidid_pid=$!

echo "Please connect via rtpMIDI..."
until aconnect -l | grep -q "rtpmidid"; do
  sleep 1
done

if [ ! "${MIDI_OUT_PORT:=0}" -gt 0 ]; then
  echo 'Require to specify $MIDI_OUT_PORT:'
  acconect -l
  exit 1
fi

echo "Please connect MIDI device (port: $MIDI_OUT_PORT)..."
until aconnect -l | grep -q "client $MIDI_OUT_PORT"; do
  sleep 1
done

echo "acconect rtpmidid $MIDI_OUT_PORT"
if ! aconnect 128:1 $MIDI_OUT_PORT; then
  echo "FYI devices:"
  aconnect -l
  exit 1
fi

# wait $pid
rm -f /sockets/pcm_socket
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

{
  arecord --format=S16_LE --rate=48000 --channels=2 -t raw -D "$CAPTURE_DEVICE" | socat - UNIX-LISTEN:/sockets/pcm_socket,fork
} &
arecord_pid=$!
sleep 2
if ! kill -0 $arecord_pid 2>/dev/null; then
  echo "arecord failed to start"
  exit 1
fi

setup-amixer.sh
wait $arecord_pid
