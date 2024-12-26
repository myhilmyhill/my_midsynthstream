#!/bin/bash
dbus-daemon --system --fork
avahi-daemon --daemonize

rtpmidid --ini /etc/rtpmidid/rtpmidid.ini &
pid=$!

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
arecord --format=S16_LE --rate=44100 --channels=2 -t raw -D "$CAPTURE_DEVICE" | socat - UNIX-LISTEN:/sockets/pcm_socket,fork
