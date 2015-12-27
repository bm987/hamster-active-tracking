#!/bin/bash
#
# beep.sh - a simple beep
# 
# arg 1: frequency
# arg 2: fraction of a second (e.g., 999 is 999 ms)
#
#
# Update Dec. 2015: This is no longer used.  It's is a pretty
# unreliable way of making beeps.  If the system takes too long to
# fork speaker-test, it will get killed before it gets a chance to
# play any sound.  Playing WAV files with aplay is better.

_alarm() {
  ( \speaker-test --frequency $1 --test sine > /dev/null 2>&1)&
  pid=$!
  sleep 0.${2}s
  kill $pid
}

_alarm $1 $2 
