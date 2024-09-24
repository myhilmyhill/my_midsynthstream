#!/bin/bash
dbus-daemon --system --fork
avahi-daemon --daemonize

rtpmidid --ini /etc/rtpmidid/rtpmidid.ini &
pid=$!

echo "Please connect via rtpMIDI..."
until aplaymidi -l | grep -q "rtpmidid"; do
  sleep 1
done

echo "Please connect MIDI $MIDI_PORT..."
until aplaymidi -l | grep -q "$MIDI_PORT"; do
  sleep 1
done

echo "acconect rtpmidid $MIDI_OUT_PORT"
if ! aconnect 128 $MIDI_OUT_PORT; then
  aplaymidi -l
  exit 1
fi

# wait $pid
rm -f /sockets/pcm_socket
arecord -f cd -t raw | socat - UNIX-LISTEN:/sockets/pcm_socket,fork
