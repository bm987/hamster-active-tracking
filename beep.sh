#!/bin/bash
#
# beep.sh - a simple beep
# 
# arg 1: frequency
# arg 2: fraction of a second (e.g., 999 is 999 ms)
#

_alarm() {
  ( \speaker-test --frequency $1 --test sine > /dev/null 2>&1)&
  pid=$!
  sleep 0.${2}s
  kill $pid
}

_alarm $1 $2 
