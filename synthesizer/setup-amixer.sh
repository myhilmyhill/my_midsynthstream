#!/bin/bash
set -x

# arecord でミュートにされるデバイスは、ここでミュート解除
amixer -D $CAPTURE_DEVICE cset name='Line In Switch' 1
amixer -D $CAPTURE_DEVICE cset name='Line In Volume' 60%
